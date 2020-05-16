// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

class GameCompletionScene: FlowableScene<LevelCompletion> {
    // MARK: - NodeSelectors
    enum NodeSelectors: String, NodeSelector {
        case menuButton
        case title
        case rating

        var isUserInteractable: Bool {
            return [NodeSelectors.menuButton].contains(self)
        }
    }

    // MARK: - Nodes
    private lazy var title: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: Images.Controls.LevelCompletion.title)
        node.position = CGPoint(x: size.width / 2, y: 3 * size.height / 4)
        node.setScale(0.4)
        node.name = NodeSelectors.title.rawValue
        return node
    }()

    private lazy var menuButton: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: Images.Controls.LevelCompletion.menuButton)
        node.position = CGPoint(x: size.width / 2, y: size.height / 4)
        node.setScale(0.4)
        node.name = NodeSelectors.menuButton.rawValue
        return node
    }()

    private lazy var rating: CompletionRating = {
        let node = CompletionRating(model: model.rating)
        node.position = CGPoint(x: size.width / 2, y: size.height / 2)
        node.name = NodeSelectors.rating.rawValue
        return node
    }()

    // MARK: - Configuration
    override func configureScene(using model: LevelCompletion) {
        super.configureScene(using: model)

        addChild(rating)
        addChild(menuButton)
        addChild(title)
    }

    // MARK: - UserInteraction
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let node = findTouchedNode(for: touches, with: NodeSelectors.selectableNodes) else { return }
        didSelect(node)
    }

    private func didSelect(_ node: SKNode) {
        guard node === menuButton else { return }
        flowDelegate?.changeGameState(to: .menu, with: .crossDisolve)
    }
}
