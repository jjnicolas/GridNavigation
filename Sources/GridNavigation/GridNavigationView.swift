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

    // MARK: - View Builders

    private let cellBuilder: (Item) -> CellContent
    private let detailBuilder: (Item) -> DetailContent

    // MARK: - State

    #if os(macOS)
    @FocusState private var focusedIndex: Int?
    #endif
    @State private var presentDetail = false
    @State private var selectedItem: Item?
    #if os(macOS)
    @State private var lastOpenedIndex: Int?
    #endif

    // MARK: - Initializer

    /// Creates a grid navigation view with custom column configuration
    ///
    /// - Parameters:
    ///   - items: Array of items conforming to GridNavigable
    ///   - columns: Array of GridItem defining column layout
    ///   - spacing: Spacing between grid items (default: 20)
    ///   - cellContent: ViewBuilder for individual cell content
    ///   - detailContent: ViewBuilder for detail view content
    public init(
        items: [Item],
        columns: [GridItem],
        spacing: CGFloat = 20,
        @ViewBuilder cellContent: @escaping (Item) -> CellContent,
        @ViewBuilder detailContent: @escaping (Item) -> DetailContent
    ) {
        self.items = items
        self.columns = columns
        self.columnCount = columns.count
        self.spacing = spacing
        self.cellBuilder = cellContent
        self.detailBuilder = detailContent
    }

    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        #if os(macOS)
                        cellBuilder(item)
                            .focusable()
                            .focused($focusedIndex, equals: index)
                            .onTapGesture {
                                selectedItem = item
                                presentDetail = true
                            }
                        #else
                        NavigationLink(value: item) {
                            cellBuilder(item)
                        }
                        #endif
                    }
                }
                .padding()
                #if os(macOS)
                .onChange(of: focusedIndex) { _, newIndex in
                    scrollToFocusedItem(newIndex, proxy: proxy)
                }
                #endif
            }
            .navigationDestination(for: Item.self) { item in
                itemDetailView(for: item)
            }
            .navigationDestination(isPresented: $presentDetail) {
                presentedDetailView()
            }
            #if os(macOS)
            .gridKeyboardNavigation(
                focusedIndex: $focusedIndex,
                itemCount: items.count,
                columnCount: columnCount,
                onReturnPressed: handleReturnPress
            )
            .task {
                focusedIndex = items.isEmpty ? nil : 0
            }
            #endif
        }
    }

    // MARK: - Private Methods

    #if os(macOS)
    private func scrollToFocusedItem(_ newIndex: Int?, proxy: ScrollViewProxy) {
        guard let index = newIndex, items.indices.contains(index) else { return }
        withAnimation {
            proxy.scrollTo(items[index].id, anchor: UnitPoint.center)
        }
    }
    #endif

    private func itemDetailView(for item: Item) -> some View {
        detailBuilder(item)
            #if os(macOS)
            .onAppear {
                if let index = items.firstIndex(where: { $0.id == item.id }) {
                    lastOpenedIndex = index
                }
            }
            .onDisappear {
                restoreFocusAfterPop()
            }
            #endif
    }

    @ViewBuilder
    private func presentedDetailView() -> some View {
        if let item = selectedItem {
            detailBuilder(item)
                #if os(macOS)
                .onAppear {
                    lastOpenedIndex = selectedItem.flatMap { item in
                        items.firstIndex(where: { $0.id == item.id })
                    }
                }
                .onDisappear {
                    restoreFocusAfterPop()
                }
                #endif
        } else {
            Text("No item selected")
                #if os(macOS)
                .onDisappear {
                    restoreFocusAfterPop()
                }
                #endif
        }
    }

    #if os(macOS)
    private func handleReturnPress(_ index: Int) {
        guard items.indices.contains(index) else { return }
        let item = items[index] // O(1) direct access
        selectedItem = item
        lastOpenedIndex = index
        presentDetail = true
    }

    private func restoreFocusAfterPop() {
        guard let index = lastOpenedIndex else { return }
        Task {
            focusedIndex = index
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
    ///   - cellContent: ViewBuilder for individual cell content
    ///   - detailContent: ViewBuilder for detail view content
    init(
        items: [Item],
        columnCount: Int,
        columnWidth: CGFloat,
        spacing: CGFloat = 20,
        @ViewBuilder cellContent: @escaping (Item) -> CellContent,
        @ViewBuilder detailContent: @escaping (Item) -> DetailContent
    ) {
        let columns = Array(repeating: GridItem(.fixed(columnWidth)), count: columnCount)
        self.init(
            items: items,
            columns: columns,
            spacing: spacing,
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
    ///   - cellContent: ViewBuilder for individual cell content
    ///   - detailContent: ViewBuilder for detail view content
    init(
        items: [Item],
        minItemWidth: CGFloat = 150,
        maxItemWidth: CGFloat = 200,
        spacing: CGFloat = 20,
        @ViewBuilder cellContent: @escaping (Item) -> CellContent,
        @ViewBuilder detailContent: @escaping (Item) -> DetailContent
    ) {
        let columns = [GridItem(.adaptive(minimum: minItemWidth, maximum: maxItemWidth))]
        self.init(
            items: items,
            columns: columns,
            spacing: spacing,
            cellContent: cellContent,
            detailContent: detailContent
        )
    }
}
