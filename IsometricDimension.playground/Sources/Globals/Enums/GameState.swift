// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

/**
 * This enum specifies the individual scenes in the game.
 * You can use them to automatically load a scene and supply it with the necessary paramters
 * such as their expected models
 */
enum GameState {
    case menu
    case game(config: LevelConfig)
    case completion(model: LevelCompletion)

    /// Loads the associated scene and assigns the necessary parameters
    func loadScene(size: CGSize, delegate: GameFlowDelegate) -> GameFlowable {
        switch self {
        case .menu:
            let model = InteractableCube.ViewModel(
                standardCubeFileName: Images.Controls.Cube.cube,
                topModel: .init(levelNum: 3),
                rightModel: .init(levelNum: 2),
                leftModel: .init(levelNum: 1)
            )

            return MenuScene(size: size, flowDelegate: delegate, model: model)

        case let .game(config):
            return GameScene(size: size, flowDelegate: delegate, model: config)

        case let .completion(model):
            return GameCompletionScene(size: size, flowDelegate: delegate, model: model)
        }
    }
}
