import UIKit
import Anchorage
import AVKit

public enum ViewSelectionStyle {
    /// The selection-border and close button will be on the image itself
    case media

    /// The selectionborder and close button will not be on the image, but the region containing the image.
    case region
}

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
    /// Indicates when there has been a change in which view is selected.
    func selectedValueChanged(to view: UIView?)

    /// An optional function indicating when a tap was in a selectableView. This is needed only when there are other entities that are handling tap events in the same clickable-area, such as if an interactableView is added on top of a tableView or a collectionView. This enables you to make sure to disable their tap events when the tap is within an interactableView.
    @objc optional func tapWasInSelectableView()

    /// An optional function that is called when the selectedView is removed from its superview. This function should be implemented if the removal is an event that needs to be handled. For example, if you need to add an "add" button to the canvasRegion when its interactableView is deleted, then you would do that using this function.
    @objc optional func selectedViewWasRemoved(from superview: UIView)

    /// An optional function indicating when a view has been modified in any way -- rotated, scaled, or moved.
    @objc optional func viewWasModified(view: UIView)
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

    let viewSelectionStyle: ViewSelectionStyle
    var selectionShowingView: SelectionShowingView?

    public var selectedView: UIView? {
        didSet {
            // remove selection showing view from all interactable views
            selectionShowingView?.removeFromSuperview()
            selectionShowingView = nil

            addSelectionShowingView()

            pauseVideoIfThereIsOne(on: oldValue)
            playVideoIfThereIsOne(on: selectedView)

            selectedViewObservingDelegate?.selectedValueChanged(to: selectedView)
        }
    }

    private func pauseVideoIfThereIsOne(on view: UIView?) {
        guard let playerLayer = view?.layer as? AVPlayerLayer else {
            return
        }
        playerLayer.player?.pause()
    }

    private func playVideoIfThereIsOne(on view: UIView?) {
        guard let playerLayer = view?.layer as? AVPlayerLayer else {
            return
        }
        playerLayer.player?.seek(to: CMTime.zero)
        playerLayer.player?.play()
    }

    var panScalingType = PanScalingType(vertical: .notActivated, horizontal: .notActivated)

    private func addSelectionShowingView() {
        guard let selectedView = selectedView else {
            return
        }

        switch viewSelectionStyle {
        case .media:
            addSelectionShowingView(to: selectedView)
            return
        case .region:
            for canvasRegionView in canvasRegionViews {
                if canvasRegionView.interactableViews.contains(selectedView) {
                    addSelectionIndicatingView(toRegion: canvasRegionView.regionView, for: selectedView)
                    return
                }
            }
        }
        assertionFailure("Somehow there was no selectionView added.")
    }

    private func addSelectionIndicatingView(toRegion regionView: UIView, for mediaContainingView: UIView) {

        // region view is where the interactiveView is. RegionView itself is in a canvasView. We save the image of the canvasView; so we have to add the indication view to the superview of the canvasView.
        guard let parentView = regionView.superview?.superview else {
            assertionFailure()
            return
        }

        addSelectionShowingView(to: parentView, forMediaContainingView: mediaContainingView)
    }

    private func addSelectionShowingView(to view: UIView) {

        // store the view's transform so that it can be reapplied after moving the view.
        let transformToReapply = view.transform

        // reset transform to allow proper directional navigation of object
        view.transform = CGAffineTransform.identity

        // in this case, the media and parent views are the same.
        addSelectionShowingView(to: view, forMediaContainingView: view)

        // return transform onto view in order to keep previous transformations on the view
        view.transform = transformToReapply
    }

    private func addSelectionShowingView(to parentView: UIView, forMediaContainingView mediaContainingView: UIView) {
        let selectionShowingView = SelectionShowingView(mediaType: mediaContainingView.mediaType)
        self.selectionShowingView = selectionShowingView

        if let player = mediaContainingView as? AVPlayerView {
            selectionShowingView.setVolumeState(to: player.videoPlayer.isMuted)
        }

        parentView.addSubview(selectionShowingView)
        selectionShowingView.edgeAnchors == parentView.edgeAnchors
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

    var tapGesture = UITapGestureRecognizer()
    private var panGesture = UIPanGestureRecognizer()
    private var pinchGesture = UIPinchGestureRecognizer()
    private var rotationGesture = UIRotationGestureRecognizer()


    public init(viewSelectionStyle: ViewSelectionStyle) {
        self.viewSelectionStyle = viewSelectionStyle
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

    var debounceTimer: Timer?
    func indicateViewWasModified() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(sendNotificationThatSelectedViewWasModified), userInfo: nil, repeats: false)
    }

    @objc private func sendNotificationThatSelectedViewWasModified() {
        // This may cause bugs but I don't think that it is likely. Because of the delay of the debounce timer, it is possible that the selectedView could be set to nil before this function is called. However, the selectedView only gets set to nil on taps, and so this seems unlikely. An assertionFailure has been added here just in case since, if this ever occurs, then it needs to be handled better.
        guard let selectedView = selectedView else {
            assertionFailure()
            return
        }
        selectedViewObservingDelegate?.viewWasModified?(view: selectedView)
    }
}

extension CanvasController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
