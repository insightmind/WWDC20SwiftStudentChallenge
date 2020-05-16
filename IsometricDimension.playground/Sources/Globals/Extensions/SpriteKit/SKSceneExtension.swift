// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

extension SKNode {
    /// Finds the top most node at the touch location. You have to supply a whitelist
    /// of the nodes name to be able to recognize it.
    ///
    /// - Parameters:
    ///   - touches: The touches from the user
    ///   - whiteList: A whitelist of node names which should be used to determine the node at the location
    /// - Returns: The node at the location of touch if found.
    func findTouchedNode(for touches: Set<UITouch>, with whiteList: [String] = []) -> SKNode? {
        // We resolve the location of the first touch
        guard let firstTouch = touches.first else { return nil }
        let location = firstTouch.location(in: self)

        // We find a named node if available.
        return nodes(at: location).first { node in
            guard let name = node.name else { return false }
            return whiteList.contains(name)
        }
    }
}
