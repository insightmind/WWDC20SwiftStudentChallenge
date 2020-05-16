// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

class GameUserInterface: SKSpriteNode {
    // MARK: - NodeSelectors
    enum NodeSelectors: String, NodeSelector {
        case pauseButton
        case soundToggle

        var isUserInteractable: Bool {
            return [NodeSelectors.pauseButton, .soundToggle].contains(self)
        }
    }

    // MARK: - Properties
    private weak var delegate: UserInterfaceDelegate?

    // MARK: - Nodes
    private lazy var rating: InGameRating = {
        let node = InGameRating()
        node.setScale(0.5)
        node.position = CGPoint(x: position.x - size.width / 2 + 150, y: position.y + size.height / 2 - 70)
        return node
    }()
    
    private lazy var keypad: Keypad = {
        let node = Keypad()
        node.setScale(0.7)
        node.position = CGPoint(x: position.x + size.width / 2 - 75, y: position.y - size.height / 2 + 100)
        node.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        return node
    }()

    private lazy var soundToggle: Toggle = {
        let node = Toggle(model: .init(enabled: Images.Controls.InGame.musicOn, disabled: Images.Controls.InGame.musicOff))
        node.position = CGPoint(x: position.x - size.width / 2 + 25, y: position.y + size.height / 2 - 75)
        node.setScale(0.5)
        node.anchorPoint = CGPoint(x: 0, y: 1.0)
        node.name = NodeSelectors.soundToggle.rawValue
        return node
    }()

    private lazy var pauseButton: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: Images.Controls.InGame.pauseButton)
        node.position = CGPoint(x: position.x - size.width / 2 + 25, y: position.y + size.height / 2 - 25)
        node.setScale(0.5)
        node.anchorPoint = CGPoint(x: 0, y: 1.0)
        node.name = NodeSelectors.pauseButton.rawValue
        return node
    }()

    // MARK: - Initialization
    init(size: CGSize, delegate: UserInterfaceDelegate, actorDelegate: ActorControlDelegate) {
        self.delegate = delegate

        super.init(texture: nil, color: .clear, size: size)

        isUserInteractionEnabled = true

        addChild(keypad)
        addChild(soundToggle)
        addChild(pauseButton)
        addChild(rating)

        keypad.delegate = actorDelegate
        soundToggle.setEnabled(AudioManager.shared.isBackgroundMusicEnabled, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Touch Interactions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let node = findTouchedNode(for: touches, with: NodeSelectors.selectableNodes) else { return }
        didSelect(node)
    }

    func didSelect(_ node: SKNode) {
        switch node {
        case soundToggle:
            toggleSound()

        case pauseButton:
            delegate?.didPressPauseButton()

        default:
            break
        }
    }

    func setClock(enabled: Bool) {
        enabled ? rating.startClock() : rating.stopClock()
    }

    // MARK: - Button Actions
    private func toggleSound() {
        let newValue = !AudioManager.shared.isBackgroundMusicEnabled
        soundToggle.setEnabled(newValue, animated: true)
        AudioManager.shared.isBackgroundMusicEnabled = newValue
    }
}

extension GameUserInterface: LevelManagerDelegate {
    func ratingDidChange(newRating: Rating) {
        rating.setRating(newRating)
    }
}
