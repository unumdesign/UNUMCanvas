import UIKit
import UNUMCanvas

final class ExampleSingleCanvasViewController: UIViewController {
    
    private let canvasController = CanvasController()
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
        
        // Add some views that should be interactable.
        interactableView1 = UIView(frame: CGRect(x: 100, y: 400, width: 100, height: 100))
        interactableView1.backgroundColor = .orange
        view.addSubview(interactableView1)
        
        interactableView2 = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        interactableView2.backgroundColor = .green
        view.addSubview(interactableView2)
        
        
        canvasRegion.interactableViews.append(contentsOf: [interactableView1, interactableView2])
        canvasRegion.canvasViews = [view]
        canvasRegion.regionView = view
        
        canvasController.selectedView = interactableView1
        canvasController.gestureRecognizingView = view
        canvasController.canvasRegionViews = [canvasRegion]
    }
}
