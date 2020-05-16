// Copyright © 2020 Niklas Buelow. All rights reserved.

import Foundation
import AVFoundation
import SpriteKit

/// The main class for the game which has to referenced to play the game.
public class IsometricDimensionGame {
    // MARK: - Properties
    private let viewSize: CGSize = CGSize(width: 700, height: 700)
    private var gameState: GameState = .menu

    /// Use this view to present the game.
    public lazy var view: SKView = {
        let frame = CGRect(origin: .zero, size: self.viewSize)
        let view = SKView(frame: frame)

        // We load the menu immediately
        let scene = gameState.loadScene(size: viewSize, delegate: self)
        view.presentScene(scene)

        return view
    }()

    private var scene: SKScene?

    // MARK: - Initialization
    /// Starts the game. You can then use the view to show it on screen.
    /// - Parameter isDebug: If true the SpriteKit debug menu is shown
    public init(isDebug: Bool = false) {
        view.showsFPS = isDebug
        view.showsFields = isDebug
        view.showsDrawCount = isDebug
        view.showsNodeCount = isDebug
        view.showsQuadCount = isDebug

        AudioManager.shared.isBackgroundMusicEnabled = true
    }

    /// Reloads the current scene dismissing any state it had using the given transition.
    public func reload(with transition: SKTransition) {
        let scene = gameState.loadScene(size: viewSize, delegate: self)
        transitionScene(to: scene, with: transition)
    }
}

// MARK: - GameFlowDelegate
extension IsometricDimensionGame: GameFlowDelegate {
    func transitionScene(to scene: SKScene, with transition: SKTransition = .crossFade(withDuration: 0.5)) {
        view.presentScene(scene, transition: transition)
        self.scene = scene
    }

    func changeGameState(to state: GameState, with transition: Transition = .crossDisolve) {
        gameState = state
        reload(with: transition.skTransition)
    }
}
