// Copyright © 2020 Niklas Buelow. All rights reserved.

import Foundation

/// This model defines the goals for a specific level to achieve the specified rating.
struct LevelGoals: Codable {
    /// Maximum time in seconds to achieve onStar
    var oneStar: TimeInterval
    /// Maximum time in seconds to achieve twoStars
    var twoStars: TimeInterval
    /// Maximum time in seconds to achieve threeStars
    var threeStars: TimeInterval

    /// Resolves the rating for the completion time of a level.
    func getRating(for completionTime: TimeInterval) -> Rating {
        switch completionTime {
        case 0 ..< threeStars:
            return .threeStars

        case threeStars ..< twoStars:
            return .twoStars

        case twoStars ..< oneStar:
            return .oneStar

        default:
            return .noStar
        }
    }
}
