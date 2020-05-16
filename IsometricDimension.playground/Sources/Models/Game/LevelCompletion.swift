// Copyright © 2020 Niklas Buelow. All rights reserved.

import Foundation

/// The LevelCompletion model contains the necessary information about
/// the completion of a level, so it can be reported to the user by
/// the GameCompletionScene
struct LevelCompletion {
    var rating: Rating
    var goals: LevelGoals
    var usedTime: TimeInterval
}
