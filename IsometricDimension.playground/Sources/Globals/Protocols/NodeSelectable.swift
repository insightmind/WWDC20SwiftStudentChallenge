// Copyright © 2020 Niklas Buelow. All rights reserved.

import Foundation

/// NodeSelector ensures that a enum can implement the NodeSelectable protocol more easily
public typealias NodeSelector = NodeSelectable & CaseIterable

/// NodeSelectable protocol allows to statically type the names of the available nodes in the scene.
public protocol NodeSelectable {
    var isUserInteractable: Bool { get }
}

extension NodeSelectable where Self: CaseIterable & RawRepresentable {
    /// The selectable nodes are all NodeSelectors which are user interactable
    static var selectableNodes: [Self.RawValue] {
        return allCases.filter { $0.isUserInteractable }.compactMap { $0.rawValue }
    }
}
