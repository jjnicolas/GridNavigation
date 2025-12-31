//
//  GridNavigationView.swift
//  GridNavigation
//
//  Created by Julien Nicolas on 9/2/25.
//

import SwiftUI

/// A high-performance, keyboard-navigable grid view with generic support for any data type
///
/// This view provides:
/// - O(1) navigation performance using direct array indexing
/// - Full keyboard navigation on macOS (arrow keys, return, escape)
/// - Touch navigation on iOS via NavigationLink
/// - Generic support for any data type conforming to GridNavigable
/// - Customizable cell and detail views
/// - Multiple column layout options
/// - Fixed: No longer limited to 16 items for keyboard navigation
/// - Safe nested navigation: Detail views can contain their own NavigationLinks
///   and focus states without conflicts
///
/// ## Focus Management
/// On macOS, the grid implements intelligent focus restoration that:
/// - Tracks when the grid is visible vs. hidden during navigation
/// - Only restores focus when returning directly to the grid view
/// - Avoids stealing focus from nested navigation or other focus states
/// - Prevents rebuild loops in nested GridNavigationView instances
///
/// Example usage:
/// ```swift
/// GridNavigationView(
///     items: myMovies,
///     columnCount: 3,
///     columnWidth: 150
/// ) { movie in
///     MovieCellView(movie: movie)
/// } detailContent: { movie in
///     MovieDetailView(movie: movie)
/// }
/// ```
public struct GridNavigationView<Item: GridNavigable, CellContent: View, DetailContent: View>: View {
    // MARK: - Configuration

    private let items: [Item]
    private let columns: [GridItem]
    private let columnCount: Int
    private let spacing: CGFloat
    private let horizontalPadding: CGFloat

    // MARK: - View Builders

    private let cellBuilder: (Item) -> CellContent
    private let detailBuilder: (Item) -> DetailContent

    // MARK: - State

    @State private var focusedIndex: Int?
    @State private var presentDetail = false
    @State private var selectedItem: Item?
    #if os(macOS)
        @State private var lastOpenedIndex: Int?
        @State private var isGridVisible = false
        @State private var shouldRestoreFocus = false
        @State private var isGridFocused = false  // AppKit-backed focus state
    #endif

    // MARK: - Initializer

    /// Creates a grid navigation view with custom column configuration
    ///
    /// - Parameters:
    ///   - items: Array of items conforming to GridNavigable
    ///   - columns: Array of GridItem defining column layout
    ///   - spacing: Spacing between grid items (default: 20)
    ///   - horizontalPadding: Horizontal padding for the grid (default: 16)
    ///   - cellContent: ViewBuilder for individual cell content
    ///   - detailContent: ViewBuilder for detail view content
    public init(
        items: [Item],
        columns: [GridItem],
        spacing: CGFloat = 20,
        horizontalPadding: CGFloat = 16,
        @ViewBuilder cellContent: @escaping (Item) -> CellContent,
        @ViewBuilder detailContent: @escaping (Item) -> DetailContent
    ) {
        self.items = items
        self.columns = columns
        self.columnCount = columns.count
        self.spacing = spacing
        self.horizontalPadding = horizontalPadding
        self.cellBuilder = cellContent
        self.detailBuilder = detailContent
    }

    public var body: some View {
        #if os(macOS)
        macOSBody
        #else
        iOSBody
        #endif
    }

    #if os(iOS)
    private var iOSBody: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        cellBuilder(item)
                            .onTapGesture {
                                selectedItem = item
                                presentDetail = true
                            }
                            .id(item.id)
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical)
            }
            .navigationDestination(isPresented: $presentDetail) {
                presentedDetailView()
            }
        }
    }
    #endif

    #if os(macOS)
    private var macOSBody: some View {
        ScrollViewReader { proxy in
            FocusableGridContainer(
                isFocused: $isGridFocused,
                onKeyEvent: { event in
                    handleKeyEvent(event)
                }
            ) {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: spacing) {
                        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                            ZStack {
                                cellBuilder(item)

                                // Visual selection indicator
                                if focusedIndex == index {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(isGridFocused ? Color.accentColor : Color.gray, lineWidth: 3)
                                        .allowsHitTesting(false)
                                }
                            }
                            .onTapGesture {
                                lastOpenedIndex = index
                                selectedItem = item
                                presentDetail = true
                            }
                            .id(item.id)
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.vertical)
                    .onChange(of: focusedIndex) { _, newIndex in
                        scrollToFocusedItem(newIndex, proxy: proxy)
                    }
                }
            }
            .navigationDestination(isPresented: $presentDetail) {
                presentedDetailView()
            }
            .onAppear {
                isGridVisible = true
                if shouldRestoreFocus {
                    restoreFocusAfterPop()
                    shouldRestoreFocus = false
                }
            }
            .onDisappear {
                isGridVisible = false
            }
            .task {
                // Set initial focus after a small delay
                try? await Task.sleep(nanoseconds: 50_000_000)
                if isGridVisible {
                    focusedIndex = items.isEmpty ? nil : 0
                    isGridFocused = true
                }
            }
            .onChange(of: items.count) { oldCount, newCount in
                if oldCount == 0 && newCount > 0 {
                    Task {
                        try? await Task.sleep(nanoseconds: 50_000_000)
                        if isGridVisible {
                            focusedIndex = 0
                            isGridFocused = true
                        }
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("lateralNavigation"))) { notification in
                if let itemId = notification.object as? UUID,
                   let index = items.firstIndex(where: { $0.id == itemId }) {
                    lastOpenedIndex = index
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("restoreGridFocus"))) { _ in
                if isGridVisible {
                    isGridFocused = true
                }
            }
            .onChange(of: presentDetail) { _, isPresenting in
                if !isPresenting {
                    if isGridVisible {
                        restoreFocusAfterPop()
                    } else {
                        shouldRestoreFocus = true
                    }
                }
            }
        }
    }

    private func handleKeyEvent(_ event: GridKeyEvent) -> Bool {
        switch event {
        case .up:
            guard let currentIndex = focusedIndex, currentIndex >= columnCount else { return false }
            focusedIndex = currentIndex - columnCount
            return true
        case .down:
            guard let currentIndex = focusedIndex else { return false }
            let next = currentIndex + columnCount
            guard next < items.count else { return false }
            focusedIndex = next
            return true
        case .left:
            guard let currentIndex = focusedIndex, currentIndex > 0 else { return false }
            focusedIndex = currentIndex - 1
            return true
        case .right:
            guard let currentIndex = focusedIndex else { return false }
            let next = currentIndex + 1
            guard next < items.count else { return false }
            focusedIndex = next
            return true
        case .return:
            guard let index = focusedIndex else { return false }
            handleReturnPress(index)
            return true
        case .escape:
            return false  // Let it bubble up for navigation
        }
    }
    #endif

    // MARK: - Private Methods

    #if os(macOS)
        private func scrollToFocusedItem(_ newIndex: Int?, proxy: ScrollViewProxy) {
            guard let index = newIndex, items.indices.contains(index) else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                proxy.scrollTo(items[index].id, anchor: .center)
            }
        }
    #endif

    @ViewBuilder
    private func presentedDetailView() -> some View {
        if let item = selectedItem {
            detailBuilder(item)
        } else {
            Text("No item selected")
        }
    }

    #if os(macOS)
        private func handleReturnPress(_ index: Int) {
            guard items.indices.contains(index) else { return }
            let item = items[index]
            selectedItem = item
            lastOpenedIndex = index
            presentDetail = true
        }

        private func restoreFocusAfterPop() {
            guard let index = lastOpenedIndex else { return }
            Task {
                // Add a small delay to ensure navigation transition is complete
                try? await Task.sleep(nanoseconds: 100_000_000) // 100ms delay

                guard isGridVisible else { return }

                // Restore focus - AppKit will handle makeFirstResponder
                focusedIndex = index
                isGridFocused = true
            }
        }
    #endif
}

// MARK: - Convenience Initializers

public extension GridNavigationView {
    /// Creates a grid navigation view with fixed-width columns
    ///
    /// - Parameters:
    ///   - items: Array of items conforming to GridNavigable
    ///   - columnCount: Number of columns in the grid
    ///   - columnWidth: Fixed width for each column
    ///   - spacing: Spacing between grid items (default: 20)
    ///   - horizontalPadding: Horizontal padding for the grid (default: 16)
    ///   - cellContent: ViewBuilder for individual cell content
    ///   - detailContent: ViewBuilder for detail view content
    init(
        items: [Item],
        columnCount: Int,
        columnWidth: CGFloat,
        spacing: CGFloat = 20,
        horizontalPadding: CGFloat = 16,
        @ViewBuilder cellContent: @escaping (Item) -> CellContent,
        @ViewBuilder detailContent: @escaping (Item) -> DetailContent
    ) {
        let columns = Array(repeating: GridItem(.fixed(columnWidth)), count: columnCount)
        self.init(
            items: items,
            columns: columns,
            spacing: spacing,
            horizontalPadding: horizontalPadding,
            cellContent: cellContent,
            detailContent: detailContent
        )
    }

    /// Creates a grid navigation view with adaptive columns
    ///
    /// - Parameters:
    ///   - items: Array of items conforming to GridNavigable
    ///   - minItemWidth: Minimum width for adaptive columns (default: 150)
    ///   - maxItemWidth: Maximum width for adaptive columns (default: 200)
    ///   - spacing: Spacing between grid items (default: 20)
    ///   - horizontalPadding: Horizontal padding for the grid (default: 16)
    ///   - cellContent: ViewBuilder for individual cell content
    ///   - detailContent: ViewBuilder for detail view content
    init(
        items: [Item],
        minItemWidth: CGFloat = 150,
        maxItemWidth: CGFloat = 200,
        spacing: CGFloat = 20,
        horizontalPadding: CGFloat = 16,
        @ViewBuilder cellContent: @escaping (Item) -> CellContent,
        @ViewBuilder detailContent: @escaping (Item) -> DetailContent
    ) {
        let columns = [GridItem(.adaptive(minimum: minItemWidth, maximum: maxItemWidth))]
        self.init(
            items: items,
            columns: columns,
            spacing: spacing,
            horizontalPadding: horizontalPadding,
            cellContent: cellContent,
            detailContent: detailContent
        )
    }
}
