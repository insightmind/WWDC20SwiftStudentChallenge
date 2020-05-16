// Copyright © 2020 Niklas Buelow. All rights reserved.

import CoreGraphics
import Foundation

/// The LoadedLevel model contains the processed data of the LevelLoader process.
///
/// It is used for the actual presentation and logic of a level.
struct LoadedLevel {
    let tileMap: DecodedLevelTileMap
    let startLocation: CGPoint
    let finishLocation: CGPoint
    let mapSize: CGSize
    let teleportations: [BlockStyle: TeleportationPair]

    /// Resolves the block at the specified location. Returns nil if the location is outside the map or contains air at the location.
    ///
    /// - Parameter indexLocation: The index location of the blocked. These values will be rounded to nearest integer.
    func block(at indexLocation: CGPoint) -> Block? {
        let index = (xIndex: Int(round(indexLocation.x)), yIndex: Int(round(indexLocation.y)))

        // We need to make sure only valid coordinates are evaluated.
        guard index.xIndex >= 0 && index.xIndex < Int(mapSize.width) else { return nil }
        guard index.yIndex >= 0 && index.yIndex < Int(mapSize.height) else { return nil }

        return tileMap[index.xIndex][index.yIndex]
    }
}
