import UIKit
import UNUMCanvas

class ExampleSingleCanvasViewController: UIViewController {
    
    let canvasController = CanvasController()
    
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
        interactableView1.backgroundColor = .blue
        view.addSubview(interactableView1)
        
        interactableView2 = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        interactableView2.backgroundColor = .green
        view.addSubview(interactableView2)
        
        // Setup canvasController with appropriate views. In this example, the canvas is the same as the main view.
        canvasController.interactableViews.append(contentsOf: [interactableView1, interactableView2])
        canvasController.selectedView = interactableView1
        canvasController.mainView = view
        canvasController.canvasViews = [view]
    }
}
