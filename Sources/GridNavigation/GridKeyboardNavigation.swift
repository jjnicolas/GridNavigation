//
//  GridKeyboardNavigation.swift
//  GridNavigation
//
//  Created by Julien Nicolas on 9/2/25.
//

import SwiftUI

#if os(macOS)

    /// View modifier that provides keyboard navigation for grid layouts on macOS
    public struct GridKeyboardNavigationModifier: ViewModifier {
        var focusedIndex: FocusState<Int?>.Binding
        let itemCount: Int
        let columnCount: Int
        let onReturnPressed: (Int) -> Void

        public func body(content: Content) -> some View {
            content
                .onKeyPress(keys: [.upArrow, .downArrow, .leftArrow, .rightArrow]) { keyPress in
                    guard let currentIndex = focusedIndex.wrappedValue else { return .ignored }

                    let nextIndex: Int?
                    switch keyPress.key {
                    case .upArrow:
                        nextIndex = currentIndex >= columnCount ? currentIndex - columnCount : nil
                    case .downArrow:
                        let next = currentIndex + columnCount
                        nextIndex = next < itemCount ? next : nil
                    case .leftArrow:
                        nextIndex = currentIndex > 0 ? currentIndex - 1 : nil
                    case .rightArrow:
                        nextIndex = currentIndex + 1 < itemCount ? currentIndex + 1 : nil
                    default:
                        nextIndex = nil
                    }

                    guard let newIndex = nextIndex else { return .ignored }
                    focusedIndex.wrappedValue = newIndex
                    return .handled
                }
                .onKeyPress(keys: [.return]) { _ in
                    guard let index = focusedIndex.wrappedValue else { return .ignored }
                    focusedIndex.wrappedValue = nil
                    onReturnPressed(index)
                    return .handled
                }
        }
    }

    public extension View {
        /// Adds keyboard navigation support for grid layouts on macOS
        ///
        /// - Parameters:
        ///   - focusedIndex: Binding to the currently focused grid index
        ///   - itemCount: Total number of items in the grid
        ///   - columnCount: Number of columns in the grid
        ///   - onReturnPressed: Callback for when Return key is pressed on an item
        /// - Returns: View with keyboard navigation support
        func gridKeyboardNavigation(
            focusedIndex: FocusState<Int?>.Binding,
            itemCount: Int,
            columnCount: Int,
            onReturnPressed: @escaping (Int) -> Void,
        ) -> some View {
            modifier(GridKeyboardNavigationModifier(
                focusedIndex: focusedIndex,
                itemCount: itemCount,
                columnCount: columnCount,
                onReturnPressed: onReturnPressed,
            ))
        }
    }

#endif
