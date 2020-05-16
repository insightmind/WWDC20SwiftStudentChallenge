// Copyright © 2020 Niklas Buelow. All rights reserved.

import SpriteKit

class Droid: SKNode {
    // MARK: - Constants
    enum Constants {
        static let linearDamping: CGFloat = 3.0
        static let velocity: CGFloat = 200.0
    }

    // MARK: - Properties
    let droidType: DroidType
    var moveDirection: MoveDirection = .downRight {
        didSet {
            guard oldValue != moveDirection else { return }
            let action: SKAction = .setTexture(getTexture(for: moveDirection))
            actorNode.run(action)
        }
    }

    // MARK: - Childnodes
    private lazy var actorNode: SKSpriteNode = SKSpriteNode(texture: getTexture(for: moveDirection))
    private var moveTimer: Timer?

    // MARK: - Initialization
    init(type: DroidType) {
        droidType = type

        super.init()
        configurePhysicsBody()

        addChild(actorNode)
        actorNode.anchorPoint = CGPoint(x: 0.75, y: 0.25)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configurePhysicsBody() {
        let size = actorNode.size
        physicsBody = SKPhysicsBody(rectangleOf: size, center: CGPoint(x: 0, y: size.height / 4))
        physicsBody?.allowsRotation = false
        physicsBody?.linearDamping = Constants.linearDamping
    }

    // MARK: - Movement
    func startsMoving(to direction: MoveDirection) {
        guard direction != moveDirection || moveTimer == nil else { return }
        moveDirection = direction

        let moveVector = direction.directionVector.multiplied(by: Constants.velocity)
        physicsBody?.applyImpulse(moveVector)

        moveTimer?.invalidate()
        moveTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.physicsBody?.velocity = moveVector
        }

        moveTimer?.fire()
    }

    func stopsMoving() {
        moveTimer?.invalidate()
        moveTimer = nil
    }

    // MARK: - Texture Loading
    private func getTexture(for direction: MoveDirection) -> SKTexture {
        switch direction {
        case .downLeft:
            return SKTexture(imageNamed: Images.Actors.getFileName(for: droidType.rawValue, name: Images.Actors.leftFront))

        case .downRight:
            return SKTexture(imageNamed: Images.Actors.getFileName(for: droidType.rawValue, name: Images.Actors.rightFront))

        case .upLeft:
            return SKTexture(imageNamed: Images.Actors.getFileName(for: droidType.rawValue, name: Images.Actors.rightBack))

        case .upRight:
            return SKTexture(imageNamed: Images.Actors.getFileName(for: droidType.rawValue, name: Images.Actors.leftBack))
        }
    }
}
