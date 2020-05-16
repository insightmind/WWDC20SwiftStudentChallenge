// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

class CompletionRating: SKNode {
    // MARK: - Nodes
    private lazy var stars: [Toggle] = [Toggle(model: .star), Toggle(model: .star), Toggle(model: .star)]

    init(model: Rating) {
        super.init()

        stars.enumerated().forEach { [weak self] index, star in
            self?.addChild(star)

            let width = star.size.width / 2
            star.position = CGPoint(x: -width + width * CGFloat(index), y: 0)
            star.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            star.setScale(index.isMultiple(of: 2) ? 0.4 : 0.5)
            star.setEnabled(index < model.rawValue, animated: false)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
