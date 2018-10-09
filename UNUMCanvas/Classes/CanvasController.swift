import UIKit

open class CanvasController: UIViewController {
    
    let absoluteVelocityEnablingLocking: CGFloat = 100
    let absoluteDistanceEnablingLocking: CGFloat = 20
    
    public var movableViews: [UIView] = []
    public var canvasViews: [UIView] = []
    
    var tapGesture = UITapGestureRecognizer()
    var panGesture = UIPanGestureRecognizer()
    var pinchGesture = UIPinchGestureRecognizer()
    var rotationGesture = UIRotationGestureRecognizer()
    
    public var selectedView: UIView? {
        didSet {
            movableViews.forEach({ $0.alpha = 1.0 })
            
            if let selectedView = selectedView {
                selectedView.alpha = 0.5 // Setup view as selected
            }
        }
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnViewController(_:)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panOnViewController(_:)))
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchOnViewController(_:)))
        rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateView(_:)))
        
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(pinchGesture)
        view.addGestureRecognizer(rotationGesture)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGesture.delegate = self
        panGesture.delegate = self
        pinchGesture.delegate = self
        rotationGesture.delegate = self
    }
    
    // MARK: - Gesture Handling
    
    @IBAction func tapOnViewController(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }
        
        // TODO: plf - will want this to select "highest-layered" view once integrated.
        // If click is within movableViews, set to first one.
        for view in movableViews {
            let viewClicked = view.point(inside: sender.location(in: view), with: nil)
            if viewClicked {
                if let unwrappedView = selectedView, unwrappedView == view {
                    selectedView = nil
                    return
                }
                else {
                    selectedView = view
                    return
                }
            }
        }
        
        // If click was not within any movableView, then set to nil
        selectedView = nil
        return
    }
    
    private func hideAllAxisIndicators() {
        canvasViews.forEach({
            $0.hideCenterXIndication()
            $0.hideCenterYIndication()
        })
    }
    
    @IBAction func panOnViewController(_ sender: UIPanGestureRecognizer) {
        if sender.state == .ended {
            hideAllAxisIndicators()
            return
        }
        
        guard let selectedView = selectedView else {
            return
        }
        
        assert(canvasViews.count > 0)
        
        for canvasView in canvasViews {
            // store the view's transform so that it can be reapplied after moving the view.
            let transformToReapply = selectedView.transform
            
            // reset transform to allow proper directional navigation of object
            selectedView.transform = CGAffineTransform.identity
            
            let translation = sender.translation(in: canvasView)
            
            var updatedOrigin = CGPoint(
                x: selectedView.frame.origin.x + translation.x,
                y: selectedView.frame.origin.y + translation.y
            )
            
            let centerX = canvasView.frame.origin.x + canvasView.frame.width / 2
            if shouldLock(selectedView, toCenterX: centerX, usingSender: sender) {
                updatedOrigin = CGPoint(x: centerX - selectedView.frame.width / 2, y: updatedOrigin.y)
                canvasView.showCenterXIndication()
            }
            else {
                canvasView.hideCenterXIndication()
            }
            
            let centerY = canvasView.frame.origin.y + canvasView.frame.height / 2
            if shouldLock(selectedView, toCenterY: centerY, usingSender: sender) {
                updatedOrigin = CGPoint(x: updatedOrigin.x, y: centerY - selectedView.frame.height / 2)
                canvasView.showCenterYIndication()
            }
            else {
                canvasView.hideCenterYIndication()
            }
            
            updatedOrigin = transformToBeOnScreen(updatedOrigin, for: selectedView)
            selectedView.frame.origin = updatedOrigin
            
            sender.setTranslation(.zero, in: canvasView)
            
            // return transform onto view in order to keep previous transformations on the view
            selectedView.transform = transformToReapply
        }
    }
    
    @IBAction func pinchOnViewController(_ sender: UIPinchGestureRecognizer) {
        guard let selectedView = selectedView else {
            return
        }
        
        selectedView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale).concatenating(selectedView.transform)
        sender.scale = 1.0
    }
    
    @IBAction func rotateView(_ sender: UIRotationGestureRecognizer) {
        guard let selectedView = selectedView else {
            return
        }
        let t = CGAffineTransform(rotationAngle: sender.rotation).concatenating(selectedView.transform)
        
        let rotation = CGFloat(atan2(Double(t.b), Double(t.a)))
        
        let degree90: CGFloat = .pi / 2
        let degree180: CGFloat = .pi
        let degree270: CGFloat = (.pi * -1) / 2
        
        let near0 = abs(rotation) > -0.1 && abs(rotation) < 0.1
        let near90 = rotation > degree90 - 0.1 && rotation < degree90 + 0.1
        let near180 = abs(rotation) > degree180 - 0.1
        let near270 = rotation > degree270 - 0.1 && rotation < degree270 + 0.1
        
//        print("\(sender.velocity)")
        
        if abs(sender.velocity) < 0.2 {
            if near0 {
                selectedView.transform = CGAffineTransform(rotationAngle: -1 * rotation).concatenating(selectedView.transform)
            }
            else if near90 {
                selectedView.transform = CGAffineTransform(rotationAngle: degree90 - rotation).concatenating(selectedView.transform)
            }
            else if near180 {
                selectedView.transform = CGAffineTransform(rotationAngle: degree180 - rotation).concatenating(selectedView.transform)
            }
            else if near270 {
                selectedView.transform = CGAffineTransform(rotationAngle: degree270 - rotation).concatenating(selectedView.transform)
            }
            else {
                selectedView.transform = t
            }
        }
        else {
            selectedView.transform = t
        }
        
        sender.rotation = 0
    }
}

extension CanvasController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension CanvasController {
    
    private func isWithinVelocityRangeToEnableLocking(velocity: CGFloat) -> Bool {
        return abs(velocity) < absoluteVelocityEnablingLocking
    }
    
    private func isWithinDistanceRangeToEnableLocking(distance: CGFloat) -> Bool {
        return abs(distance) < absoluteDistanceEnablingLocking
    }
    
    // X Axis
    private func velocityIsWithinRangeToEnableLockingOnXAxis(sender: UIPanGestureRecognizer) -> Bool {
        let velocityX = sender.velocity(in: view).x
        return isWithinVelocityRangeToEnableLocking(velocity: velocityX)
    }
    
    private func saidView(_ view: UIView, isWithinXAxisLockingEnablingDistanceRangeOf centerX: CGFloat) -> Bool {
        let distance = view.center.x - centerX
        return isWithinDistanceRangeToEnableLocking(distance: distance)
    }
    
    private func shouldLock(_ selectedView: UIView, toCenterX centerX: CGFloat, usingSender sender: UIPanGestureRecognizer) -> Bool {
        return
            velocityIsWithinRangeToEnableLockingOnXAxis(sender: sender)
                && saidView(selectedView, isWithinXAxisLockingEnablingDistanceRangeOf: centerX)
    }
    
    // Y Axis
    private func velocityIsWithinRangeToEnableLockingOnYAxis(sender: UIPanGestureRecognizer) -> Bool {
        let velocityY = sender.velocity(in: view).y
        return isWithinVelocityRangeToEnableLocking(velocity: velocityY)
    }
    
    private func saidView(_ view: UIView, isWithinYAxisLockingEnablingDistanceRangeOf centerY: CGFloat) -> Bool {
        let distance = view.center.y - centerY
        return isWithinDistanceRangeToEnableLocking(distance: distance)
    }
    
    private func shouldLock(_ selectedView: UIView, toCenterY centerY: CGFloat, usingSender sender: UIPanGestureRecognizer) -> Bool {
        return
            velocityIsWithinRangeToEnableLockingOnYAxis(sender: sender)
                && saidView(selectedView, isWithinYAxisLockingEnablingDistanceRangeOf: centerY)
    }
}

extension CanvasController {
    
    private func transformToBeOnScreen(_ origin: CGPoint, for view: UIView) -> CGPoint {
        let borderControlAmount: CGFloat = 2
        
        let minX = borderControlAmount - view.frame.width
        let minY = borderControlAmount - view.frame.height
        let maxX = self.view.frame.maxX - borderControlAmount
        let maxY = self.view.frame.maxY - borderControlAmount
        
        var legitimateX: CGFloat
        if origin.x < minX {
            legitimateX = minX
        }
        else if origin.x > maxX {
            legitimateX = maxX
        }
        else {
            legitimateX = origin.x
        }
        
        var legitimateY: CGFloat
        if origin.y < minY {
            legitimateY = minY
        }
        else if origin.y > maxY {
            legitimateY = maxY
        }
        else {
            legitimateY = origin.y
        }
        
        return CGPoint(x: legitimateX, y: legitimateY)
    }
}