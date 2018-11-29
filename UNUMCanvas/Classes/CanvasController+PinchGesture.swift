//
//  CanvasController+PinchGesture.swift
//  UNUMCanvas
//
//  Created by Patrick Flanagan on 11/16/18.
//

import Foundation


// MARK: Pinch Gesture
extension CanvasController {
    
    @objc func scaleSelectedView(_ sender: UIPinchGestureRecognizer) {
        guard let selectedView = selectedView else {
            return
        }

        if
            selectedView.widthIsBoundToHeight,
            let heightConstraint = selectedView.heightConstraint
        {
            let previousHeight = heightConstraint.constant
            let newHeight = heightConstraint.constant * sender.scale

            heightConstraint.constant = newHeight

            var ratio: CGFloat = 1.0
            if
                let selectedImageView = selectedView as? UIImageView,
                let image = selectedImageView.image
            {
                ratio = image.size.width / image.size.height
            }

            let heightDifference = newHeight - previousHeight
            let widthDifference = heightDifference * ratio

            // adjust leading and top anchors to keep view centered
            if let leadingConstraint = selectedView.leadingConstraint {
                leadingConstraint.constant = leadingConstraint.constant - widthDifference / 2
            }
            if let topConstraint = selectedView.topConstraint {
                topConstraint.constant = topConstraint.constant - heightDifference / 2
            }
        }
        else if
            selectedView.heightIsBoundToWidth,
            let widthConstraint = selectedView.widthConstraint
        {
            let previousWidth = widthConstraint.constant
            let newWidth = widthConstraint.constant * sender.scale

            widthConstraint.constant = newWidth

            var ratio: CGFloat = 1.0
            if
                let selectedImageView = selectedView as? UIImageView,
                let image = selectedImageView.image
            {
                ratio = image.size.height / image.size.width
            }

            let widthDifference = newWidth - previousWidth
            let heightDifference = widthDifference * ratio

            // adjust leading and top anchors to keep view centered
            if let leadingConstraint = selectedView.leadingConstraint {
                leadingConstraint.constant = leadingConstraint.constant - widthDifference / 2
            }
            if let topConstraint = selectedView.topConstraint {
                topConstraint.constant = topConstraint.constant - heightDifference / 2
            }
        }
        else {
            print("neither")
        }
        
//        // increase width and height according to scale
//        if let widthConstraint = selectedView.widthConstraint {
//            let previousWidth = widthConstraint.constant
//            widthConstraint.constant = widthConstraint.constant * sender.scale
//            widthDifference = widthConstraint.constant - previousWidth
//        }
//
//
//        if let heightConstraint = selectedView.heightConstraint {
//            let previousHeight = heightConstraint.constant
//            heightConstraint.constant = heightConstraint.constant * sender.scale
//
//            if
//                let selectedImageView = selectedView as? UIImageView,
//                let image = selectedImageView.image
//            {
//                let ratio = image.size.height / image.size.width
//                heightDifference = widthDifference * ratio
//            }
//            else {
//                heightDifference = heightConstraint.constant - previousHeight
//            }
//        }
//
//        // adjust leading and top anchors to keep view centered
//        if let leadingConstraint = selectedView.leadingConstraint {
//            leadingConstraint.constant = leadingConstraint.constant - widthDifference / 2
//        }
//
//        if let topConstraint = selectedView.topConstraint {
//            topConstraint.constant = topConstraint.constant - heightDifference / 2
//        }

        // reset scale after applying in order to keep scaling linear rather than exponential
        sender.scale = 1.0
    }
}
