// Copyright © 2020 Niklas Buelow. All rights reserved.

import Foundation

/// The LevelManager manages the actual logic and gamification aspects of a level.
///
/// In our case this is just gathering the duration to complete the level and
/// comparing the current state to the goals defined by the config.
class LevelManager {
    // MARK: - Properties
    private let config: LevelConfig
    private var timer: Timer?

    /// The currentTime used to solve the level
    private var currentTime: TimeInterval = 0.0

    /// The currentRating for the currentTime used. We save this locally to only inform the delegate
    /// on changes.
    private var currentRating: Rating = .threeStars {
        didSet {
            guard oldValue != currentRating else { return }
            delegate?.ratingDidChange(newRating: currentRating)
        }
    }

    private weak var delegate: LevelManagerDelegate?

    // MARK: - Initialization
    /// Intializes a new LevelManager with the given LevelConfig and delegate
    init(config: LevelConfig, delegate: LevelManagerDelegate) {
        self.config = config
        self.delegate = delegate
    }

    // MARK: - Level Timer
    /// Starts the timer of the level. Use this method as well if you resume the level after pausing it beforehand.
    func startLevel() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentTime += 1.0
            self.currentRating = self.config.goals.getRating(for: self.currentTime)
        }
    }

    /// Pauses the level by stopping the time measurement.
    func pauseLevel() {
        timer?.invalidate()
    }

    /// Generates the LevelCompletion model for the currentTime and rating.
    /// - Returns: LevelCompletion model containing information about the current state of the completion score.
    func getResults() -> LevelCompletion {
        return LevelCompletion(rating: config.goals.getRating(for: currentTime), goals: config.goals, usedTime: currentTime)
    }
}
