//
//  StoryImageContainer.swift
//  StoryTest
//
//  Created by Li Zhao on 6/21/18.
//  Copyright © 2018 LiZhao. All rights reserved.
//

import UIKit

public class MediaScalableObject {

    //subclassable view
    public var scalableView: UIView!

    //Current constraints
    var topConstraint: NSLayoutConstraint?
    var trailingConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?

    //Previous constraints
    var previousTopConstraingValue:CGFloat = 0.0
    var previousTrailingConstraintValue:CGFloat = 0.0
    var previousLeadingConstraintValue:CGFloat = 0.0
    var previousBottomConstraintValue:CGFloat = 0.0

    //edges' gestures
    var topGesture: UIPanGestureRecognizer!
    var bottomGesture: UIPanGestureRecognizer!
    var leftGesture: UIPanGestureRecognizer!
    var rightGesture: UIPanGestureRecognizer!
    var topLeftGesture: UIPanGestureRecognizer!
    var topRightGesture: UIPanGestureRecognizer!
    var bottomLeftGesture: UIPanGestureRecognizer!
    var bottomRightGesture: UIPanGestureRecognizer!

    //Direction lockers, if false, cannot squeeze scalable view in that direction
    var isHorizontalMoveable = false
    var isVerticalMoveable = false
    var isZoomable = false
    var isMoveable = false

    //Points of reference for superview
    var topPoint: CGPoint?
    var bottomPoint: CGPoint?

    public var isEditing: Bool = false {
        didSet {

            //show or hide scalable view's border when is editing value changes
            self.scalableView.layer.borderColor = UIColor.black.cgColor
            self.scalableView.layer.borderWidth = isEditing ? 1 : 0

            //enable or disable edge gestures when is editing value changes
            topGesture.isEnabled = isEditing
            bottomGesture.isEnabled = isEditing
            leftGesture.isEnabled = isEditing
            rightGesture.isEnabled = isEditing
            topLeftGesture.isEnabled = isEditing
            topRightGesture.isEnabled = isEditing
            bottomLeftGesture.isEnabled = isEditing
            bottomRightGesture.isEnabled = isEditing
        }
    }

    //Initialization
    public init(scalableView: UIView, testModel: Bool = false){
        self.scalableView = scalableView
        scalableView.isUserInteractionEnabled = true
        self.setupEdgesGestures(testModel: testModel)
    }

    //setup initial constraint
    func attachConstraintsToSuperview() {
        if scalableView.superview == nil {
            print("attach a view first")
            return
        }

        self.scalableView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = self.scalableView.pinToTopOfSuperviewWithConstraint()
        trailingConstraint = self.scalableView.pinToRightOfSuperviewWithConstraint()
        leadingConstraint = self.scalableView.pinToLeftOfSuperviewWithConstraint()
        bottomConstraint = self.scalableView.pinToBottomOfSuperviewWithConstraint()
    }

    func updatePreviousConstraintValue(){

        self.previousTrailingConstraintValue = self.trailingConstraint?.constant ?? 0.0
        self.previousLeadingConstraintValue = self.leadingConstraint?.constant ?? 0.0

        self.previousTopConstraingValue = self.topConstraint?.constant ?? 0.0
        self.previousBottomConstraintValue = self.bottomConstraint?.constant ?? 0.0
    }

    /*---------------------------------------
     views and gestures for edge touches
     ---------------------------------------*/
    func setupEdgesGestures(testModel: Bool) {

        var viewColor = UIColor.clear

        if testModel {
            viewColor = .yellow
        }

        //initail corner gestures
        self.topLeftGesture = UIPanGestureRecognizer(target: self, action: #selector(moveTopLeftEdge(_:)))
        self.bottomLeftGesture = UIPanGestureRecognizer(target: self, action: #selector(moveBottomLeftEdge(_:)))
        self.topRightGesture = UIPanGestureRecognizer(target: self, action: #selector(moveTopRightEdge(_:)))
        self.bottomRightGesture = UIPanGestureRecognizer(target: self, action: #selector(moveBottomRightEdge(_:)))


        //initail edge gestures
        self.topGesture = UIPanGestureRecognizer(target: self, action: #selector(moveTopEdge(_:)))
        self.bottomGesture = UIPanGestureRecognizer(target: self, action: #selector(moveBottomEdge(_:)))
        self.leftGesture = UIPanGestureRecognizer(target: self, action: #selector(moveLeftEdge(_:)))
        self.rightGesture = UIPanGestureRecognizer(target: self, action: #selector(moveRightEdge(_:)))

        //setup views one view's edges to hold gestures
        let topGestureView = UIView(frame: .zero)
        topGestureView.tag = 88
        self.scalableView.addSubview(topGestureView)
        topGestureView.translatesAutoresizingMaskIntoConstraints = false
        _ = topGestureView.pinToTopOfSuperviewWithConstraint(constant: -10)
        _ = topGestureView.pinToLeftOfSuperviewWithConstraint(constant: 10)
        _ = topGestureView.pinToRightOfSuperviewWithConstraint(constant: -10)
        _ = topGestureView.forceHeightConstraint(height: 20)
        topGestureView.backgroundColor = viewColor

        let leftGestureView = UIView(frame: .zero)
        leftGestureView.tag = 88
        self.scalableView.addSubview(leftGestureView)
        _ = leftGestureView.translatesAutoresizingMaskIntoConstraints = false
        _ = leftGestureView.pinToTopOfSuperviewWithConstraint(constant: 10)
        _ = leftGestureView.pinToLeftOfSuperviewWithConstraint(constant: -10)
        _ = leftGestureView.pinToBottomOfSuperviewWithConstraint(constant: -10)
        _ = leftGestureView.forceWidthConstraint(width: 20)
        leftGestureView.backgroundColor = viewColor

        let rightGestureView = UIView(frame: .zero)
        rightGestureView.tag = 88
        self.scalableView.addSubview(rightGestureView)
        _ = rightGestureView.translatesAutoresizingMaskIntoConstraints = false
        _ = rightGestureView.pinToTopOfSuperviewWithConstraint(constant: 10)
        _ = rightGestureView.pinToRightOfSuperviewWithConstraint(constant: 10)
        _ = rightGestureView.pinToBottomOfSuperviewWithConstraint(constant: -10)
        _ = rightGestureView.forceWidthConstraint(width: 20)
        rightGestureView.backgroundColor = viewColor

        let bottomGestureView = UIView(frame: .zero)
        bottomGestureView.tag = 88
        scalableView.addSubview(bottomGestureView)
        bottomGestureView.translatesAutoresizingMaskIntoConstraints = false
        _ = bottomGestureView.pinToBottomOfSuperviewWithConstraint(constant: 10)
        _ = bottomGestureView.pinToLeftOfSuperviewWithConstraint(constant: 10)
        _ = bottomGestureView.pinToRightOfSuperviewWithConstraint(constant: -10)
        _ = bottomGestureView.forceHeightConstraint(height: 20)
        bottomGestureView.backgroundColor = viewColor

        let topLeftCornerGestureView = UIView(frame: .zero)
        topLeftCornerGestureView.tag = 88
        self.scalableView.addSubview(topLeftCornerGestureView)
        _ = topLeftCornerGestureView.translatesAutoresizingMaskIntoConstraints = false
        _ = topLeftCornerGestureView.pinToTopOfSuperviewWithConstraint(constant: -10)
        _ = topLeftCornerGestureView.pinToLeftOfSuperviewWithConstraint(constant: -10)
        _ = topLeftCornerGestureView.forceWidthConstraint(width: 20)
        _ = topLeftCornerGestureView.forceHeightConstraint(height: 20)
        topLeftCornerGestureView.backgroundColor = viewColor

        let toprightCornerGestureView = UIView(frame: .zero)
        toprightCornerGestureView.tag = 88
        self.scalableView.addSubview(toprightCornerGestureView)
        _ = toprightCornerGestureView.translatesAutoresizingMaskIntoConstraints = false
        _ = toprightCornerGestureView.pinToTopOfSuperviewWithConstraint(constant: -10)
        _ = toprightCornerGestureView.pinToRightOfSuperviewWithConstraint(constant: 10)
        _ = toprightCornerGestureView.forceWidthConstraint(width: 20)
        _ = toprightCornerGestureView.forceHeightConstraint(height: 20)
        toprightCornerGestureView.backgroundColor = viewColor

        let bottomLeftCornerGestureView = UIView(frame: .zero)
        bottomLeftCornerGestureView.tag = 88
        self.scalableView.addSubview(bottomLeftCornerGestureView)
        _ = bottomLeftCornerGestureView.translatesAutoresizingMaskIntoConstraints = false
        _ = bottomLeftCornerGestureView.pinToBottomOfSuperviewWithConstraint(constant: 10)
        _ = bottomLeftCornerGestureView.pinToLeftOfSuperviewWithConstraint(constant: -10)
        _ = bottomLeftCornerGestureView.forceWidthConstraint(width: 20)
        _ = bottomLeftCornerGestureView.forceHeightConstraint(height: 20)
        bottomLeftCornerGestureView.backgroundColor = viewColor

        let bottomRightCornerGestureView = UIView(frame: .zero)
        bottomRightCornerGestureView.tag = 88
        self.scalableView.addSubview(bottomRightCornerGestureView)
        _ = bottomRightCornerGestureView.translatesAutoresizingMaskIntoConstraints = false
        _ = bottomRightCornerGestureView.pinToBottomOfSuperviewWithConstraint(constant: 10)
        _ = bottomRightCornerGestureView.pinToRightOfSuperviewWithConstraint(constant: 10)
        _ = bottomRightCornerGestureView.forceWidthConstraint(width: 20)
        _ = bottomRightCornerGestureView.forceHeightConstraint(height: 20)
        bottomRightCornerGestureView.backgroundColor = viewColor

        topLeftCornerGestureView.addGestureRecognizer(topLeftGesture)
        toprightCornerGestureView.addGestureRecognizer(topRightGesture)
        bottomLeftCornerGestureView.addGestureRecognizer(bottomLeftGesture)
        bottomRightCornerGestureView.addGestureRecognizer(bottomRightGesture)

        topGestureView.addGestureRecognizer(topGesture)
        bottomGestureView.addGestureRecognizer(bottomGesture)
        leftGestureView.addGestureRecognizer(leftGesture)
        rightGestureView.addGestureRecognizer(rightGesture)

    }

    /*-----------------------------------
     Pan gesture functions for squeeze scalable view
     ------------------------------------*/

    @objc fileprivate func moveTopLeftEdge(_ sender: UIPanGestureRecognizer) {

        //check if this direction is locked
        guard isHorizontalMoveable && isVerticalMoveable else {
            return
        }
        print("moving top left edge")

        let translation = sender.translation(in: scalableView)

        if sender.state == .began {

        } else if sender.state == .changed {
            //moving top left corner
            self.topConstraint?.constant = self.previousTopConstraingValue + translation.y
            self.leadingConstraint?.constant = self.previousLeadingConstraintValue + translation.x
        } else if sender.state == .ended {

            //update previous constraint value
            updatePreviousConstraintValue()
        }
    }

    @objc fileprivate func moveBottomLeftEdge(_ sender: UIPanGestureRecognizer) {

        //check if this direction is locked
        guard isHorizontalMoveable && isVerticalMoveable else {
            return
        }

        let translation = sender.translation(in: scalableView)

        if sender.state == .began {

        } else if sender.state == .changed {

            //moving bottom left corner
            self.bottomConstraint?.constant = self.previousBottomConstraintValue + translation.y
            self.leadingConstraint?.constant = self.previousLeadingConstraintValue + translation.x

        } else if sender.state == .ended {

            //update previous constraint value
            updatePreviousConstraintValue()
        }

    }

    @objc fileprivate func moveTopRightEdge(_ sender: UIPanGestureRecognizer) {

        //check if this direction is locked
        guard isHorizontalMoveable && isVerticalMoveable else {
            return
        }

        let translation = sender.translation(in: scalableView)

        if sender.state == .began {

        } else if sender.state == .changed {

            //moving top right corner
            self.topConstraint?.constant = self.previousTopConstraingValue + translation.y
            self.trailingConstraint?.constant = self.previousTrailingConstraintValue + translation.x
        } else if sender.state == .ended {

            //update previous constraint value
            updatePreviousConstraintValue()
        }
    }

    @objc fileprivate func moveBottomRightEdge(_ sender: UIPanGestureRecognizer) {

        //check if this direction is locked
        guard isHorizontalMoveable && isVerticalMoveable else {
            return
        }

        let translation = sender.translation(in: scalableView)

        if sender.state == .began {

        } else if sender.state == .changed {

            //moving botton right corner
            self.bottomConstraint?.constant = self.previousBottomConstraintValue + translation.y
            self.trailingConstraint?.constant = self.previousTrailingConstraintValue + translation.x
        } else if sender.state == .ended {

            //update previous constraint value
            updatePreviousConstraintValue()
        }
    }

    @objc fileprivate func moveTopEdge(_ sender: UIPanGestureRecognizer) {

        //check if this direction is locked
        guard isVerticalMoveable else {
            return
        }

        let translation = sender.translation(in: scalableView)

        if sender.state == .began {

        } else if sender.state == .changed {

            //moving top edge
            self.topConstraint?.constant = self.previousTopConstraingValue + translation.y
        } else if sender.state == .ended {
            //update previous constraint value
            updatePreviousConstraintValue()
        }
    }

    @objc fileprivate func moveBottomEdge(_ sender: UIPanGestureRecognizer) {

        //check if this direction is locked
        guard isVerticalMoveable else {
            return
        }

        let translation = sender.translation(in: scalableView)

        if sender.state == .began {

        } else if sender.state == .changed {

            //moving bottom edge
            self.bottomConstraint?.constant = self.previousBottomConstraintValue + translation.y
        } else if sender.state == .ended {

            //update previous constraint value
            updatePreviousConstraintValue()
        }
    }

    @objc fileprivate func moveLeftEdge(_ sender: UIPanGestureRecognizer) {

        //check if this direction is locked
        guard isHorizontalMoveable else {
            return
        }

        let translation = sender.translation(in: scalableView)

        if sender.state == .began {

        } else if sender.state == .changed {

            //moving left edge
            self.leadingConstraint?.constant = self.previousLeadingConstraintValue + translation.x
        } else if sender.state == .ended {

            //update previous constraint value
            updatePreviousConstraintValue()
        }
    }

    @objc fileprivate func moveRightEdge(_ sender: UIPanGestureRecognizer) {

        //check if this direction is locked
        guard isHorizontalMoveable else {
            return
        }

        print("moving right edge")
        let translation = sender.translation(in: scalableView)

        if sender.state == .began {

        } else if sender.state == .changed {

            //moving right edge
            self.trailingConstraint?.constant = self.previousTrailingConstraintValue + translation.x
        } else if sender.state == .ended {

            //update previous constraint value
            updatePreviousConstraintValue()
        }
    }
}

@objc protocol StoryEditingDelegat: class {
    func enterEditingModel(_ isEditing: Bool, viewTag: Int)
    @objc optional func presentVC(_ vc: UIViewController)
    func updatePosition(top: CGPoint, bottom: CGPoint, viewTag: Int, cellIndex: Int)
}

public protocol CanvasDelegate: class {
    func importMedia()
    func tapAction(_ sender: UITapGestureRecognizer)
}

public class CanvasView: UIView {

    public var currentlyEditingMedia: MediaScalableObject?
    public var scalableMediaArray: [MediaScalableObject] = []
    public var isEditing: Bool = false

    var panGesture: UIPanGestureRecognizer!
    var pinchGesture: UIPinchGestureRecognizer!
    var addImageButton: UIButton!
    public weak var canvasDelegate: CanvasDelegate?

    var horizontalCenterConstant: CGFloat?
    var verticalCenterConstant: CGFloat?

    var verticalCentered: Bool = false
    var horizontalCentered: Bool = false

    //mid line views
    var topMidView: UIView?
    var bottomMidView: UIView?
    var leftMidView: UIView?
    var rightMidView: UIView?

    public override func awakeFromNib() {
        super.awakeFromNib()
        setupTouchGestures()
        setupCenterViews(color: .black, lengthPercent: 0.5, indicatorWidth: 1)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupTouchGestures()
        setupCenterViews(color: .black, lengthPercent: 0.5, indicatorWidth: 1)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTouchGestures()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
    }

    /*--------------------------------------
     Setup lines that indicate view is centered when moving
     only show those lines when view is centered, so inital alpha is 0
     ----------------------------------------*/

    func setupCenterViews(color: UIColor, lengthPercent: CGFloat, indicatorWidth: CGFloat) {

        guard topMidView == nil else {
            return
        }

        topMidView = UIView(frame: .zero)
        topMidView?.backgroundColor = color
        topMidView?.alpha = 0

        bottomMidView = UIView(frame: .zero)
        bottomMidView?.backgroundColor = color
        bottomMidView?.alpha = 0

        leftMidView = UIView(frame: .zero)
        leftMidView?.backgroundColor = color
        leftMidView?.alpha = 0

        rightMidView = UIView(frame: .zero)
        rightMidView?.backgroundColor = color
        rightMidView?.alpha = 0

        self.addSubview(topMidView!)
        self.addSubview(bottomMidView!)
        self.addSubview(leftMidView!)
        self.addSubview(rightMidView!)

        topMidView?.translatesAutoresizingMaskIntoConstraints = false
        bottomMidView?.translatesAutoresizingMaskIntoConstraints = false
        leftMidView?.translatesAutoresizingMaskIntoConstraints = false
        rightMidView?.translatesAutoresizingMaskIntoConstraints = false

        topMidView?.pinToTopOfSuperview()
        topMidView?.addConstraintToCenterHorizontallyInSuperview()
        topMidView?.forceWidthConstraint(width: indicatorWidth)
        topMidView?.forceHeightConstraint(height: self.frame.height * lengthPercent)

        bottomMidView?.pinToBottomOfSuperview()
        bottomMidView?.addConstraintToCenterHorizontallyInSuperview()
        bottomMidView?.forceWidthConstraint(width: indicatorWidth)
        bottomMidView?.forceHeightConstraint(height: self.frame.height * lengthPercent)

        leftMidView?.pinToLeftOfSuperview()
        leftMidView?.addConstraintToCenterVerticallyInSuperview()
        leftMidView?.forceWidthConstraint(width: self.frame.width * lengthPercent)
        leftMidView?.forceHeightConstraint(height: indicatorWidth)

        rightMidView?.pinToRightOfSuperview()
        rightMidView?.addConstraintToCenterVerticallyInSuperview()
        rightMidView?.forceWidthConstraint(width: self.frame.width * lengthPercent)
        rightMidView?.forceHeightConstraint(height: indicatorWidth)

    }

    fileprivate func showOrHideMidIndicatorView(_ show: Bool) {

        topMidView?.alpha = show ? 1 : 0
        bottomMidView?.alpha = show ? 1 : 0
        leftMidView?.alpha = show ? 1 : 0
        rightMidView?.alpha = show ? 1 : 0

        if let topMidView = topMidView {
            self.bringSubview(toFront: topMidView)

        }

        if let bottomMidView = bottomMidView {
            self.bringSubview(toFront: bottomMidView)

        }

        if let leftMidView = leftMidView {
            self.bringSubview(toFront: leftMidView)

        }

        if let rightMidView = rightMidView {
            self.bringSubview(toFront: rightMidView)

        }
    }

    //use this to change editing media's constraints
    public func updateMediaScalableObjectContstraints(top: CGFloat? = nil, bottom: CGFloat? = nil, leading: CGFloat? = nil, trailing: CGFloat? = nil) {
        if let top = top {
            currentlyEditingMedia?.topConstraint?.constant = top
            currentlyEditingMedia?.previousTopConstraingValue = top
        }

        if let bottom = bottom {
            currentlyEditingMedia?.bottomConstraint?.constant = bottom
            currentlyEditingMedia?.previousBottomConstraintValue = bottom
        }

        if let leading = leading {
            currentlyEditingMedia?.leadingConstraint?.constant = leading
            currentlyEditingMedia?.previousTrailingConstraintValue = leading
        }

        if let trailing = trailing {
            currentlyEditingMedia?.trailingConstraint?.constant = trailing
            currentlyEditingMedia?.previousTrailingConstraintValue = trailing
        }
    }

    func setupTouchGestures(){
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        panGesture.delegate = self

        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(_:)))
        pinchGesture.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(panGesture)
        self.addGestureRecognizer(pinchGesture)

        panGesture.isEnabled = isEditing
        pinchGesture.isEnabled = isEditing
    }

    //add new media object into canvas view
    public func addMediaObject(mediaObject: MediaScalableObject,
                               isHorizontalPinchEnabled: Bool,
                               isVerticalPichEnabled: Bool,
                               isZoomEnabled: Bool,
                               isMoveable: Bool,
                               isEditing: Bool = false) {

        self.addSubview(mediaObject.scalableView)
        mediaObject.attachConstraintsToSuperview()
        scalableMediaArray.append(mediaObject)

        mediaObject.isEditing = isEditing

        if isEditing {
            //clear all current editing object
            removeEditing()

            //set the new media object to edting model
            currentlyEditingMedia = mediaObject
            mediaObject.isEditing = isEditing

            panGesture.isEnabled = isEditing
            pinchGesture.isEnabled = isEditing
            self.layer.borderWidth = isEditing ? 1 : 0
            self.layer.borderColor = UIColor.black.cgColor
        }

        mediaObject.isHorizontalMoveable = isHorizontalPinchEnabled
        mediaObject.isVerticalMoveable = isVerticalPichEnabled
        mediaObject.isMoveable = isMoveable
        mediaObject.isZoomable = isZoomEnabled
    }

    //use this to change media object constraints
    public func setupMediaObjectConstraint(_ media: MediaScalableObject, top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat) {

        media.topConstraint?.constant = top
        media.leadingConstraint?.constant = leading
        media.bottomConstraint?.constant = bottom
        media.trailingConstraint?.constant = trailing

        media.previousTopConstraingValue = media.topConstraint?.constant ?? 0
        media.previousTrailingConstraintValue = media.trailingConstraint?.constant ?? 0
        media.previousLeadingConstraintValue = media.leadingConstraint?.constant ?? 0
        media.previousBottomConstraintValue = media.bottomConstraint?.constant ?? 0

    }

    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        if scalableMediaArray.isEmpty {
            // TODO: add new media
            canvasDelegate?.importMedia()
        } else if scalableMediaArray.count == 1 {

            isEditing = !isEditing

            //Remove currently editing if is not editing

            if (isEditing){
                currentlyEditingMedia = scalableMediaArray.first
                currentlyEditingMedia?.isEditing = isEditing

            }else{
                currentlyEditingMedia?.isEditing = isEditing
                currentlyEditingMedia = nil
            }

            panGesture.isEnabled = isEditing
            pinchGesture.isEnabled = isEditing
            self.layer.borderWidth = isEditing ? 1 : 0
            self.layer.borderColor = UIColor.black.cgColor
        } else if scalableMediaArray.count > 1 {

            if isEditing {
                removeEditing()
            } else {
                let index = scalableMediaArray.index { (mediaScalableObject) -> Bool in

                    let view = sender.view
                    let location = sender.location(in: view)
                    let subView = view?.hitTest(location, with: nil)

                    if subView == mediaScalableObject.scalableView || subView?.superview == mediaScalableObject.scalableView {
                        return true
                    }
                    return false
                }

                if let scalableIndex = index {
                    isEditing = !isEditing

                    if (isEditing){
                        currentlyEditingMedia = scalableMediaArray[scalableIndex]
                        currentlyEditingMedia?.isEditing = isEditing
                    }else{
                        currentlyEditingMedia?.isEditing = isEditing
                        currentlyEditingMedia = nil
                    }

                    panGesture.isEnabled = isEditing
                    pinchGesture.isEnabled = isEditing
                    self.layer.borderWidth = isEditing ? 1 : 0
                    self.layer.borderColor = UIColor.black.cgColor
                }
            }
        }
        canvasDelegate?.tapAction(sender)
    }

    func endTouch(_ editingMedia: MediaScalableObject) {
//        if let top = editingMedia.topConstraint?.constant,
//            let leading = editingMedia.leadingConstraint?.constant,
//            let bottom = editingMedia.bottomConstraint?.constant,
//            let trailing = editingMedia.trailingConstraint?.constant {
//            let superView = self.superview
//            let top = CGPoint(x: leading, y: top)
//            let bottom = CGPoint(x: trailing, y: bottom)

            //TODO: Send full media scalable object instead of each

            //            delegate?.updatePosition(top: top, bottom: bottom, viewTag: superView.tag, cellIndex: itemIndex)
            //            delegateFromEditor?.updatePosition(top: top, bottom: bottom, viewTag: superView.tag, cellIndex: itemIndex)
//        }
    }

    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {

        guard currentlyEditingMedia?.isMoveable ?? false,
            let editingMedia = self.currentlyEditingMedia else {
                return

        }

        if (sender.state == .ended){

            //Update position after moved
            endTouch(editingMedia)
            pinchGesture.isEnabled = true

            editingMedia.updatePreviousConstraintValue()

        }else if (sender.state == .changed) {

            let translation = sender.translation(in: self)

            //get leading constant and top constant to calculate delta values
            let leadingConstant = editingMedia.previousLeadingConstraintValue + translation.x
            let topConstant = editingMedia.previousTopConstraingValue + translation.y

            //difference between center constant and current constant
            let verticalDelta = topConstant -  (verticalCenterConstant ?? 0)
            let horizontalDelta = leadingConstant - (horizontalCenterConstant ?? 0)

            let velocity = sender.velocity(in: self)

            // if scalable view's leading constant inside middle area range and velocity great than 10, center the view horizontally
            if (velocity.x > 150 || velocity.x < -150) && abs(horizontalDelta) < 10 {

                // keep the view centred untile detail value goes out middle area range
                if !horizontalCentered {

                    editingMedia.leadingConstraint!.constant  = horizontalCenterConstant ?? 0
                    editingMedia.trailingConstraint!.constant = -(horizontalCenterConstant ?? 0)
                    showOrHideMidIndicatorView(true)
                    horizontalCentered = true
                }

            } else if abs(horizontalDelta) > 10 {
                horizontalCentered = false

                //when both vertical and horizontal are not centered, hide middle line views
                showOrHideMidIndicatorView(verticalCentered || horizontalCentered)
            }

            // if scalable view's center inside middle area and velocity great than 10, center the view vertically
            if (velocity.y > 150 || velocity.y < -150) && abs(verticalDelta) < 10 {

                //keep the view centred untile detail value goes out middle area range
                if !verticalCentered {

                    editingMedia.topConstraint?.constant = verticalCenterConstant ?? 0
                    editingMedia.bottomConstraint?.constant = -(verticalCenterConstant ?? 0)
                    showOrHideMidIndicatorView(true)
                    verticalCentered = true
                }
            } else if abs(verticalDelta) > 10 {

                verticalCentered = false
                //when both vertical and horizontal are not centered, hide middle line views
                showOrHideMidIndicatorView(verticalCentered || horizontalCentered)
            }

            //if the view is centered, we don't need to update it's constraint untile it goes out of the middle range
            if !horizontalCentered {
                editingMedia.trailingConstraint!.constant = editingMedia.previousTrailingConstraintValue  + translation.x
                editingMedia.leadingConstraint!.constant = editingMedia.previousLeadingConstraintValue + translation.x
            }

            if !verticalCentered {
                editingMedia.topConstraint?.constant = editingMedia.previousTopConstraingValue + translation.y
                editingMedia.bottomConstraint?.constant = editingMedia.previousBottomConstraintValue + translation.y
            }

        } else if (sender.state == .began) {
            pinchGesture.isEnabled = false

            // automatic cetner currentEditing media's view when it reached middle area (10 - middle point - 10)
            if let media = currentlyEditingMedia {
                print("previousLeadingConstraintValue===============", editingMedia.previousLeadingConstraintValue)
                print("previousTrailingConstraintValue=============", editingMedia.previousTrailingConstraintValue)

                // get leading and trailing constants which makes scalable view center horizontally
                // trailing value is negative
                horizontalCenterConstant = (media.previousLeadingConstraintValue - media.previousTrailingConstraintValue) / 2

                // get top and bottom constants which makes scalable view center vertically
                // bottom value is negative
                verticalCenterConstant = (media.previousTopConstraingValue - media.previousBottomConstraintValue) / 2
            }
        }
    }

    @IBAction func pinchGesture(_ sender: UIPinchGestureRecognizer) {

        guard let editingMedia = self.currentlyEditingMedia, (currentlyEditingMedia?.isZoomable ?? false) else { return }

        if (sender.state == .ended){

            //Update position after move ended
            endTouch(editingMedia)
            panGesture.isEnabled = true
            editingMedia.updatePreviousConstraintValue()


        }else if (sender.state == .changed){

            let changeScale = 1 - sender.scale

            //if vertical pinch is false, don't update top and bottom constraints

            let heightOfImage = self.frame.size.height
            let deltaHeightChange = heightOfImage * changeScale

            editingMedia.topConstraint!.constant = editingMedia.previousTopConstraingValue + deltaHeightChange/2
            editingMedia.bottomConstraint!.constant = editingMedia.previousBottomConstraintValue - deltaHeightChange/2

            //if horizontal pinch is false, don't update top and bottom constraints
            let widthOfImage = self.frame.size.width
            let deltaWidthChange = widthOfImage * changeScale

            editingMedia.leadingConstraint!.constant = editingMedia.previousLeadingConstraintValue + deltaWidthChange/2
            editingMedia.trailingConstraint!.constant = editingMedia.previousTrailingConstraintValue - deltaWidthChange/2

        } else if (sender.state == .began) {
            panGesture.isEnabled = false
        }
    }

    //Stop editing media inside this canvas, remove border and save updated constraints
    public func removeEditing() {
        if isEditing {
            self.layer.borderWidth = 0
            self.currentlyEditingMedia?.updatePreviousConstraintValue()
            self.currentlyEditingMedia?.isEditing = false
            self.currentlyEditingMedia = nil
            self.isEditing = false
        }
    }
}

extension CanvasView: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            //88 is the tag value for all edge views which hold pan gestures
            if let view = touch.view, view.tag == 88 {
                return false
            }
        }
        return true
    }
}
