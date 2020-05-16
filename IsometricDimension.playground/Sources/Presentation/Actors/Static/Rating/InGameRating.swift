// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

class InGameRating: SKNode {
    // MARK: Nodes
    private lazy var clock: Clock = Clock()
    private lazy var stars: [Toggle] = [Toggle(model: .star), Toggle(model: .star), Toggle(model: .star)]

    override init() {
        super.init()

        addChild(clock)
        clock.position = CGPoint(x: 0, y: 10)
        clock.anchorPoint = CGPoint(x: 0.5, y: 0.0)

        stars.enumerated().forEach { [weak self] index, star in
            self?.addChild(star)

            let width = star.size.width / 2 + 5
            star.position = CGPoint(x: -width + width * CGFloat(index), y: -10)
            star.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            star.setScale(0.5)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    func startClock() {
        clock.isEnabled = true
    }

    func stopClock() {
        clock.isEnabled = false
    }

    func setRating(_ rating: Rating) {
        stars.enumerated().forEach { index, star in
            star.setEnabled(index < rating.rawValue, animated: true)
        }
    }
}
