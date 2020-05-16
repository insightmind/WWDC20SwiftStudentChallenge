import UIKit
import SpriteKit

class LightningPath: SKNode {
    let path: [CGPoint]
    let lineWidth: CGFloat
    let color: UIColor

    init(path: [CGPoint], color: UIColor, lineWidth: CGFloat) {
        self.lineWidth = lineWidth
        self.color = color
        self.path = path

        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        self.path = []
        self.color = .white
        self.lineWidth = 2.0

        super.init(coder: aDecoder)!
    }

    func draw() {
        guard path.count >= 2 else { return }

        let bezierPath = UIBezierPath()
        bezierPath.move(to: .zero)

        for index in 0 ..< path.count - 1 {
            let firstPoint = path[index]
            let secondPoint = path[index + 1]

            let currentPoint = bezierPath.currentPoint
            let distancePoint = CGPoint(x: secondPoint.x - firstPoint.x, y: secondPoint.y - firstPoint.y)
            let offsetPoint = CGPoint(x: currentPoint.x + distancePoint.x, y: currentPoint.y + distancePoint.y)
            bezierPath.addLine(to: offsetPoint)
        }

        let lightningSegment = SKShapeNode(path: bezierPath.cgPath)

        lightningSegment.lineWidth = lineWidth
        lightningSegment.strokeColor = color
        lightningSegment.glowWidth = 2.0
        lightningSegment.lineCap = .round
        lightningSegment.blendMode = .alpha

        lightningSegment.position = path[0]

        self.addChild(lightningSegment)
    }
}
