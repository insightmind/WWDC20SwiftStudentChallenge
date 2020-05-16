// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

/// The GameFlowDelegate allows dynamic transition between two scenes by a coordinator.
protocol GameFlowDelegate: AnyObject {

    /// Transitions to the given scene using the given transition.
    func transitionScene(to scene: SKScene, with transition: SKTransition)

    /// Changes the current game state to the new supplied game state by using the given transition for scene transitioning.
    func changeGameState(to state: GameState, with transition: Transition)
}
