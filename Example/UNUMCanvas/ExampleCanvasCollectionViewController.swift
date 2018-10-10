import UIKit
import UNUMCanvas

class ExampleCanvasCollectionViewController: UIViewController {
    
    let canvasController = CanvasController()
    let collectionView: UICollectionView
    
    private var interactableView1 = UIView()
    private var interactableView2 = UIView()
    
    init() {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        
        super.init(nibName: nil, bundle: nil)
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Views below are setup to experiement on iPads. You can still run on an iPhone but some of the contents will be off-screen.
        
        collectionView.frame = view.frame
        
        interactableView1 = UIView(frame: CGRect(x: 100, y: 400, width: 100, height: 100))
        interactableView1.backgroundColor = .blue
        collectionView.addSubview(interactableView1)
        interactableView1.center = view.center
        
        interactableView2 = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        interactableView2.backgroundColor = .green
        collectionView.addSubview(interactableView2)
        
        canvasController.movableViews.append(interactableView1)
        canvasController.movableViews.append(interactableView2)
        canvasController.selectedView = interactableView1

        canvasController.interactableView = collectionView
        canvasController.setupViewGestures(view: collectionView)
    }
}

extension ExampleCanvasCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension ExampleCanvasCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionViewCell.self), for: indexPath)
        cell.backgroundColor = .red
        
        canvasController.canvasViews.append(cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }
}
