// Copyright © 2020 Niklas Buelow. All rights reserved.

import UIKit
import SpriteKit

class Keypad: SKSpriteNode {
    // MARK: Constants
    enum Constants {
        static let buttonSpacing: CGFloat = 8
    }

    // MARK: NodeSelectors
    /// NodeSelectors are used to describe a specific node in the scene in
    /// a more declarative way.
    enum NodeSelectors: String, NodeSelector {
        case topLeftButton
        case topRightButton
        case bottomLeftButton
        case bottomRightButton

        var isUserInteractable: Bool { true }
        var moveDirection: MoveDirection {
            switch self {
            case .topLeftButton:
                return .upLeft

            case .topRightButton:
                return .upRight

            case .bottomLeftButton:
                return .downLeft

            case .bottomRightButton:
                return .downRight
            }
        }
    }

    // MARK: - Properties
    weak var delegate: ActorControlDelegate?
    private lazy var buttons: [SKSpriteNode] = [topRightButton, bottomRightButton, bottomLeftButton, topLeftButton]
    private var currentDirection: MoveDirection? {
        didSet {
            guard let value = currentDirection, value != oldValue else { return }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }

    // MARK: - Childnodes
    private var topRightButton: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: Images.Controls.Keypad.arrow)
        node.name = NodeSelectors.topRightButton.rawValue
        node.zRotation = .pi * 3 / 2

        let offset = (node.size.width + Constants.buttonSpacing) / 2
        node.position = CGPoint(x: offset, y: offset)
        node.zPosition = 2
        return node
    }()

    private var bottomRightButton: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: Images.Controls.Keypad.arrow)
        node.name = NodeSelectors.bottomRightButton.rawValue
        node.zRotation = .pi

        let offset = (node.size.width + Constants.buttonSpacing) / 2
        node.position = CGPoint(x: offset, y: -offset)
        node.zPosition = 2
        return node
    }()

    private var bottomLeftButton: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: Images.Controls.Keypad.arrow)
        node.name = NodeSelectors.bottomLeftButton.rawValue
        node.zRotation = .pi * 1 / 2

        let offset = (node.size.width + Constants.buttonSpacing) / 2
        node.position = CGPoint(x: -offset, y: -offset)
        node.zPosition = 2
        return node
    }()

    private var topLeftButton: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: Images.Controls.Keypad.arrow)
        node.name = NodeSelectors.topLeftButton.rawValue

        let offset = (node.size.width + Constants.buttonSpacing) / 2
        node.position = CGPoint(x: -offset, y: offset)
        node.zPosition = 2
        return node
    }()

    // MARK: - Initialization
    init() {
        super.init(texture: nil, color: .clear, size: .zero)

        isUserInteractionEnabled = true

        addChild(topRightButton)
        addChild(bottomRightButton)
        addChild(bottomLeftButton)
        addChild(topLeftButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UserInteraction
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let node = findTouchedNode(for: touches, with: NodeSelectors.selectableNodes) else { return }
        guard let name = node.name, let direction = NodeSelectors(rawValue: name)?.moveDirection else { return }
        selectButton(node: node)
        delegate?.startsMoving(direction: direction)
        currentDirection = direction

    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let node = findTouchedNode(for: touches, with: NodeSelectors.selectableNodes) else { return }
        guard let name = node.name, let direction = NodeSelectors(rawValue: name)?.moveDirection else { return }
        selectButton(node: node)
        delegate?.startsMoving(direction: direction)
        currentDirection = direction
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.stopsMoving()
        deselectAllButtonNodes()
        currentDirection = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        delegate?.stopsMoving()
        deselectAllButtonNodes()
        currentDirection = nil
    }

    // MARK: - Button Selection
    func selectButton(node: SKNode) {
        guard let spriteNode = node as? SKSpriteNode, buttons.contains(spriteNode) else { return }
        buttons.forEach { $0.run(.scale(to: $0 == spriteNode ? 0.8 : 1.0, duration: 0.1)) }
    }

    func deselectAllButtonNodes() {
        buttons.forEach { $0.run(.scale(to: 1.0, duration: 0.1)) }
    }
}
