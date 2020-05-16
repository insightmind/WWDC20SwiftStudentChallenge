// Copyright © 2020 Niklas Buelow. All rights reserved.

import CoreGraphics

/// A teleportation pair allows identification of two associated teleportation
/// locations.
struct TeleportationPair {
    var firstBlockLocation: CGPoint
    var secondBlockLocation: CGPoint

    /// Returns the other teleportation location.
    /// If the location is inequal to both locations nil will be returned.
    func getTeleportedLocation(from location: CGPoint) -> CGPoint? {
        if location == firstBlockLocation {
            return secondBlockLocation
        } else if location == secondBlockLocation {
            return firstBlockLocation
        }

        return nil
    }
}
