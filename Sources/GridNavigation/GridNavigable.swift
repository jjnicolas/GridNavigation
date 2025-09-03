//
//  GridNavigable.swift
//  GridNavigation
//
//  Created by Julien Nicolas on 9/2/25.
//

import SwiftUI

/// Protocol for types that can be used in a navigable grid
public protocol GridNavigable: Identifiable, Hashable {
    /// Unique identifier for the item
    var id: UUID { get }
}

/// Default implementation for GridNavigable using UUID
public extension GridNavigable where Self: Identifiable, ID == UUID {
    var id: UUID { self.id }
}
