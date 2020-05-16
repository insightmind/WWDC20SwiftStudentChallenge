// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

class PauseMenu: SKSpriteNode {
    // MARK: - Properties
    private var isEnabled: Bool { !isHidden && !isPaused }

    // MARK: - Nodes
    private weak var delegate: PauseMenuDelegate?
    private lazy var cube: InteractableCube = {
        let node = InteractableCube(
            model: .init(
                standardCubeFileName: Images.Controls.Cube.cube,
                rightModel: .init(buttonImage: Images.Controls.Cube.Buttons.nextRight, axis: .right),
                leftModel: .init(buttonImage: Images.Controls.Cube.Buttons.close, axis: .left)
            )
        )

        node.delegate = self
        node.setScale(0.4)
        return node
    }()

    private lazy var logoImage: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: Images.Controls.InGame.pauseTitle)
        node.position = CGPoint(x: 0, y: size.height / 4)
        node.setScale(0.4)
        return node
    }()

    // MARK: - Initialization
    init(size: CGSize, delegate: PauseMenuDelegate) {
        self.delegate = delegate

        super.init(texture: nil, color: UIColor.black.withAlphaComponent(0.5), size: size)

        isUserInteractionEnabled = true
        addChild(cube)
        addChild(logoImage)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Transitions
    func transitionIn() {
        guard !isEnabled else { return }

        let fadeIn: SKAction = .fadeIn(withDuration: 0.2)

        alpha = 0.0
        isHidden = false
        isPaused = false
        cube.position = CGPoint(x: 0, y: -size.height)

        let moveIn: SKAction = .move(to: CGPoint(x: 0, y: -50), duration: 0.6)
        moveIn.timingMode = .easeInEaseOut

        cube.run(moveIn)
        run(.sequence([.wait(forDuration: 0.4), fadeIn]))
    }

    func transitionOut() {
        guard isEnabled else { return }

        let fadeOut: SKAction = .fadeOut(withDuration: 0.2)
        let runAction: SKAction = .run { [weak self] in
            self?.isHidden = true
            self?.isPaused = true
            self?.cube.reset()
        }

        let moveOut: SKAction = .moveBy(x: 0, y: -size.height, duration: 0.6)
        moveOut.timingMode = .easeInEaseOut

        cube.run(moveOut)
        run(.sequence([fadeOut, runAction]))
    }
}

extension PauseMenu: MenuCubeDelegate {
    func didSelectAction(for axis: IsometricAxis) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let self = self else { return }
            switch axis {
            case .left:
                self.delegate?.didTapCloseButton()

            case .right:
                self.delegate?.didTapResumeButton()

            default:
                break
            }
        }
    }
}
