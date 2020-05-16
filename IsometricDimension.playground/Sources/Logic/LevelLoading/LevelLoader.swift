// Copyright © 2020 Niklas Buelow. All rights reserved.

import CoreGraphics
import Foundation

/// An EncodedLevelTileMap is a non processed tile map of a level, containing the simple identifiers for the block types at a location.
typealias EncodedLevelTileMap = [[String]]

/// A DecodedLevelTileMap is a processed tile map of a level, which already contains the resolved blocks for each coordinate.
typealias DecodedLevelTileMap = [[Block?]]

/// The LevelLoader is responsible for loading and preprocessing any level associated files and data structures.
class LevelLoader {
    // MARK: - Config Loading

    /// Loads a config for the given level number if available.
    /// This config must be supplied with the correct file name to be found by the loader.
    static func loadConfig(levelNum: Int) -> LevelConfig? {
        let filename = Level.getFilename(for: levelNum, filename: Level.config)
        let decoder = JSONDecoder()

        guard let filepath = Bundle.main.url(forResource: filename, withExtension: FileTypes.isoconfig.rawValue) else { return nil }
        guard let data = try? Data(contentsOf: filepath) else { return nil }
        guard let config = try? decoder.decode(LevelConfig.self, from: data) else { return nil }

        return config
    }

    // MARK: - RawMapLoading

    /// Loads a unprocessed tile map referenced by the config if available
    static func loadRawTileMap(config: LevelConfig) -> EncodedLevelTileMap? {
        guard let filepath = Bundle.main.path(forResource: config.rawMapFile, ofType: FileTypes.isomap.rawValue) else { return nil }
        guard let contentString = try? String(contentsOfFile: filepath) else { return nil }

        let linesOfString = contentString.components(separatedBy: "\n")
        return linesOfString.map { $0.map(String.init) }
    }

    // MARK: - MapProcessing

    /// Loads and preprocesses an EncodedLevelTileMap.
    ///
    /// This process resolves the block type for each coordinate in the map,
    /// Finds the start and finish points in the map. And resolves any teleportation points.
    ///
    /// Fails if:
    ///     - Multiple or zero startpoints or finishpoints are provided
    ///     - More than two teleportation blocks are found for the same identifier
    ///     - An unknown block identifier is found
    ///
    /// - Parameter rawMap: The unprocessed tile map of the level
    /// - Throws: Throws a LevelLoadingError if any of the necessary structures and preconditions are not met.
    /// - Returns: A processed tile map of the level.
    static func loadLevel(from rawMap: EncodedLevelTileMap) throws -> LoadedLevel {
        var tileMap = DecodedLevelTileMap()
        var startLocations: [CGPoint] = []
        var finishLocations: [CGPoint] = []
        var teleportationPoints: [BlockStyle: [CGPoint]] = [:]

        // We collect the size of the map to allow easier usage in the game itself
        var maxXCount: Int = 0
        var maxYCount: Int = 0

        // Preprocess rawTileMap
        for xIndex in 0 ..< rawMap.count {
            let blockCount = rawMap[xIndex].count
            maxYCount = max(maxYCount, blockCount)

            guard rawMap[xIndex].count != 0 else { break }
            tileMap.append(.init(repeating: nil, count: blockCount))
            maxXCount = xIndex

            for yIndex in 0 ..< blockCount {
                // We need to make sure there are no unknown blocks in the map.
                guard let blockType = BlockType.getBlockType(for: rawMap[xIndex][yIndex]) else {
                    throw LevelLoadingError.unknownBlock
                }

                let point = CGPoint(x: xIndex, y: yIndex)

                switch blockType {
                case .start:
                    startLocations.append(point)

                case .finish:
                    finishLocations.append(point)

                case let .styled(style):
                    var points = teleportationPoints[style] ?? []
                    points.append(point)
                    teleportationPoints[style] = points

                default:
                    break
                }

                tileMap[xIndex][yIndex] = blockType.generateBlock()
            }
        }

        // There must be exactly one entry point
        guard startLocations.count == 1, let startLocation = startLocations.first else {
            throw LevelLoadingError.invalidEntryPoints(numOfPoints: startLocations.count)
        }

        // There must be exactly one exit point
        guard finishLocations.count == 1, let finishLocation = finishLocations.first else {
            throw LevelLoadingError.invalidFinishPoints(numOfPoints: finishLocations.count)
        }

        // We map the found teleportation points to pairs and check the validity of the teleportation structure.
        var teleportations: [BlockStyle: TeleportationPair] = [:]
        try teleportationPoints.forEach { style, points in
            guard points.count == 2 else { throw LevelLoadingError.invalidTeleportationPoints }
            teleportations[style] = TeleportationPair(firstBlockLocation: points[0], secondBlockLocation: points[1])
        }

        return LoadedLevel(
            tileMap: tileMap,
            startLocation: startLocation,
            finishLocation: finishLocation,
            mapSize: CGSize(width: maxXCount, height: maxYCount),
            teleportations: teleportations
        )
    }
}
