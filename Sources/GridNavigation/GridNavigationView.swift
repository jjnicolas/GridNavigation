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
        @FocusState private var isScrollViewFocused: Bool
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
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        ZStack {
                            cellBuilder(item)

                            #if os(macOS)
                            // Visual selection indicator
                            if focusedIndex == index {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.accentColor, lineWidth: 3)
                                    .allowsHitTesting(false)
                            }
                            #endif
                        }
                        .onTapGesture {
                            #if os(macOS)
                            lastOpenedIndex = index
                            #endif
                            selectedItem = item
                            presentDetail = true
                        }
                        .id(item.id)
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical)
                #if os(macOS)
                    .onChange(of: focusedIndex) { _, newIndex in
                        scrollToFocusedItem(newIndex, proxy: proxy)
                    }
                #endif
            }
            #if os(macOS)
            .focusable()
            .focused($isScrollViewFocused)
            .focusEffectDisabled()  // Disable system focus ring, use custom indicators instead
            .onKeyPress(keys: [.upArrow, .downArrow, .leftArrow, .rightArrow]) { keyPress in
                guard let currentIndex = focusedIndex else { return .ignored }

                let nextIndex: Int?
                switch keyPress.key {
                case .upArrow:
                    nextIndex = currentIndex >= columnCount ? currentIndex - columnCount : nil
                case .downArrow:
                    let next = currentIndex + columnCount
                    nextIndex = next < items.count ? next : nil
                case .leftArrow:
                    nextIndex = currentIndex > 0 ? currentIndex - 1 : nil
                case .rightArrow:
                    nextIndex = currentIndex + 1 < items.count ? currentIndex + 1 : nil
                default:
                    nextIndex = nil
                }

                guard let newIndex = nextIndex else { return .ignored }
                focusedIndex = newIndex
                return .handled
            }
            .onKeyPress(keys: [.return]) { _ in
                guard let index = focusedIndex else { return .ignored }
                handleReturnPress(index)
                return .handled
            }
            .task {
                // Set initial focus after a small delay to ensure view hierarchy is ready
                try? await Task.sleep(nanoseconds: 50_000_000) // 50ms delay
                // Only claim focus if the grid is currently visible
                // This prevents stealing focus from detail views in nested grids
                // Set focusedIndex and isScrollViewFocused together so blue border shows immediately
                if isGridVisible {
                    focusedIndex = items.isEmpty ? nil : 0
                    isScrollViewFocused = true
                }
            }
            .onChange(of: items.count) { oldCount, newCount in
                // When items are first loaded (0 -> n), focus the first item
                if oldCount == 0 && newCount > 0 {
                    Task {
                        try? await Task.sleep(nanoseconds: 50_000_000)
                        // Only claim focus if the grid is currently visible
                        // Set focusedIndex and isScrollViewFocused together so blue border shows immediately
                        if isGridVisible {
                            focusedIndex = 0
                            isScrollViewFocused = true
                        }
                    }
                }
            }
            #endif
            .navigationDestination(isPresented: $presentDetail) {
                presentedDetailView()
            }
            #if os(macOS)
            .onAppear {
                // Mark the grid as visible and restore focus if needed
                isGridVisible = true
                if shouldRestoreFocus {
                    restoreFocusAfterPop()
                    shouldRestoreFocus = false
                }
            }
            .onDisappear {
                // Grid is no longer visible (navigated away or window closed)
                isGridVisible = false
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("lateralNavigation"))) { notification in
                // Update lastOpenedIndex when detail view reports navigation to a different item
                // This ensures focus returns to the correct thumbnail after dismissing detail view
                if let itemId = notification.object as? UUID,
                   let index = items.firstIndex(where: { $0.id == itemId }) {
                    lastOpenedIndex = index
                }
            }
            .onChange(of: presentDetail) { _, isPresenting in
                // When detail view is dismissed (presentDetail: true -> false),
                // schedule focus restoration. Only restore if grid is visible
                // to avoid conflicts with nested navigation focus states.
                if !isPresenting {
                    // If grid is currently visible, restore immediately
                    // Otherwise, flag for restoration when grid reappears
                    if isGridVisible {
                        restoreFocusAfterPop()
                    } else {
                        shouldRestoreFocus = true
                    }
                }
            }
            #endif
        }
    }

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
                // and view hierarchy is stable before attempting to restore focus
                try? await Task.sleep(nanoseconds: 100_000_000) // 100ms delay

                // Double-check that the grid is still visible after the delay
                // If the user navigated away again during the delay, skip restoration
                guard isGridVisible else { return }

                // Restore the focused index and reclaim focus for the grid
                focusedIndex = index
                isScrollViewFocused = true
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
