// Copyright © 2020 Niklas Buelow. All rights reserved.

import UIKit

/// The Droid Type specifies the used character in the game.
enum DroidType: String {
    case T33 = "T33"
    case D42 = "D42"

    /// The current character set by the user
    static var current: DroidType = .D42
}
