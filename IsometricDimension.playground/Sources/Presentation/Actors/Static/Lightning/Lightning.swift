import Foundation
import SpriteKit

public class Lightning: SKSpriteNode {
    public struct Options {
        var timeBetweenBoltsInSeconds: CGFloat = 0.15
        var boltLifetimeInSeconds: CGFloat = 0.2
        var lineDrawDelayInSeconds: CGFloat = 0.0
        var displaceCoefficient: CGFloat = 0.12
        var lineRangeCoefficient: CGFloat = 0.8

        var lineWidth: CGFloat = 1.0
        var color: UIColor = .white
    }

    private enum Constants {
        static let animationKey: String = "lightning"
    }

    // MARK: - Properties
    var options: Options

    private(set) var isEnabled: Bool = false
    private var drawTimer: Timer?
    private var currentStartPoint: CGPoint = .zero
    private var currentEndPoint: CGPoint = .zero

    // MARK: LifeCycle
    init(size: CGSize, options: Options = Options()) {
        self.options = options

        super.init(texture: nil, color: .clear, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        options = Options()

        super.init(coder: aDecoder)
    }

    // MARK: Public Methods
    func startLightning(start startPoint: CGPoint, end endPoint: CGPoint) {
        isEnabled = true

        self.currentStartPoint = CGPoint(x: size.width * startPoint.x, y: size.height * startPoint.y)
        self.currentEndPoint = CGPoint(x: size.width * endPoint.x, y: size.height * endPoint.y)

        guard drawTimer == nil else { return }
        drawTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(options.timeBetweenBoltsInSeconds), repeats: true) { [weak self] timer in
            guard let self = self else { return }

            let addAction: SKAction = .run { [weak self] in
                guard let self = self else { return }
                self.drawBolt(start: self.currentStartPoint, end: self.currentEndPoint)
            }

            self.run(addAction, withKey: Constants.animationKey)
        }
    }

    func stopLightning() {
        drawTimer?.invalidate()
        drawTimer = nil
        removeAction(forKey: Constants.animationKey)
        isEnabled = false
    }

    // MARK: Private Methods
    private func drawBolt(start startPoint: CGPoint, end endPoint: CGPoint) {
        let xRange = endPoint.x - startPoint.x
        let yRange = endPoint.y - startPoint.y
        let hypotenuse = hypot(abs(xRange), abs(yRange))
        let displacement = hypotenuse * options.displaceCoefficient

        let boltPoints = [startPoint] + createBoltPath(start: startPoint, end: endPoint, displacement: displacement)

        let lightningNode = SKNode()
        addChild(lightningNode)

        if options.lineDrawDelayInSeconds == 0 {
            addPartialBolt(path: boltPoints, delay: 0.0, onto: lightningNode)
        } else {
            for index in 0 ..< boltPoints.count - 1 {
                addPartialBolt(
                    path: [boltPoints[index], boltPoints[index + 1]],
                    delay: CGFloat(index) * options.lineDrawDelayInSeconds,
                    onto: lightningNode
                )
            }
        }

        let waitDuration = TimeInterval(CGFloat(boltPoints.count - 1) * options.lineDrawDelayInSeconds + options.boltLifetimeInSeconds)
        let waitAction: SKAction = .wait(forDuration: waitDuration)
        let fadeAction: SKAction = .fadeOut(withDuration: TimeInterval(options.boltLifetimeInSeconds))
        let removeAction: SKAction = .removeFromParent()
        let disappearAction: SKAction = .sequence([waitAction, fadeAction, removeAction])

        lightningNode.run(disappearAction)
    }

    private func addPartialBolt(path: [CGPoint], delay: CGFloat, onto node: SKNode) {
        let line = LightningPath(path: path, color: options.color, lineWidth: options.lineWidth)
        node.addChild(line)

        guard delay != 0 else {
            line.draw()
            return
        }

        let delayAction: SKAction = .wait(forDuration: TimeInterval(delay))
        let drawAction: SKAction = .run(line.draw)

        line.run(.sequence([delayAction, drawAction]))
    }

    private func createBoltPath(start startPoint: CGPoint, end endPoint: CGPoint, displacement: CGFloat) -> [CGPoint] {
        var initialPoints: [CGPoint] = []

        guard displacement >= options.lineRangeCoefficient else {
            initialPoints.append(endPoint)
            return initialPoints
        }

        let randomXDisplacement = CGFloat.random(in: -1.0 ... 1.0) * displacement
        let randomYDisplacement = CGFloat.random(in: -1.0 ... 1.0) * displacement

        let midX = (startPoint.x + endPoint.x) / 2 + randomXDisplacement
        let midY = (startPoint.y + endPoint.y) / 2 + randomYDisplacement

        let midPoint = CGPoint(x: midX, y: midY)

        initialPoints.append(contentsOf: createBoltPath(start: startPoint, end: midPoint, displacement: displacement / 2))
        initialPoints.append(contentsOf: createBoltPath(start: midPoint, end: endPoint, displacement: displacement / 2))

        return initialPoints
    }
}
