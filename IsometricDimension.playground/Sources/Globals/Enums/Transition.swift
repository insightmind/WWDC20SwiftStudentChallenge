// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

/**
 * This Enum allows a simplified and preconfigured access to SKTransitions for scenes.
 */
public enum Transition {
    case appear
    case crossDisolve
    case moveIn(direction: SKTransitionDirection)
    case push(direction: SKTransitionDirection)
    case reveal(direction: SKTransitionDirection)

    var skTransition: SKTransition {
        switch self {
        case .appear:
            return SKTransition.crossFade(withDuration: 0.0)

        case .crossDisolve:
            return SKTransition.crossFade(withDuration: 0.5)

        case let .push(direction):
            return SKTransition.push(with: direction, duration: 0.5)

        case let .moveIn(direction):
            return SKTransition.moveIn(with: direction, duration: 0.5)

        case let .reveal(direction):
            return SKTransition.reveal(with: direction, duration: 0.5)
        }
    }
}
