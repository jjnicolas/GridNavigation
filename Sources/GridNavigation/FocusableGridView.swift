//
//  FocusableGridView.swift
//  GridNavigation
//
//  AppKit bridge for reliable keyboard focus management on macOS.
//

import SwiftUI

#if os(macOS)
import AppKit

/// Key event types that can be handled by the focusable view
public enum GridKeyEvent {
    case up, down, left, right
    case `return`
    case escape
}

/// A SwiftUI wrapper that provides reliable keyboard focus using AppKit's responder chain.
///
/// This solves SwiftUI's FocusState limitations by directly using NSView's
/// `becomeFirstResponder()` and `resignFirstResponder()` mechanisms.
struct FocusableGridContainer<Content: View>: NSViewRepresentable {
    /// Binding to control focus state - set to true to claim focus
    @Binding var isFocused: Bool

    /// Callback when a navigation key is pressed
    var onKeyEvent: ((GridKeyEvent) -> Bool)?

    /// The SwiftUI content to display
    let content: Content

    init(
        isFocused: Binding<Bool>,
        onKeyEvent: ((GridKeyEvent) -> Bool)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self._isFocused = isFocused
        self.onKeyEvent = onKeyEvent
        self.content = content()
    }

    func makeNSView(context: Context) -> FocusableNSHostingView<Content> {
        let view = FocusableNSHostingView(
            rootView: content,
            onFocusChange: { focused in
                DispatchQueue.main.async {
                    isFocused = focused
                }
            },
            onKeyEvent: onKeyEvent
        )
        return view
    }

    func updateNSView(_ nsView: FocusableNSHostingView<Content>, context: Context) {
        nsView.rootView = content
        nsView.onKeyEvent = onKeyEvent

        // If we want focus and don't have it, claim it
        if isFocused && nsView.window?.firstResponder !== nsView {
            // Use async to avoid modifying state during view update
            DispatchQueue.main.async {
                nsView.window?.makeFirstResponder(nsView)
            }
        }
    }
}

/// An NSView that can become first responder and handles keyboard events
class FocusableNSHostingView<Content: View>: NSHostingView<Content> {
    var onFocusChange: ((Bool) -> Void)?
    var onKeyEvent: ((GridKeyEvent) -> Bool)?

    init(rootView: Content, onFocusChange: ((Bool) -> Void)?, onKeyEvent: ((GridKeyEvent) -> Bool)?) {
        self.onFocusChange = onFocusChange
        self.onKeyEvent = onKeyEvent
        super.init(rootView: rootView)
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init(rootView: Content) {
        super.init(rootView: rootView)
    }

    override var acceptsFirstResponder: Bool { true }

    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result {
            onFocusChange?(true)
        }
        return result
    }

    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result {
            onFocusChange?(false)
        }
        return result
    }

    override func keyDown(with event: NSEvent) {
        let handled: Bool

        switch event.keyCode {
        case 126: // Up arrow
            handled = onKeyEvent?(.up) ?? false
        case 125: // Down arrow
            handled = onKeyEvent?(.down) ?? false
        case 123: // Left arrow
            handled = onKeyEvent?(.left) ?? false
        case 124: // Right arrow
            handled = onKeyEvent?(.right) ?? false
        case 36: // Return
            handled = onKeyEvent?(.return) ?? false
        case 53: // Escape
            handled = onKeyEvent?(.escape) ?? false
        default:
            handled = false
        }

        if !handled {
            super.keyDown(with: event)
        }
    }

    // Prevent the system beep for unhandled keys we care about
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        switch event.keyCode {
        case 126, 125, 123, 124, 36, 53:
            return true
        default:
            return super.performKeyEquivalent(with: event)
        }
    }
}
#endif
