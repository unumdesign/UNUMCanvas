import UIKit
import UNUMCanvas

final class ExampleCanvasCollectionViewController: UIViewController {
    
    private let canvasController = CanvasController()
    private let collectionView: UICollectionView
    
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
        
        // Setup collectionView
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self

        canvasController.selectedViewObservingDelegate = self
        
        // Add some views that should be interactable.
        interactableView1 = UIView(frame: CGRect(x: 100, y: 150, width: 100, height: 100))
        interactableView1.backgroundColor = .orange
        collectionView.addSubview(interactableView1)

        interactableView2 = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        interactableView2.backgroundColor = .green
        collectionView.addSubview(interactableView2)

        // Setup canvasController with appropriate views. In this example, the canvasViews will be the tableViewCells, which will need to be added to the canvasController when they are setup.
        canvasController.interactableViews.append(contentsOf: [interactableView1, interactableView2])
        canvasController.selectedView = interactableView2
        canvasController.mainView = collectionView

    }
}

extension ExampleCanvasCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension ExampleCanvasCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionViewCell.self), for: indexPath)
        cell.backgroundColor = .red
        
        // Add the cells as canvases to the canvasController.
        canvasController.canvasViews.append(cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(ExampleSingleCanvasViewController(), animated: true)
    }
}

extension ExampleCanvasCollectionViewController: SelectedViewObserving {
    func selectedValueChanged(to view: UIView?) {
        collectionView.isScrollEnabled = view == nil
    }
}
