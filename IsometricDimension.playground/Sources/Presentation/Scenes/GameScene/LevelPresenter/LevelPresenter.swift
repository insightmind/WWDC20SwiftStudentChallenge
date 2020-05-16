// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

class LevelPresenter {
    // MARK: Constants
    enum Constants {
        static let standardBlockSize: CGSize = CGSize(width: 80, height: 80)
        static let droidOffset: CGPoint = CGPoint(x: -1, y: 2.25)
    }

    // MARK: - Properties
    var isLevelLoaded: Bool { loadedLevel != nil }

    private var blockSize: CGSize { Constants.standardBlockSize }
    private var isoBlockSize: CGSize = .zero

    private var loadedLevel: LoadedLevel?

    // MARK: - Nodes
    private var levelView: SKNode = SKNode()
    private weak var droidNode: Droid?

    // MARK: - Initialization
    init() {
        isoBlockSize = calculateIsoBlocksize(for: blockSize)
    }

    // MARK: - Level Loading
    func loadLevel(for config: LevelConfig, droid: Droid) -> SKNode {
        levelView = SKSpriteNode()

        // Preprocess Level
        guard let levelMap = LevelLoader.loadRawTileMap(config: config) else { return levelView }
        guard let loadedLevel = try? LevelLoader.loadLevel(from: levelMap) else { return levelView }

        // Load level from preprocessed level
        self.loadedLevel = loadedLevel
        self.droidNode = droid
        droid.moveDirection = config.initialDirection

        render()

        return levelView
    }

    func updateLevel(frame: CGRect) {
        disableInvisbleNodes(frame: frame)
        depthSortNodes()
    }

    // MARK: - Helper Methods
    func getBlockAtDroid() -> Block? {
        guard let droidLocation = getDroidLocation() else { return nil }
        return loadedLevel?.block(at: droidLocation)
    }

    func getDroidLocation() -> CGPoint? {
        guard let droid = droidNode else { return nil }

        let transformedLocation = mapLocation(of: droid.position)
        return CGPoint(
            x: transformedLocation.x - round(Constants.droidOffset.x),
            y: transformedLocation.y - round(Constants.droidOffset.y)
        )
    }

    // MARK: - Rendering
    private func render() {
        guard let loadedLevel = loadedLevel, let droid = droidNode else { return }
        renderLevelMap()

        // Set droid to start location
        let startLocation = loadedLevel.startLocation
        let location = renderLocation(of: CGPoint(x: startLocation.x + Constants.droidOffset.x, y: startLocation.y + Constants.droidOffset.y))
        droid.position = location
        levelView.addChild(droid)
    }

    private func renderLevelMap() {
        guard let loadedLevel = loadedLevel else { return }

        for xIndex in 0 ..< loadedLevel.tileMap.count {
            let row = loadedLevel.tileMap[xIndex];
            for yIndex in 0 ..< row.count {
                guard let block = row[yIndex] else { continue }
                let location = renderLocation(of: CGPoint(x: xIndex, y: yIndex))
                renderBlock(block, at: location)
            }
        }
    }

    private func renderBlock(_ block: Block, at location: CGPoint) {
        let blockNode = block.generateNode(for: isoBlockSize.width)
        blockNode.position = location
        blockNode.anchorPoint = .zero
        blockNode.setScale(0.1)
        blockNode.alpha = 0.0

        levelView.addChild(blockNode)
    }

    // MARK: - Performance Handling
    private func disableInvisbleNodes(frame: CGRect) {
        let frame = frame.inset(by: .init(top: 10, left: 10, bottom: 10, right: 10))

        levelView.children.forEach { node in
            let isVisible = node.frame.intersects(frame)
            let wasPreviouslyVisible = node.isHidden || node.isPaused
            guard wasPreviouslyVisible != isVisible else { return }

            node.isHidden = !isVisible
            node.isPaused = !isVisible

            guard node != droidNode, isVisible else { return }

            // We animate all blocks in and out depending if they will be visible
            let scale: SKAction = .scale(to: 1.0, duration: 0.1)
            let fade: SKAction = .fadeAlpha(to: 1.0, duration: 0.1)

            node.run(.sequence([.wait(forDuration: 0.1), .group([scale, fade])]))
        }
    }

    // MARK: - Reloading
    func reloadLevel() {
        levelView.removeAllChildren()
        render()
    }

    func clearLevel() {
        levelView.removeAllChildren()
        loadedLevel = nil
    }

    // MARK: - Teleporting
    func teleportLocation(using style: BlockStyle) -> CGPoint? {
        guard let level = loadedLevel, let location = getDroidLocation() else { return nil }
        let index = CGPoint(x: Int(round(location.x)), y: Int(round(location.y)))

        guard let teleportLocation = level.teleportations[style]?.getTeleportedLocation(from: index) else { return nil }
        return renderLocation(of: CGPoint(x: teleportLocation.x + Constants.droidOffset.x, y: teleportLocation.y + Constants.droidOffset.y))
    }

    // MARK: - Coordinate Transformations
    private func renderLocation(of location: CGPoint) -> CGPoint {
        let standardBlockLocation = CGPoint(x: -location.y * blockSize.height, y: location.x * blockSize.width)
        let transformedLocation = IsometricAxis.transformed(point: standardBlockLocation, matrix: IsometricAxis.standardToIsoMatrix)
        return transformedLocation
    }

    private func mapLocation(of location: CGPoint, isRasterized: Bool = true) -> CGPoint {
        let newVector = IsometricAxis.transformed(point: location, matrix: IsometricAxis.isoToStandardMatrix)

        if isRasterized {
            return CGPoint(x: round(newVector.y / blockSize.height), y: -round(newVector.x / blockSize.width))
        } else {
            return CGPoint(x: newVector.y / blockSize.height, y: -newVector.x / blockSize.width)
        }
    }

    private func calculateIsoBlocksize(for blockSize: CGSize) -> CGSize {
        let xAngle = CGVector(dx: -1, dy: 0).angleInRadians(IsometricAxis.left.vector)
        let yAngle = CGVector(dx: -1, dy: 0).angleInRadians(IsometricAxis.right.vector)

        let width = 2 * cos(xAngle) * blockSize.width
        let height = 2 * sin(yAngle) * blockSize.height

        return CGSize(width: width, height: height - blockSize.height)
    }

    // MARK: - Depth Sorting
    private func depthSortNodes() {
        var sortableNodes = levelView.children
        sortableNodes.removeAll { $0 is Droid && $0.isHidden }

        let indexedNodes = sortableNodes.map { node -> (node: SKNode, index: Int) in
            let location = mapLocation(of: node.position)
            return (node, Int(location.x) - Int(location.y))
        }

        indexedNodes.forEach { node, index in
            node.zPosition = CGFloat(index)
        }

        // We evaluate the droid location seperately because it location is not bound
        // to indexes of the tileMap. We also increment by 1 because it
        // allows us to ensure the droid is above the nodes in its own position
        // e.g. if it stands on the start block it should be on top of the start block.
        guard let droidLocation = getDroidLocation() else { return }
        droidNode?.zPosition = droidLocation.x - droidLocation.y + 1
    }
}
