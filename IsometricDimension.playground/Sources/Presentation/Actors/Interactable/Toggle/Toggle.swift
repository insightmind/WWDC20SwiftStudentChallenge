// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

class Toggle: SKSpriteNode {
    struct ViewModel {
        var enabled: String
        var disabled: String

        static let star: Self = .init(enabled: Images.Controls.LevelCompletion.starOn, disabled: Images.Controls.LevelCompletion.starOff)
        static let music: Self = .init(enabled: Images.Controls.InGame.musicOn, disabled: Images.Controls.InGame.musicOff)
        static let droid: Self = .init(enabled: Images.Controls.PlayerSelection.droidD42, disabled: Images.Controls.PlayerSelection.droidT33)
    }

    private let model: ViewModel
    private(set) var isEnabled: Bool = true

    // MARK: - Initialization
    init(model: ViewModel) {
        self.model = model
        let texture = SKTexture(imageNamed: model.enabled)
        super.init(texture: texture, color: .clear, size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func setEnabled(_ value: Bool, animated: Bool) {
        guard isEnabled != value else { return }
        isEnabled = value
        setTexture(isEnabled ? model.enabled : model.disabled, animated: animated)
    }

    // MARK: - Private Methods
    private func setTexture(_ imageName: String, animated: Bool) {
        let texture = SKTexture(imageNamed: imageName)
        let action: SKAction = .setTexture(texture, resize: true)

        if animated {
            run(.sequence([.fadeOut(withDuration: 0.1), action, .fadeIn(withDuration: 0.1)]))
        } else {
            run(action)
        }
    }
}
