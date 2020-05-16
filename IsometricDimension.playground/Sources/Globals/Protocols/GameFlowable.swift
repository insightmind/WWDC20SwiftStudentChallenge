// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

/// This protocol ensures that the scene is submitted with a flow delegate
/// which allows the dynamic transition between two scenes.
protocol GameFlowable: SKScene {
    /// FlowDelegate to allow transition between two scenes
    var flowDelegate: GameFlowDelegate? { get set }
}
