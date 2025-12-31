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
struct FocusableGridContainer<Content: View>: NSViewRepresentable {
    @Binding var isFocused: Bool
    var onKeyEvent: ((GridKeyEvent) -> Bool)?
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

    func makeNSView(context: Context) -> FocusableContainerView {
        let container = FocusableContainerView()
        container.onFocusChange = { focused in
            DispatchQueue.main.async {
                self.isFocused = focused
            }
        }
        container.onKeyEvent = onKeyEvent

        // Create hosting view for SwiftUI content
        let hostingView = NSHostingView(rootView: content)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(hostingView)

        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            hostingView.topAnchor.constraint(equalTo: container.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        container.hostingView = hostingView
        return container
    }

    func updateNSView(_ nsView: FocusableContainerView, context: Context) {
        nsView.onKeyEvent = onKeyEvent
        (nsView.hostingView as? NSHostingView<Content>)?.rootView = content

        if isFocused && nsView.window?.firstResponder !== nsView {
            DispatchQueue.main.async {
                nsView.window?.makeFirstResponder(nsView)
            }
        }
    }
}

/// Container NSView that handles keyboard focus and events
class FocusableContainerView: NSView {
    var hostingView: NSView?
    var onFocusChange: ((Bool) -> Void)?
    var onKeyEvent: ((GridKeyEvent) -> Bool)?

    override var acceptsFirstResponder: Bool { true }

    override var canBecomeKeyView: Bool { true }

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

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        // Auto-claim focus when added to window
        if window != nil {
            DispatchQueue.main.async { [weak self] in
                self?.window?.makeFirstResponder(self)
            }
        }
    }

    override func keyDown(with event: NSEvent) {
        let handled = handleKey(event)
        if !handled {
            // Pass unhandled events up the responder chain
            nextResponder?.keyDown(with: event)
        }
    }

    // Handle command-key combinations
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        // Handle ⌘F - post notification to activate search
        if event.modifierFlags.contains(.command),
           event.charactersIgnoringModifiers == "f" {
            NotificationCenter.default.post(name: Notification.Name("activateSearch"), object: nil)
            return true
        }
        // Pass other command keys through
        if event.modifierFlags.contains(.command) {
            return super.performKeyEquivalent(with: event)
        }
        return false
    }

    private func handleKey(_ event: NSEvent) -> Bool {
        switch event.keyCode {
        case 126: return onKeyEvent?(.up) ?? false
        case 125: return onKeyEvent?(.down) ?? false
        case 123: return onKeyEvent?(.left) ?? false
        case 124: return onKeyEvent?(.right) ?? false
        case 36: return onKeyEvent?(.return) ?? false
        case 53: return onKeyEvent?(.escape) ?? false
        default: return false
        }
    }

    // Allow mouse clicks to claim focus
    override func mouseDown(with event: NSEvent) {
        window?.makeFirstResponder(self)
        super.mouseDown(with: event)
    }
}
#endif
