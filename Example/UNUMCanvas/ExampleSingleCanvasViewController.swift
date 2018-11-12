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
        interactableView1 = UIView()//UIView(frame: CGRect(x: 100, y: 400, width: 100, height: 100))
        view.addSubview(interactableView1)
        interactableView1.translatesAutoresizingMaskIntoConstraints = false
        interactableView1.topAnchor.constraint(equalTo: interactableView1.superview!.topAnchor, constant: 400).isActive = true
        interactableView1.leadingAnchor.constraint(equalTo: interactableView1.superview!.leadingAnchor, constant: 100).isActive = true
        interactableView1.widthAnchor.constraint(equalToConstant: 100).isActive = true
        interactableView1.heightAnchor.constraint(equalToConstant: 100).isActive = true
        interactableView1.backgroundColor = .orange
        
        interactableView2 = UIView()//UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        interactableView2.backgroundColor = .green
        view.addSubview(interactableView2)
        interactableView2.translatesAutoresizingMaskIntoConstraints = false
        interactableView2.topAnchor.constraint(equalTo: interactableView1.superview!.topAnchor, constant: 100).isActive = true
        interactableView2.leadingAnchor.constraint(equalTo: interactableView1.superview!.leadingAnchor, constant: 100).isActive = true
        interactableView2.widthAnchor.constraint(equalToConstant: 100).isActive = true
        interactableView2.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        canvasRegion.interactableViews.append(contentsOf: [interactableView1, interactableView2])
        canvasRegion.canvasViews = [view]
        canvasRegion.regionView = view
        
        canvasController.selectedView = interactableView1
        canvasController.gestureRecognizingView = view
        canvasController.canvasRegionViews = [canvasRegion]
    }
}
