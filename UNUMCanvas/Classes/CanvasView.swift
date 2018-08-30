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

    //Points of reference for superview
    var topPoint: CGPoint?
    var bottomPoint: CGPoint?

    //For changing view border style
    var isEditing: Bool = false {
        didSet{
            scalableView.layer.borderWidth = isEditing ? 1 : 0
            scalableView.layer.borderColor = UIColor.black.cgColor
        }
    }

    //Initialization
    public init(scalableView: UIView){
        self.scalableView = scalableView
        scalableView.isUserInteractionEnabled = true

        

    }

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

        //TODO: Check for for unwrapping

        self.previousTrailingConstraintValue = self.trailingConstraint?.constant ?? 0.0
        self.previousLeadingConstraintValue = self.leadingConstraint?.constant ?? 0.0

        self.previousTopConstraingValue = self.topConstraint?.constant ?? 0.0
        self.previousBottomConstraintValue = self.bottomConstraint?.constant ?? 0.0
    }
}

@objc protocol StoryEditingDelegat: class {
    func enterEditingModel(_ isEditing: Bool, viewTag: Int)
    @objc optional func presentVC(_ vc: UIViewController)
    func updatePosition(top: CGPoint, bottom: CGPoint, viewTag: Int, cellIndex: Int)
    func addImage(_ image: UIImage, viewTag: Int, cellIndex: Int)
}

protocol CanvasDelegate: class {
    func importMedia()
}

public class CanvasView: UIView {

    var currentlyEditingMedia: MediaScalableObject?
    var scalableMediaArray: [MediaScalableObject] = []
    var panGesture: UIPanGestureRecognizer!
    var pinchGesture: UIPinchGestureRecognizer!
    var addImageButton: UIButton!
    weak var canvasDelegate: CanvasDelegate?

    var horizontalCenterConstant: CGFloat?
    var verticalCenterConstant: CGFloat?

    var verticalCentered: Bool = false
    var horizontalCentered: Bool = false


    fileprivate var isEditing: Bool = false

//    weak var delegate: StoryEditingDelegat?
//    weak var delegateFromEditor: StoryEditingDelegat?

//    public init() {
//        super.init()
//        self.setupTouchGestures()
//    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        setupTouchGestures()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)


    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
    }

    public func setupCenterViews(color: UIColor, lengthPercent: CGFloat, indicatorWidth: CGFloat) {
        let topMidView = UIView(frame: .zero)
        topMidView.backgroundColor = color
        let bottomMidView = UIView(frame: .zero)
        bottomMidView.backgroundColor = color
        let leftMidView = UIView(frame: .zero)
        leftMidView.backgroundColor = color
        let rightMidView = UIView(frame: .zero)
        rightMidView.backgroundColor = color

        self.addSubview(topMidView)
        self.addSubview(bottomMidView)
        self.addSubview(leftMidView)
        self.addSubview(rightMidView)

        topMidView.translatesAutoresizingMaskIntoConstraints = false
        bottomMidView.translatesAutoresizingMaskIntoConstraints = false
        leftMidView.translatesAutoresizingMaskIntoConstraints = false
        rightMidView.translatesAutoresizingMaskIntoConstraints = false

        topMidView.pinToTopOfSuperview()
        topMidView.addConstraintToCenterHorizontallyInSuperview()
        topMidView.forceWidthConstraint(width: indicatorWidth)
        topMidView.forceHeightConstraint(height: self.frame.height * lengthPercent)

        bottomMidView.pinToBottomOfSuperview()
        bottomMidView.addConstraintToCenterHorizontallyInSuperview()
        bottomMidView.forceWidthConstraint(width: indicatorWidth)
        bottomMidView.forceHeightConstraint(height: self.frame.height * lengthPercent)

        leftMidView.pinToLeftOfSuperview()
        leftMidView.addConstraintToCenterVerticallyInSuperview()
        leftMidView.forceWidthConstraint(width: self.frame.width * lengthPercent)
        leftMidView.forceHeightConstraint(height: indicatorWidth)

        rightMidView.pinToRightOfSuperview()
        rightMidView.addConstraintToCenterVerticallyInSuperview()
        rightMidView.forceWidthConstraint(width: self.frame.width * lengthPercent)
        rightMidView.forceHeightConstraint(height: indicatorWidth)

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

    public func addMediaObject(mediaObject: MediaScalableObject) {
        self.addSubview(mediaObject.scalableView)
        mediaObject.attachConstraintsToSuperview()
        scalableMediaArray.append(mediaObject)
    }

    func setupView() {
        if scalableMediaArray.isEmpty {
            //TODO: setup add image button
        } else {
            // TODO: setup scalable view
        }
        setupInitialconstraint()
    }

    fileprivate func setupInitialconstraint() {

        for media in scalableMediaArray {
            guard let top = media.topPoint,
                let bottom = media.bottomPoint
                else { return }

            media.topConstraint?.constant = top.y
            media.leadingConstraint?.constant = top.x
            media.bottomConstraint?.constant = bottom.y
            media.trailingConstraint?.constant = bottom.x

            media.previousTopConstraingValue = media.topConstraint?.constant ?? 0
            media.previousTrailingConstraintValue = media.trailingConstraint?.constant ?? 0
            media.previousLeadingConstraintValue = media.leadingConstraint?.constant ?? 0
            media.previousBottomConstraintValue = media.bottomConstraint?.constant ?? 0
        }

    }

//    @IBAction func selectImagesFromCameraRoll() {
//
//        let secondaryVC = SecondaryImportViewController(nibName: "SecondaryRootViewController", bundle: nil)
//        secondaryVC.importDelegate = self
//        secondaryVC.allowsInternalSources = false
//        secondaryVC.maxNumberOfSelections = 1
//        let secondaryNavigation = UINavigationController(rootViewController: secondaryVC)
//
//        delegateFromEditor?.presentVC?(secondaryNavigation)
//    }

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
                currentlyEditingMedia = nil
            }


            panGesture.isEnabled = isEditing
            pinchGesture.isEnabled = isEditing
            self.layer.borderWidth = isEditing ? 1 : 0
            self.layer.borderColor = UIColor.black.cgColor
        } else if scalableMediaArray.count > 1 {
            //TODO: highlight selected image and border
            let index = scalableMediaArray.index { (mediaScalableObject) -> Bool in

                let view = sender.view
                let location = sender.location(in: view)
                let subView = view?.hitTest(location, with: nil)

                if subView == mediaScalableObject.scalableView {
                    return true
                }
                return false
            }

            if let scalableIndex = index {
                isEditing = !isEditing

                currentlyEditingMedia?.isEditing = isEditing

                if (isEditing){
                    currentlyEditingMedia = scalableMediaArray[scalableIndex]
                }else{
                    currentlyEditingMedia = nil
                }

                panGesture.isEnabled = isEditing
                pinchGesture.isEnabled = isEditing
                self.layer.borderWidth = isEditing ? 1 : 0
                self.layer.borderColor = UIColor.black.cgColor
            }
        }
    }

//    fileprivate func editingElement() {
//        isEditing = !isEditing
//        panGesture.isEnabled = isEditing
//        pinchGesture.isEnabled = isEditing
//        delegate?.enterEditingModel(isEditing, viewTag: self.superview!.tag)
//        delegateFromEditor?.enterEditingModel(isEditing, viewTag: self.tag)
//        self.layer.borderWidth = isEditing ? 1 : 0
//        self.layer.borderColor = UIColor.black.cgColor
//    }

//    func addImage(imageURL: String) {
//        self.currentlyEditingMedia = MediaScalableObject(imageURL: imageURL)
//        self.addSubview(self.currentlyEditingMedia!.imageView)
//        self.currentlyEditingMedia?.attachConstraintsToSuperview()
//    }
//
//    func addImage(image: UIImage) {
//        self.currentlyEditingMedia = MediaScalableObject(image: image)
//        self.addSubview(self.currentlyEditingMedia!.imageView)
//        self.currentlyEditingMedia?.attachConstraintsToSuperview()
//    }

    func endTouch(_ editingMedia: MediaScalableObject) {
        if let top = editingMedia.topConstraint?.constant,
            let leading = editingMedia.leadingConstraint?.constant,
            let bottom = editingMedia.bottomConstraint?.constant,
            let trailing = editingMedia.trailingConstraint?.constant,
            let superView = self.superview {
            let top = CGPoint(x: leading, y: top)
            let bottom = CGPoint(x: trailing, y: bottom)

            //TODO: Send full media scalable object instead of each

//            delegate?.updatePosition(top: top, bottom: bottom, viewTag: superView.tag, cellIndex: itemIndex)
//            delegateFromEditor?.updatePosition(top: top, bottom: bottom, viewTag: superView.tag, cellIndex: itemIndex)
        }
    }

    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {

        guard let editingMedia = self.currentlyEditingMedia else { return }

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
                    horizontalCentered = true
                }

            } else if abs(horizontalDelta) > 10 {
                horizontalCentered = false
            }

            // if scalable view's center inside middle area and velocity great than 10, center the view vertically
            if (velocity.y > 150 || velocity.y < -150) && abs(verticalDelta) < 10 {

                //keep the view centred untile detail value goes out middle area range
                if !verticalCentered {

                    editingMedia.topConstraint?.constant = verticalCenterConstant ?? 0
                    editingMedia.bottomConstraint?.constant = -(verticalCenterConstant ?? 0)
                    verticalCentered = true
                }
            } else if abs(verticalDelta) > 10 {
                verticalCentered = false
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

            //old code
//            editingMedia.trailingConstraint!.constant = editingMedia.previousTrailingConstraintValue  + translation.x
//            editingMedia.leadingConstraint!.constant = editingMedia.previousLeadingConstraintValue + translation.x
//            editingMedia.topConstraint?.constant = editingMedia.previousTopConstraingValue + translation.y
//            editingMedia.bottomConstraint?.constant = editingMedia.previousBottomConstraintValue + translation.y

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

        guard let editingMedia = self.currentlyEditingMedia else { return }

        if (sender.state == .ended){

            //Update position after moved
            endTouch(editingMedia)
            panGesture.isEnabled = true
            editingMedia.updatePreviousConstraintValue()


        }else if (sender.state == .changed){

            let changeScale = 1 - sender.scale

            let heightOfImage = self.frame.size.height

            //            print("delta height change: \(heightOfImage) w scale \(changeScale)")

            let deltaHeightChange = heightOfImage * changeScale
            //            print("delta height change: \(deltaHeightChange)")

            editingMedia.topConstraint!.constant = editingMedia.previousTopConstraingValue + deltaHeightChange/2
            editingMedia.bottomConstraint!.constant = editingMedia.previousBottomConstraintValue - deltaHeightChange/2

            let widthOfImage = self.frame.size.width
            let deltaWidthChange = widthOfImage * changeScale

            editingMedia.leadingConstraint!.constant = editingMedia.previousLeadingConstraintValue + deltaWidthChange/2
            editingMedia.trailingConstraint!.constant = editingMedia.previousTrailingConstraintValue - deltaWidthChange/2
        } else if (sender.state == .began) {
            panGesture.isEnabled = false
        }
    }

    func editingModel() {
        if isEditing {
            //            closeButton.isHidden = false
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 8
        } else {
            //            closeButton.isHidden = true
            self.layer.borderWidth = 0
        }
    }
}

extension CanvasView: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//extension StoryImageContainer: ImportDelegate {
//    func didImportPhotos (photos : [Photo]) {
//
//        if let image = photos.first?.thumbnailImage, let superView = self.superview {
//            currentlyEditingMedia?.imageView.image = image
//
//            //upload image to server
//            var options = Uploader.UploadOptions()
//            options.acl = .publicRead
//            options.addPolicy = true
//
//            self.delegate?.addImage(image, viewTag: superView.tag, cellIndex: self.itemIndex)
//            self.delegateFromEditor?.addImage(image, viewTag: superView.tag, cellIndex: self.itemIndex)
//
//            //            Uploader.uploadUIImage(image, metadata: photos.first?.metadata as AnyObject?, options: options, success: { (resource) in
//            //                let file: Resource.File = resource.files[0]
//            //
//            //                photos.first?.imagePHAsset = nil
//            //                photos.first?.image = nil
//
//            //                if let imageUrl = file.url?.absoluteString {
//
//            //                }
//            //            }, error: { (err) in
//            //                print(err)
//            //            }) { (pregress) in
//
//            //            }
//        }
//        self.parentViewController()?.dismiss(animated: true, completion: nil)
//    }
//
//    func didCancelImport() {
//
//    }
//}
