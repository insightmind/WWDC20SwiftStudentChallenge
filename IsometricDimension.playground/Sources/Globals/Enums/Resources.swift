// Copyright © 2020 Niklas Buelow. All rights reserved.

import Foundation

/*
 * This file contains the static strings to the resources located in the Playground.
 * In normal projects this can be automated using SwiftGen and .xcassets folders.
 * However as Playgrounds does not support these and because of time constraints
 * I hardcoded the resource file names here. This allows than safer access in the
 * codebase.
 */

// MARK: - Images
enum Images {
    enum LevelSelection {
        enum Standard {
            static let logo: String = "Images/LevelSelection/Standard/Logo"
        }

        enum LevelAssets {
            static let button: String = "Button"
            static let cube: String = "Cube"
            static let ray: String = "Ray"
            static let title: String = "Title"

            static func getFileName(for level: Int, name: String) -> String {
                return "Images/LevelSelection/Level_\(level)/Level_\(level)_\(name)"
            }
        }
    }

    enum Actors {
        static let leftBack: String = "Left-Back"
        static let leftFront: String = "Left-Front"
        static let rightBack: String = "Right-Back"
        static let rightFront: String = "Right-Front"

        enum T33 {
            static let leftFrontLight: String = "Images/Actor/T33/T33-Left-Front-Light"
        }

        enum D42 {
            static let leftBackLight: String = "Images/Actor/D42/D42-Left-Back-Light"
        }

        static func getFileName(for actor: String, name: String) -> String {
            return "Images/Actor/\(actor)/\(actor)-\(name)"
        }
    }

    enum Block {
        static let standardBlock: String = "Images/Blocks/Standard/Block"
        static let start: String = "Images/Blocks/Standard/Start_Block"
        static let finish: String = "Images/Blocks/Standard/Finish_Block"
        static let block: String = "Block"
        static let tesla: String = "Tesla"

        static func getFileName(for style: BlockStyle, name: String) -> String {
            return "Images/Blocks/\(style.rawValue)/\(style.rawValue)_\(name)"
        }
    }

    enum Controls {
        enum LevelCompletion {
            static let title: String = "Images/Controls/LevelCompletion/LevelCompleted"
            static let starOn: String = "Images/Controls/LevelCompletion/StarOn"
            static let starOff: String = "Images/Controls/LevelCompletion/StarOff"
            static let menuButton: String = "Images/Controls/LevelCompletion/MenuButton"
        }

        enum Keypad {
            static let arrow: String = "Images/Controls/Keypad/KeypadArrow"
        }

        enum InGame {
            enum Clock {
                static let clock: String = "Clock"

                static func getClockFileName(for index: Int) -> String {
                    return "Images/Controls/InGame/Clock/\(clock)_\(index)"
                }
            }

            static let pauseButton: String = "Images/Controls/InGame/Pause_InGame_Button"
            static let musicOff: String = "Images/Controls/InGame/MusicOff"
            static let musicOn: String = "Images/Controls/InGame/MusicOn"
            static let pauseTitle: String = "Images/Controls/InGame/PausedTitle"
        }

        enum PlayerSelection {
            static let droidD42: String = "Images/Controls/PlayerSelection/PlayerD42"
            static let droidT33: String = "Images/Controls/PlayerSelection/PlayerT33"
        }

        enum Cube {
            static let cube: String = "Images/Controls/Cube/Cube_Standard"

            enum Buttons {
                static let close: String = "Images/Controls/Cube/Buttons/Close_CubeButton"
                static let pause: String = "Images/Controls/Cube/Buttons/Pause_CubeButton"
                static let nextLeft: String = "Images/Controls/Cube/Buttons/NextLeft_CubeButton"
                static let nextRight: String = "Images/Controls/Cube/Buttons/NextRight_CubeButton"
            }

            static func getRayFileName(for direction: IsometricAxis) -> String {
                return "Images/Controls/Cube/\(direction.rawValue)_Ray"
            }
        }
    }
}

// MARK: - Audio
enum Audio {
    static let backgroundMusic: String = "Audio/BackgroundMusic"
}

// MARK: - Level
enum Level {
    static let config: String = "Config"
    static let map: String = "Map"

    static func getFilename(for levelNum: Int, filename: String) -> String {
        return "Levels/Level_\(levelNum)/Level_\(levelNum)_\(filename)"
    }
}
