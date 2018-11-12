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
        
        region1View = UIView()//UIView(frame: CGRect(x: 0, y: 0, width: halfWidth, height: view.frame.height))
        view.addSubview(region1View)
        region1View.translatesAutoresizingMaskIntoConstraints = false
        region1View.topAnchor.constraint(equalTo: region1View.superview!.topAnchor, constant: 0).isActive = true
        region1View.leadingAnchor.constraint(equalTo: region1View.superview!.leadingAnchor, constant: 0).isActive = true
        region1View.widthAnchor.constraint(equalToConstant: halfWidth).isActive = true
        region1View.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        region1View.backgroundColor = .lightGray
        region1View.clipsToBounds = true
        
        region2View = UIView()//UIView(frame: CGRect(x: halfwayLocation, y: 0, width: halfWidth, height: view.frame.height))
        view.addSubview(region2View)
        region2View.translatesAutoresizingMaskIntoConstraints = false
        region2View.topAnchor.constraint(equalTo: region2View.superview!.topAnchor).isActive = true
        region2View.leadingAnchor.constraint(equalTo: region2View.superview!.leadingAnchor, constant: halfwayLocation).isActive = true
        region2View.widthAnchor.constraint(equalToConstant: halfWidth).isActive = true
        region2View.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        region2View.clipsToBounds = true
        region2View.backgroundColor = .darkGray
        
        // Add some views that should be interactable.
        interactableView1 = UIView()//UIView(frame: CGRect(x: 100, y: 400, width: 100, height: 100))
        region1View.addSubview(interactableView1)
        interactableView1.translatesAutoresizingMaskIntoConstraints = false
        interactableView1.topAnchor.constraint(equalTo: interactableView1.superview!.topAnchor, constant: 400).isActive = true
        interactableView1.leadingAnchor.constraint(equalTo: interactableView1.superview!.leadingAnchor, constant: 100).isActive = true
        interactableView1.widthAnchor.constraint(equalToConstant: 100).isActive = true
        interactableView1.heightAnchor.constraint(equalToConstant: 100).isActive = true
        interactableView1.backgroundColor = .orange
        canvasRegion1.interactableViews.append(contentsOf: [interactableView1])
        canvasRegion1.canvasViews = [region1View]
        canvasRegion1.regionView = region1View
        
        interactableView2 = UIView()//UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        region2View.addSubview(interactableView2)
        interactableView2.translatesAutoresizingMaskIntoConstraints = false
        interactableView2.topAnchor.constraint(equalTo: interactableView2.superview!.topAnchor, constant: 100).isActive = true
        interactableView2.leadingAnchor.constraint(equalTo: interactableView2.superview!.leadingAnchor, constant: 100).isActive = true
        interactableView2.widthAnchor.constraint(equalToConstant: 100).isActive = true
        interactableView2.heightAnchor.constraint(equalToConstant: 100).isActive = true
        interactableView2.backgroundColor = .green
        canvasRegion2.interactableViews.append(contentsOf: [interactableView2])
        canvasRegion2.canvasViews = [region2View]
        canvasRegion2.regionView = region2View
        
        canvasController.selectedView = interactableView1
        canvasController.gestureRecognizingView = view
        canvasController.canvasRegionViews = [canvasRegion1, canvasRegion2]
    }
}
