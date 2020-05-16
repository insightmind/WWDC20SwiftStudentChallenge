import SpriteKit

protocol MenuCubeDelegate: AnyObject {
    func didSelectAction(for axis: IsometricAxis)
}

public class InteractableCube: SKNode {
    // MARK: NodeSelectors
    /// NodeSelectors are used to describe a specific node in the scene in
    /// a more declarative way.
    ///
    /// - title: Describes the titleNode
    /// - startButton: Describes the startButtonNode
    /// - settingsButton: Describes the settingsButtonNode
    enum NodeSelectors: String, NodeSelector {
        case topButton
        case leftButton
        case rightButton

        var isUserInteractable: Bool { true }

        static func getCase(for axis: IsometricAxis) -> Self {
            switch axis {
            case .vertical: return topButton
            case .left: return leftButton
            case .right: return rightButton
            }
        }
    }

    // MARK: - Model
    public struct ViewModel {
        var standardCubeFileName: String
        var topModel: CubeButton.ViewModel?
        var rightModel: CubeButton.ViewModel?
        var leftModel: CubeButton.ViewModel?

        func getModel(for axis: IsometricAxis) -> CubeButton.ViewModel? {
            switch axis {
            case .vertical:
                return topModel

            case .left:
                return leftModel

            case .right:
                return rightModel
            }
        }
    }

    // MARK: - Properties
    private(set) var model: ViewModel
    weak var delegate: MenuCubeDelegate?

    // MARK: - Child-Nodes
    private lazy var cubeNode: SKSpriteNode = SKSpriteNode(imageNamed: model.standardCubeFileName)

    private var buttons: [IsometricAxis: CubeButton] = [:]

    // MARK: - Initialization
    init(model: ViewModel) {
        self.model = model

        super.init()

        isUserInteractionEnabled = true

        addChild(cubeNode)

        addButton(for: .vertical, model: model.topModel)
        addButton(for: .right, model: model.rightModel)
        addButton(for: .left, model: model.leftModel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func reset() {
        buttons.values.forEach { $0.reset() }
    }

    // MARK: Layout
    private func addButton(for axis: IsometricAxis, model: CubeButton.ViewModel?) {
        guard let model = model else { return }

        let node = CubeButton(model: model, axis: axis)
        let axisVector = IsometricAxis.vertical.vector
        node.position = CGPoint(x: 30 * axisVector.dx, y: 30 * axisVector.dy)
        node.name = NodeSelectors.getCase(for: axis).rawValue

        buttons[axis] = node
        addChild(node)
    }

    // MARK: UserInteraction
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let node = findTouchedNode(for: touches, with: NodeSelectors.selectableNodes) else { return }
        didSelect(node)
    }

    /// Handles and coordinates touch action of the given node.
    ///
    /// - Parameter node: The node which has been selected.
    private func didSelect(_ node: SKNode) {
        guard let buttonNode = node as? CubeButton else { return }

        buttons.values.forEach { button in
            button.animateSelection(isSelected: button.name == buttonNode.name)
        }

        delegate?.didSelectAction(for: buttonNode.axis)
    }

    func setCubeTexture(texture: SKTexture) {
        let textureAction: SKAction = .setTexture(texture, resize: true)
        cubeNode.run(textureAction)
    }
}
