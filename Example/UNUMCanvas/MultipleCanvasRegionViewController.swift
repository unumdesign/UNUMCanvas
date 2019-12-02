import UIKit
import UNUMCanvas
import Anchorage

final class MultipleCanvasRegionViewController: UIViewController {

    private let canvasController = CanvasController(viewSelectionStyle: .region)
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

        // first region
        region1View = UIView()
        view.addSubview(region1View)
        if #available(iOS 11.0, *) {
            region1View.topAnchor == view.safeAreaLayoutGuide.topAnchor
            region1View.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor
        } else {
            region1View.topAnchor == view.topAnchor
            region1View.bottomAnchor == view.bottomAnchor
        }
        region1View.leadingAnchor == view.leadingAnchor
        region1View.widthAnchor == halfWidth

        region1View.backgroundColor = .lightGray
        region1View.clipsToBounds = true

        // second region
        region2View = UIView()
        view.addSubview(region2View)

        if #available(iOS 11.0, *) {
            region2View.topAnchor == view.safeAreaLayoutGuide.topAnchor
            region2View.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor
        } else {
            region2View.topAnchor == view.topAnchor
            region2View.bottomAnchor == view.bottomAnchor
        }
        region2View.leadingAnchor == view.leadingAnchor + halfwayLocation
        region2View.widthAnchor == halfWidth

        region2View.clipsToBounds = true
        region2View.backgroundColor = .darkGray

        // first interactableView
        interactableView1 = UIView()
        region1View.addSubview(interactableView1)

        interactableView1.topAnchor == region1View.topAnchor + 400
        interactableView1.leadingAnchor == region1View.leadingAnchor + 100
        interactableView1.sizeAnchors == CGSize(width: 100, height: 100)

        interactableView1.backgroundColor = .orange

        // setup canvasRegion with interactableView
        canvasRegion1.interactableViews.append(contentsOf: [interactableView1])
        canvasRegion1.canvasViews = [region1View]
        canvasRegion1.regionView = region1View

        // second interactableView
        interactableView2 = UIView()
        region2View.addSubview(interactableView2)
        interactableView2.topAnchor == region2View.topAnchor + 100
        interactableView2.leadingAnchor == region2View.leadingAnchor + 100
        interactableView2.sizeAnchors == CGSize(width: 100, height: 100)

        interactableView2.backgroundColor = .green

        // setup canvasRegion with interactableView
        canvasRegion2.interactableViews.append(contentsOf: [interactableView2])
        canvasRegion2.canvasViews = [region2View]
        canvasRegion2.regionView = region2View

        // finish setup of canvasController
        canvasController.gestureRecognizingView = view
        canvasController.canvasRegionViews = [canvasRegion1, canvasRegion2]
    }
}
