// Copyright © 2020 Niklas Buelow. All rights reserved.

import Foundation

/// Implement this delegate to be informed on rating changes interactively.
protocol LevelManagerDelegate: AnyObject {

    /// This method is being called by the LevelManager if the rating changed.
    func ratingDidChange(newRating: Rating)
}
