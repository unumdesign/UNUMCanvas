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

        var heightDifference: CGFloat = 0
        var widthDifference: CGFloat = 0

        // increase width and height according to scale
        if let widthConstraint = selectedView.internalWidthConstraint {
            let previousWidth = widthConstraint.constant
            widthConstraint.constant = widthConstraint.constant * sender.scale
            widthDifference = widthConstraint.constant - previousWidth
        }

        if let heightConstraint = selectedView.internalHeightConstraint {
            let previousHeight = heightConstraint.constant
            heightConstraint.constant = heightConstraint.constant * sender.scale

            if
                widthDifference != 0,
                let selectedImageView = selectedView as? UIImageView,
                let image = selectedImageView.image
            {
                let ratio = image.size.height / image.size.width
                heightDifference = widthDifference * ratio
            } else {
                heightDifference = heightConstraint.constant - previousHeight
            }
        }

        let ratio = selectedView.frame.height / selectedView.frame.width
        if widthDifference == 0 {
            widthDifference = heightDifference / ratio
        } else if heightDifference == 0 {
            heightDifference = widthDifference * ratio
        }

        // adjust leading and top anchors to keep view centered
        if let leadingConstraint = selectedView.internalLeadingConstraint {
            leadingConstraint.constant = leadingConstraint.constant - widthDifference / 2
        }

        if let topConstraint = selectedView.internalTopConstraint {
            topConstraint.constant = topConstraint.constant - heightDifference / 2
        }

        // reset scale after applying in order to keep scaling linear rather than exponential
        sender.scale = 1.0

        if sender.state == .ended {
            indicateViewWasModified()
        }
    }
}
