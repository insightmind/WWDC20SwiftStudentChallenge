// Copyright © 2020 Niklas Buelow. All rights reserved.

import Foundation

/// The LevelConfig contains the necessary informations to load the level map
/// and allow play of the level.
public struct LevelConfig: Codable {
    /// The filename of the unprocessesed map on the device.
    var rawMapFile: String = ""

    /// The initial direction is the direction which is applied to the droid on load.
    var initialDirection: MoveDirection = .upRight

    /// The goals which are set to achieve the different ratings in the level.
    var goals: LevelGoals
}
