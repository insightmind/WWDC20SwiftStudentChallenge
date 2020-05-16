// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

struct Block {
    let texture: SKTexture
    let type: BlockType

    func generateNode(for width: CGFloat) -> SKSpriteNode {
        let node = SKSpriteNode(texture: texture)
        let textureSize = texture.size()
        let newHeight = width / textureSize.width * textureSize.height

        node.size = CGSize(width: width, height: newHeight)

        return node
    }
}
