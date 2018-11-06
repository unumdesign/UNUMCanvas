import UIKit
import UNUMCanvas

final class MultipleCanvasRegionViewController: UIViewController {
    
    private let canvasController = CanvasController()
    private let canvasRegion1 = CanvasRegionView()
    private let canvasRegion2 = CanvasRegionView()
    
    private var region1View = UIView()
    private var region2View = UIView()
    
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
        
        let halfWidth = view.frame.width / 2
        let halfwayLocation = halfWidth
        
        region1View = UIView(frame: CGRect(x: 0, y: 0, width: halfWidth, height: view.frame.height))
        region1View.backgroundColor = .lightGray
        region1View.clipsToBounds = true
        view.addSubview(region1View)
        
        region2View = UIView(frame: CGRect(x: halfwayLocation, y: 0, width: halfWidth, height: view.frame.height))
        region2View.clipsToBounds = true
        region2View.backgroundColor = .darkGray
        view.addSubview(region2View)
        
        // Add some views that should be interactable.
        interactableView1 = UIView(frame: CGRect(x: 100, y: 400, width: 100, height: 100))
        interactableView1.backgroundColor = .orange
        region1View.addSubview(interactableView1)
        canvasRegion1.interactableViews.append(contentsOf: [interactableView1])
        canvasRegion1.canvasViews = [region1View]
        canvasRegion1.regionView = region1View
        
        interactableView2 = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        interactableView2.backgroundColor = .green
        region2View.addSubview(interactableView2)
        canvasRegion2.interactableViews.append(contentsOf: [interactableView2])
        canvasRegion2.canvasViews = [region2View]
        canvasRegion2.regionView = region2View
        
        canvasController.selectedView = interactableView1
        canvasController.gestureRecognizingView = view
        canvasController.canvasRegionViews = [canvasRegion1, canvasRegion2]
    }
}
