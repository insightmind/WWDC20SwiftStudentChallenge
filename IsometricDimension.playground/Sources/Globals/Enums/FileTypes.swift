// Copyright © 2020 Niklas Buelow. All rights reserved.

import Foundation

/**
 * This enum represents used file types in this application.
 * It does not include any image extension as they are automatically handled by SpriteKit
 */
enum FileTypes: String {
    case mp3

    /*
     * .isomap is used to encode the tileMap of a level.
     */
    case isomap

    /*
     * .isoconfig encodes the parameters for a specific level.
     */
    case isoconfig
}
