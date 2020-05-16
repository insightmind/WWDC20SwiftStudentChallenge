// Copyright © 2020 Niklas Buelow. All rights reserved.

import Foundation

/// The LevelLoadingError enum contains the possible errors which can occur while processing
/// a unprocessesed tile map.
enum LevelLoadingError: Error {
    case invalidEntryPoints(numOfPoints: Int)
    case invalidFinishPoints(numOfPoints: Int)
    case invalidTeleportationPoints
    case unknownBlock
}
