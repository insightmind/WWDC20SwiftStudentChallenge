// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

/*
 * A FlowableScene encapsulates properties to allow dynamic transitioning and
 * organization of SpriteKitScenes. More specfically it allows a SKScene to
 * be dynamically configured by the Game Coordinator.
 */
class FlowableScene<ViewModel: Any>: SKScene, GameFlowable {
    let model: ViewModel
    weak var flowDelegate: GameFlowDelegate?

    /// Creates a new FlowableScene with the required parameters.
    /// - Parameters:
    ///   - size: The size of the scene
    ///   - flowDelegate: The delegate to allow dynamic transition between scenes
    ///   - model: The view model of this scene
    required init(size: CGSize, flowDelegate: GameFlowDelegate, model: ViewModel) {
        self.model = model

        super.init(size: size)
        self.flowDelegate = flowDelegate
        configureScene(using: model)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard Scene Loading is unsupported")
    }

    /**
     * Implement this method in a subclass to configure the scene, such as adding child nodes etc.
     */
    func configureScene(using model: ViewModel) {
        isUserInteractionEnabled = true
        backgroundColor = .backgroundBlue

        // Implement this in subclass
    }
}
