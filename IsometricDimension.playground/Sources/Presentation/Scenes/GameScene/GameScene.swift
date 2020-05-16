// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

class GameScene: FlowableScene<LevelConfig> {
    // MARK: - Properties
    private let levelPresenter = LevelPresenter()
    private var levelManager: LevelManager?

    private(set) var isLevelCompleted: Bool = false
    private let updateFrequency: Int = 30
    private var currentFrame: Int = 0

    private var currentDirection: MoveDirection?
    private var previousBlockType: BlockType = .air

    // MARK: - Nodes
    private lazy var interface: GameUserInterface = .init(size: size, delegate: self, actorDelegate: self)
    private lazy var pauseMenu: PauseMenu = .init(size: size, delegate: self)
    private lazy var lightning: Lightning = Lightning(size: size)
    private lazy var droid: Droid = {
        let node = Droid(type: .current)
        node.setScale(0.15)
        node.position = CGPoint(x: size.width / 2, y: size.height / 2)
        return node
    }()

    private lazy var cameraNode: SKCameraNode = {
        let node = SKCameraNode()
        node.setScale(1.0)
        return node
    }()

    // MARK: - Configuration
    override func configureScene(using model: LevelConfig) {
        super.configureScene(using: model)
        physicsWorld.gravity = .zero
        camera = cameraNode

        // Load LevelManager
        levelManager = LevelManager(config: model, delegate: interface)

        // Load Level
        let level = levelPresenter.loadLevel(for: model, droid: droid)
        addChild(level)

        levelManager?.startLevel()
        interface.setClock(enabled: true)
 
        // Configure User Actors
        addChild(interface)
        addChild(pauseMenu)
        addChild(lightning)

        pauseMenu.isHidden = true
        pauseMenu.isPaused = true

        interface.zPosition = 1_000
        lightning.zPosition = 1_000
        pauseMenu.zPosition = 2_000
    }

    // MARK: - Frame Updates
    override func didSimulatePhysics() {
        super.didSimulatePhysics()

        guard !isLevelCompleted, let camera = camera else { return }
        camera.position = droid.position
        lightning.position = camera.position
        interface.position = camera.position
        pauseMenu.position = camera.position

        guard currentFrame >= updateFrequency else {
            currentFrame += 1
            return
        }

        let origin = CGPoint(x: droid.position.x - size.width / 2, y: droid.position.y - size.height / 2)
        let visibleFrame = CGRect(origin: origin, size: size)
        levelPresenter.updateLevel(frame: visibleFrame)

        guard isUserInteractionEnabled else { return }
        evaluateDroidLocation()
    }

    private func evaluateDroidLocation() {
        let blockType = levelPresenter.getBlockAtDroid()?.type ?? .air

        guard !isLevelCompleted, blockType != previousBlockType else { return }
        previousBlockType = blockType

        switch blockType {
        case .air:
            failLevel()

        case .finish:
            finishLevel()

        case let .styled(style):
            teleport(style: style)

        default:
            return
        }
    }

    // MARK: - Completion Handlers
    private func failLevel() {
        isLevelCompleted = true
        droid.stopsMoving()
        droid.zPosition -= 1
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] timer in
            guard let self = self else { return }
            self.flowDelegate?.changeGameState(to: .game(config: self.model), with: .crossDisolve)
            timer.invalidate()
        }
    }

    private func finishLevel() {
        guard let result = levelManager?.getResults() else { return }
        isLevelCompleted = true
        droid.stopsMoving()
        physicsWorld.gravity = CGVector(dx: 0, dy: 9)

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] timer in
            self?.flowDelegate?.changeGameState(to: .completion(model: result), with: .crossDisolve)
            timer.invalidate()
        }
    }

    // MARK: - Teleportation
    private func teleport(style: BlockStyle) {
        guard let location = levelPresenter.teleportLocation(using: style) else { return }

        let fadeOutAction: SKAction = .fadeOut(withDuration: 0.2)
        let enableUserInteractivity: SKAction = .run { [weak self] in
            self?.isUserInteractionEnabled = true
        }

        let cameraMoveAction: SKAction = .move(to: location, duration: 0.6)
        cameraMoveAction.timingMode = .easeInEaseOut

        droid.stopsMoving()
        isUserInteractionEnabled = false

        droid.run(.sequence([fadeOutAction, cameraMoveAction, enableUserInteractivity, fadeOutAction.reversed()]))
        cameraNode.run(.sequence([.wait(forDuration: 0.2), cameraMoveAction]))
    }

    // MARK: - Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        // We somehow do not receive touch events in the interface node. So we capture them here and
        // distribute them to the interface manually if necessary.
        if let node = findTouchedNode(for: touches, with: GameUserInterface.NodeSelectors.selectableNodes) {
            interface.didSelect(node)
            return
        }

        guard let location = touches.first?.location(in: self) else { return }
        startLightning(from: location)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let location = touches.first?.location(in: self) else { return }
        startLightning(from: location)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        lightning.stopLightning()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        lightning.stopLightning()
    }

    // MARK: - Lightning
    private func startLightning(from location: CGPoint) {
        let relativeXLocation = (location.x - lightning.position.x) / lightning.size.width
        let relativeYLocation = (location.y - lightning.position.y) / lightning.size.height
        lightning.startLightning(start: .zero, end: CGPoint(x: relativeXLocation, y: relativeYLocation))
    }
}

// MARK: - UserInteractorDelegate
extension GameScene: ActorControlDelegate {
    func startsMoving(direction: MoveDirection) {
        guard isUserInteractionEnabled, !isLevelCompleted else { return }
        droid.startsMoving(to: direction)
    }

    func stopsMoving() {
        droid.stopsMoving()
    }
}

extension GameScene: UserInterfaceDelegate {
    func didPressPauseButton() {
        pauseMenu.transitionIn()
        interface.setClock(enabled: false)
        levelManager?.pauseLevel()
    }
}

extension GameScene: PauseMenuDelegate {
    func didTapCloseButton() {
        flowDelegate?.changeGameState(to: .menu, with: .crossDisolve)
    }

    func didTapResumeButton() {
        pauseMenu.transitionOut()
        interface.setClock(enabled: true)
        levelManager?.startLevel()
    }
}
