import Foundation
import SpriteKit

class MenuScene: FlowableScene<InteractableCube.ViewModel> {
    // MARK: - NodeSelectors
    enum NodeSelectors: String, NodeSelector {
        case menuCube
        case logoImage
        case soundToggle
        case playerToggle

        var isUserInteractable: Bool {
            return [NodeSelectors.logoImage, .soundToggle, .playerToggle].contains(self)
        }
    }

    // MARK: - Nodes
    private lazy var menuCube: InteractableCube = {
        let node = InteractableCube(model: model)
        node.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)
        node.setScale(0.4)
        node.delegate = self
        node.name = NodeSelectors.menuCube.rawValue
        return node
    }()

    private lazy var logoImage: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: Images.LevelSelection.Standard.logo)
        node.position = CGPoint(x: size.width / 2, y: 3 * size.height / 4)
        node.setScale(0.4)
        node.name = NodeSelectors.logoImage.rawValue
        return node
    }()

    private lazy var soundToggle: Toggle = {
        let node = Toggle(model: .init(enabled: Images.Controls.InGame.musicOn, disabled: Images.Controls.InGame.musicOff))
        node.position = CGPoint(x: 25, y: 25)
        node.setScale(0.5)
        node.anchorPoint = .zero
        node.name = NodeSelectors.soundToggle.rawValue
        node.setEnabled(AudioManager.shared.isBackgroundMusicEnabled, animated: false)
        return node
    }()

    private lazy var playerToggle: Toggle = {
        let node = Toggle(model: .init(enabled: Images.Controls.PlayerSelection.droidD42, disabled: Images.Controls.PlayerSelection.droidT33))
        node.position = CGPoint(x: 80, y: 25)
        node.setScale(0.5)
        node.anchorPoint = .zero
        node.name = NodeSelectors.playerToggle.rawValue
        node.setEnabled(DroidType.current == .D42, animated: false)
        return node
    }()

    private lazy var lightningLeft: Lightning = Lightning(size: self.size)
    private lazy var lightningRight: Lightning = Lightning(size: self.size)

    // MARK: - Configuration
    public override func configureScene(using model: InteractableCube.ViewModel) {
        super.configureScene(using: model)

        addChild(menuCube)
        addChild(logoImage)
        addChild(soundToggle)
        addChild(playerToggle)

        menuCube.zPosition = 10
        logoImage.zPosition = 10

        // Hidden lightning
        addChild(lightningLeft)
        addChild(lightningRight)

        let minValue = 0.25
        let maxValue = 0.75
        lightningLeft.startLightning(start: CGPoint(x: minValue, y: maxValue), end: CGPoint(x: maxValue, y: minValue))
        lightningRight.startLightning(start: CGPoint(x: minValue, y: minValue), end: CGPoint(x: maxValue, y: maxValue))
    }

    // MARK: - UserInteraction
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let node = findTouchedNode(for: touches, with: NodeSelectors.selectableNodes) else { return }
        didSelect(node)
    }

    private func didSelect(_ node: SKNode) {
        switch node {
        case soundToggle:
            toggleSound()

        case playerToggle:
            toggleDroid()

        default:
            break
        }
    }

    // MARK: - Transitions
    private func transitionOut(on axis: IsometricAxis) {
        guard let axisModel = model.getModel(for: axis) else { return }

        transitionOutTitle(axisModel: axisModel)
        transitionOutMenuCube(axis: axis, axisModel: axisModel)

        lightningLeft.stopLightning()
        lightningRight.stopLightning()

        let fadeOutAction: SKAction = .fadeOut(withDuration: 0.2)
        soundToggle.run(fadeOutAction)
        playerToggle.run(fadeOutAction)
    }

    private func transitionOutMenuCube(axis: IsometricAxis, axisModel: CubeButton.ViewModel) {
        let axisVector = axis.vector
        let hypotenuse = hypot(size.width, size.height)
        let moveOutLocation = CGVector(dx: -axisVector.dx * hypotenuse, dy: -axisVector.dy * hypotenuse)
        let moveOutAction: SKAction = .move(by: moveOutLocation, duration: 1.2)
        moveOutAction.timingMode = .easeInEaseOut

        guard let levelNum = axisModel.levelNum else { return }
        guard let config = LevelLoader.loadConfig(levelNum: levelNum) else { return }

        let completionAction: SKAction = .customAction(withDuration: 0.0) { [weak self] _, _ in
            self?.flowDelegate?.changeGameState(to: .game(config: config), with: .crossDisolve)
        }

        menuCube.setCubeTexture(texture: .init(imageNamed: axisModel.cubeFileName))
        menuCube.run(.sequence([.wait(forDuration: 1.0), moveOutAction, completionAction]))
    }

    private func transitionOutTitle(axisModel: CubeButton.ViewModel) {
        guard let titleFileName = axisModel.titleFileName else { return }
        let fadeTitleTextureAction: SKAction = .setTexture(.init(imageNamed: titleFileName), resize: true)
        let fadeOutAction: SKAction = .fadeOut(withDuration: 0.6)

        logoImage.run(.sequence([fadeTitleTextureAction, .wait(forDuration: 1.0), fadeOutAction]))
    }

    // MARK: - Button Actions
    private func toggleSound() {
        let newValue = !AudioManager.shared.isBackgroundMusicEnabled
        soundToggle.setEnabled(newValue, animated: true)
        AudioManager.shared.isBackgroundMusicEnabled = newValue
    }

    private func toggleDroid() {
        let newValue: DroidType = DroidType.current == .D42 ? .T33 : .D42
        playerToggle.setEnabled(newValue == .D42, animated: true)
        DroidType.current = newValue
    }
}

// MARK: - MenuCubeDelegate
extension MenuScene: MenuCubeDelegate {
    func didSelectAction(for axis: IsometricAxis) {
        transitionOut(on: axis)
    }
}
