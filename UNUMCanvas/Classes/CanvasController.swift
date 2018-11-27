import UIKit
import Anchorage

class PanScalingType {
    enum Vertical {
        case bottom
        case top
        case notActivated
    }
    enum Horizontal {
        case leading
        case trailing
        case notActivated
    }
    var vertical: Vertical
    var horizontal: Horizontal
    
    init(vertical: Vertical, horizontal: Horizontal) {
        self.vertical = vertical
        self.horizontal = horizontal
    }
}

@objc public protocol SelectedViewObserving: AnyObject {
    func selectedValueChanged(to view: UIView?)
    
    /// An optional function indicating when a tap was in a selectableView. This is needed only when there are other entities that are handling tap events in the same clickable-area, such as if an interactableView is added on top of a tableView or a collectionView. This enables you to make sure to disable their tap events when the tap is within an interactableView.
    @objc optional func tapWasInSelectableView()
}

public class CanvasRegionView {
    public var interactableViews: [UIView] = []
    public var canvasViews: [UIView] = []
    public var regionView: UIView = UIView()
    
    public init() {}
}

public class CanvasController: NSObject {
    
    
    // MARK: - public API
    
    /// The area interactable views are limited to and differentiates click-regions. If clicking in that region, then only interactableViews of that region should be considered interactable.
    public var canvasRegionViews: [CanvasRegionView] = []
    
    public var selectedView: UIView? {
        didSet {
            allInteractableViews.forEach({ interactableView in
                interactableView.subviews.forEach { subview in
                    if let selectedView = subview as? SelectionShowingView {
                        selectedView.removeFromSuperview()
                    }
                }
            })
            
            addSelectionShowingView()
            
            selectedViewObservingDelegate?.selectedValueChanged(to: selectedView)
        }
    }
    
    var panScalingType = PanScalingType(vertical: .notActivated, horizontal: .notActivated)

    private func addSelectionShowingView() {
        guard let selectedView = selectedView else {
            return
        }
            
        // store the view's transform so that it can be reapplied after moving the view.
        let transformToReapply = selectedView.transform
        
        // reset transform to allow proper directional navigation of object
        selectedView.transform = CGAffineTransform.identity
        
        let selectionShowingView = SelectionShowingView()
        selectedView.addSubview(selectionShowingView)
        selectionShowingView.topAnchor == selectedView.topAnchor
        selectionShowingView.leadingAnchor == selectedView.leadingAnchor
        selectionShowingView.sizeAnchors == selectedView.sizeAnchors
        
        // return transform onto view in order to keep previous transformations on the view
        selectedView.transform = transformToReapply
    }
    
    public weak var selectedViewObservingDelegate: SelectedViewObserving?
    
    // MARK: - private variables
    
    /// The main view which handles all touch events and movement of interactableViews.
    public weak var gestureRecognizingView: UIView! {
        didSet { setupGestureRecognizers() }
    }
    
    private var allInteractableViews: [UIView] {
        var views: [UIView] = []
        canvasRegionViews.forEach({ $0.interactableViews.forEach({ views.append($0) })})
        return views
    }
    
    var allCanvasViews: [UIView] {
        var views: [UIView] = []
        canvasRegionViews.forEach({ $0.canvasViews.forEach({ views.append($0) })})
        return views
    }
    
    let absoluteVelocityEnablingLocking: CGFloat = 100
    let absoluteDistanceEnablingLocking: CGFloat = 20
    
    private var tapGesture = UITapGestureRecognizer()
    private var panGesture = UIPanGestureRecognizer()
    private var pinchGesture = UIPinchGestureRecognizer()
    private var rotationGesture = UIRotationGestureRecognizer()
    
    
    public override init() {
        super.init()
    }
    
    private func setupGestureRecognizers() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnViewController(_:)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panOnViewController(_:)))
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scaleSelectedView(_:)))
        rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateSelectedViewController(_:)))
        
        [tapGesture, panGesture, pinchGesture, rotationGesture].forEach { [weak self] gesture in
            guard let `self` = self else {
                return
            }
            gesture.cancelsTouchesInView = false
            gestureRecognizingView.addGestureRecognizer(gesture)
            gesture.delegate = self
        }
    }
}

extension CanvasController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
