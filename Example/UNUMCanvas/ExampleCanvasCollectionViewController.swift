import UIKit
import UNUMCanvas
import Anchorage

final class ExampleCanvasCollectionViewController: UIViewController {
    
    private let canvasController = CanvasController()
    private let canvasRegion = CanvasRegionView()

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
        
        var bundle = Bundle(identifier: "org.cocoapods.UNUMCanvas")
        if let resourcePath = bundle?.path(forResource: "Media", ofType: "bundle") {
            bundle = Bundle(path: resourcePath)!
        }
        
        // Add imageView that should be interactable.
        if let image = UIImage(named: "test_image", in: bundle, compatibleWith: nil) {
            
            let imageHeightRatio = image.size.height / image.size.width

            interactableView1 = UIImageView(image: image)
            interactableView1.contentMode = .scaleAspectFit
            collectionView.addSubview(interactableView1)
            
            interactableView1.topAnchor == collectionView.topAnchor + 100
            interactableView1.leadingAnchor == collectionView.leadingAnchor + 100
            interactableView1.widthAnchor ==  100
            interactableView1.heightAnchor == interactableView1.widthAnchor * imageHeightRatio
        }

        // Add view that should be interactable.
        interactableView2 = UIView()
        collectionView.addSubview(interactableView2)
        
        interactableView2.topAnchor == collectionView.topAnchor + 100
        interactableView2.leadingAnchor == collectionView.leadingAnchor + 100
        interactableView2.sizeAnchors == CGSize(width: 100, height: 100)

        interactableView2.backgroundColor = .green

        // Setup canvasController with appropriate views. In this example, the canvasViews will be the tableViewCells, which will need to be added to the canvasController when they are setup.
        canvasRegion.interactableViews.append(contentsOf: [interactableView1, interactableView2])
        canvasRegion.regionView = view
        
        canvasController.selectedView = interactableView2
        canvasController.gestureRecognizingView = collectionView
        canvasController.canvasRegionViews = [canvasRegion]
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
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .red
        }
        else {
            cell.backgroundColor = .purple
        }
        
        // Add the cells as canvases to the canvasController.
        canvasRegion.canvasViews.append(cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            navigationController?.pushViewController(ExampleSingleCanvasViewController(), animated: true)
        }
        else {
            navigationController?.pushViewController(MultipleCanvasRegionViewController(), animated: true)
        }
    }
}

extension ExampleCanvasCollectionViewController: SelectedViewObserving {
    func selectedValueChanged(to view: UIView?) {
        collectionView.isScrollEnabled = view == nil
    }
}
