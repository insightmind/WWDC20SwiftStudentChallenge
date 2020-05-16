// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

class CubeButton: SKSpriteNode {
    // MARK: - Subtypes
    private enum Constant {
        static let leftRightButtonInset: CGFloat = 30

        static let pulseAnimationFactor: CGFloat = 20
        static let pulseAnimationDuration: TimeInterval = 2.0
        static let pulseAnimationKey: String = "pulseAnimation"
    }

    struct ViewModel {
        var cubeFileName: String
        var buttonFileName: String
        var rayFileName: String

        var levelNum: Int?
        var titleFileName: String?

        init(levelNum: Int) {
            self.levelNum = levelNum
            self.cubeFileName = Images.LevelSelection.LevelAssets.getFileName(for: levelNum, name: Images.LevelSelection.LevelAssets.cube)
            self.titleFileName = Images.LevelSelection.LevelAssets.getFileName(for: levelNum, name: Images.LevelSelection.LevelAssets.title)
            self.buttonFileName = Images.LevelSelection.LevelAssets.getFileName(for: levelNum, name: Images.LevelSelection.LevelAssets.button)
            self.rayFileName = Images.LevelSelection.LevelAssets.getFileName(for: levelNum, name: Images.LevelSelection.LevelAssets.ray)
        }

        init(buttonImage: String, axis: IsometricAxis) {
            self.levelNum = -1
            self.cubeFileName = Images.Controls.Cube.cube
            self.titleFileName = ""

            self.buttonFileName = buttonImage
            self.rayFileName = Images.Controls.Cube.getRayFileName(for: axis)
        }
    }

    // MARK: - Properties
    private(set) var model: ViewModel
    private(set) var axis: IsometricAxis

    // MARK: - Childnodes
    private lazy var buttonNode: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: model.buttonFileName)
        node.position = calculatePositionOffset(for: axis, size: node.size)
        return node
    }()

    private lazy var rayNode: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: model.rayFileName)
        
        // We now set the position offset. This is basically similiar to the buttonNode position
        // however because of the size and export inequalities it differs a bit.
        // Thats why we add a manual offset.
        node.position = calculatePositionOffset(for: axis, size: node.size, offset: CGPoint(x: 10, y: 10))
        node.alpha = 0.0
        return node
    }()

    // MARK: - Initialization
    init(model: ViewModel, axis: IsometricAxis) {
        self.model = model
        self.axis = axis

        super.init(texture: nil, color: .clear, size: .zero)

        addChild(buttonNode)
        addChild(rayNode)

        animatePulse(nodes: [buttonNode, rayNode], axis: axis)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    private func calculatePositionOffset(for axis: IsometricAxis, size: CGSize, offset: CGPoint = .zero) -> CGPoint {
        switch axis {
        case .vertical:
            return CGPoint(x: 0, y: size.height / 2)

        case .left, .right:
            let hyptonuse = hypot(size.width / 2, size.height / 2) - Constant.leftRightButtonInset
            return CGPoint(x: axis.vector.dx * (hyptonuse + offset.x), y: axis.vector.dy * (hyptonuse + offset.y) - Constant.leftRightButtonInset)
        }
    }

    // MARK: - Animation
    private func animatePulse(nodes: [SKNode], axis: IsometricAxis) {
        let factor: CGFloat = Constant.pulseAnimationFactor

        let xDelta = axis.vector.dx * factor
        let yDelta = axis.vector.dy * factor

        let moveUpAction: SKAction = .moveBy(x: xDelta, y: yDelta, duration: Constant.pulseAnimationDuration)
        let moveDownAction: SKAction = .moveBy(x: -xDelta, y: -yDelta, duration: Constant.pulseAnimationDuration)

        moveUpAction.timingMode = .easeInEaseOut
        moveDownAction.timingMode = .easeInEaseOut

        let pulseAction: SKAction = .repeatForever(.sequence([moveUpAction, moveDownAction]))

        nodes.forEach { $0.run(pulseAction, withKey: Constant.pulseAnimationKey) }
    }

    // MARK: - Selection
    func animateSelection(isSelected: Bool) {
        if isSelected {
            let fadeInAction: SKAction = .fadeIn(withDuration: 0.2)
            buttonNode.run(fadeInAction)
            rayNode.run(fadeInAction)
        } else {
            let fadeOutAction: SKAction = .fadeOut(withDuration: 0.2)
            buttonNode.run(fadeOutAction)
            rayNode.run(fadeOutAction)
        }
    }

    func reset() {
        buttonNode.alpha = 1.0
        rayNode.alpha = 0.0
    }
}
