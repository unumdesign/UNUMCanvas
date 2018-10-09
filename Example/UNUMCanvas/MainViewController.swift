import UIKit
import UNUMCanvas

class MainViewController: CanvasController {
    
    private var canvasView1 = UIView()
    private var canvasView2 = UIView()
    
    private var interactableView1 = UIView()
    private var interactableView2 = UIView()
    
    override init() {
        super.init()
        movableViews.append(interactableView1)
        movableViews.append(interactableView2)
        selectedView = interactableView1
        
        canvasViews.append(canvasView1)
        canvasViews.append(canvasView2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        canvasView1 = UIView(frame: CGRect(x: 200, y: 200, width: 400, height: 400))
        canvasView1.backgroundColor = .lightGray
        view.addSubview(canvasView1)
        
        canvasView2 = UIView(frame: CGRect(x: 400, y: 400, width: 300, height: 300))
        canvasView2.backgroundColor = .yellow
        view.addSubview(canvasView2)
        
        
        interactableView1 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        interactableView1.backgroundColor = .red
        view.addSubview(interactableView1)
        interactableView1.center = view.center
        
        interactableView2 = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        interactableView2.backgroundColor = .green
        view.addSubview(interactableView2)
    }
}

