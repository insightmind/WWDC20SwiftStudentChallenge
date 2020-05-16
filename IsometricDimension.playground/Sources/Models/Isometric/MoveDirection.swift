// Copyright © 2020 Niklas Buelow. All rights reserved.

import CoreGraphics

/// The move direction specifies as its name suggests the direction the actor can use.
/// These are located on the isometric plane in each direction and in their inverse direction
enum MoveDirection: String, Codable {
    case downLeft
    case downRight
    case upLeft
    case upRight

    /// The normalized direction vector of the move direction.
    var directionVector: CGVector {
        switch self {
        case.downLeft:
            return IsometricAxis.left.vector

        case .downRight:
            return IsometricAxis.right.vector

        case .upLeft:
            return IsometricAxis.right.vector.multiplied(by: -1)

        case .upRight:
            return IsometricAxis.left.vector.multiplied(by: -1)
        }
    }
}
