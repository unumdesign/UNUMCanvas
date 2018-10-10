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
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Views below are setup to experiement on iPads. You can still run on an iPhone but some of the contents will be off-screen.
        
        interactableView1 = UIView(frame: CGRect(x: 100, y: 400, width: 100, height: 100))
        interactableView1.backgroundColor = .blue
        collectionView.addSubview(interactableView1)
        
        interactableView2 = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        interactableView2.backgroundColor = .green
        collectionView.addSubview(interactableView2)
        
        canvasController.interactableViews.append(contentsOf: [interactableView1, interactableView2])
        canvasController.selectedView = interactableView1
        canvasController.mainView = collectionView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        navigationController?.pushViewController(UIViewController(nibName: nil, bundle: nil), animated: true)
    }
}
