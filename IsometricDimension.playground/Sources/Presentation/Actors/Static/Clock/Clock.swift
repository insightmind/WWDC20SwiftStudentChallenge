// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

class Clock: SKSpriteNode {
    // MARK: - Constants
    enum Constants {
        static let numOfTexture: Int = 8
    }

    // MARK: - Properties
    var isEnabled: Bool = true {
        didSet {
            guard oldValue != isEnabled else { return }
            isEnabled ? startClock() : stopClock()
        }
    }

    private var currentTextureIndex: Int = 0
    private var timer: Timer?

    // MARK: - Initialization
    init() {
        let initialTexture = SKTexture(imageNamed: Images.Controls.InGame.Clock.getClockFileName(for: currentTextureIndex))
        super.init(texture: initialTexture, color: .clear, size: initialTexture.size())
        startClock()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Animation
    private func startClock() {
        guard timer == nil else { return }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.currentTextureIndex += 1
            if self.currentTextureIndex >= Constants.numOfTexture { self.currentTextureIndex = 0 }

            let textureAction: SKAction = .setTexture(SKTexture(imageNamed: Images.Controls.InGame.Clock.getClockFileName(for: self.currentTextureIndex)))
            self.run(textureAction)
        }
    }

    private func stopClock() {
        timer?.invalidate()
        timer = nil
    }
}
