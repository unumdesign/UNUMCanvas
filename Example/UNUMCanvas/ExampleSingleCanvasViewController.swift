import UIKit
import UNUMCanvas
import Anchorage

final class ExampleSingleCanvasViewController: UIViewController {
    
    private let canvasController = CanvasController(viewSelectionStyle: .media)
    private let canvasRegion = CanvasRegionView()
    
    private var interactableView1 = UIView()
    private var interactableView2 = UIView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        canvasController.isDeleteEnabledOnSelectionView = false
        
        // Add some views that should be interactable.
        interactableView1 = UIView()
        view.addSubview(interactableView1)
        interactableView1.topAnchor == view.topAnchor + 100
        interactableView1.leadingAnchor == view.leadingAnchor + 400
        interactableView1.sizeAnchors == CGSize(width: 100, height: 100)
        
        interactableView1.backgroundColor = .orange
        
        interactableView2 = UIView()
        view.addSubview(interactableView2)
        interactableView2.topAnchor == view.topAnchor + 100
        interactableView2.leadingAnchor == view.leadingAnchor + 100
        interactableView2.sizeAnchors == CGSize(width: 100, height: 100)
        
        interactableView2.backgroundColor = .green

        canvasRegion.interactableViews.append(contentsOf: [interactableView1, interactableView2])
        canvasRegion.canvasViews = [view]
        canvasRegion.regionView = view
        
        canvasController.gestureRecognizingView = view
        canvasController.canvasRegionViews = [canvasRegion]


        canvasController.selectedView = interactableView1
    }
}
