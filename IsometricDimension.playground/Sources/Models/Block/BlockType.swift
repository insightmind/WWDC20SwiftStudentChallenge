// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

/// The BlockType enum defines the available block types in the game and specifies their
/// corresponding identifiers and block instances.
enum BlockType: Equatable {
    case air
    case standard
    case start
    case finish
    case tesla(style: BlockStyle)
    case styled(style: BlockStyle)

    /// Resolves the block type for a given identifier.
    ///
    /// If the identifier unknonw this method returns nil.
    static func getBlockType(for identifier: String) -> BlockType? {
        switch identifier {
        case "S":
            return .start

        case "F":
            return .finish

        case "r":
            return .tesla(style: .red)

        case "g":
            return .tesla(style: .green)

        case "y":
            return .tesla(style: .yellow)

        case "b":
            return .tesla(style: .blue)

        case "R":
            return .styled(style: .red)

        case "G":
            return .styled(style: .green)

        case "Y":
            return .styled(style: .yellow)

        case "B":
            return .styled(style: .blue)

        case "_":
            return .air

        default:
            return .standard
        }
    }

    /// Generates a block instance from the curren block style.
    /// This method returns nil if the specified blockType does not actually show a physical block, e.g. .air.
    func generateBlock() -> Block? {
        switch self {
        case .standard:
            return Block(texture: SKTexture(imageNamed: Images.Block.standardBlock), type: self)

        case .start:
            return Block(texture: SKTexture(imageNamed: Images.Block.start), type: self)

        case .finish:
            return Block(texture: SKTexture(imageNamed: Images.Block.finish), type: self)

        case let .tesla(style):
            return Block(texture: SKTexture(imageNamed: Images.Block.getFileName(for: style, name: Images.Block.tesla)), type: self)

        case let .styled(style):
            return Block(texture: SKTexture(imageNamed: Images.Block.getFileName(for: style, name: Images.Block.block)), type: self)

        case .air:
            return nil
        }
    }
}
