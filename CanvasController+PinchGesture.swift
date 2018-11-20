//
//  CanvasController+PinchGesture.swift
//  UNUMCanvas
//
//  Created by Patrick Flanagan on 11/16/18.
//

import Foundation

extension UIView {
    
    private func getConstraint(from constraintView: UIView?, type: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {

        var returnConstraint: NSLayoutConstraint? = nil
        
        // Keep in mind that this will return the last of the constraints fulfilling the type.
        for constraint in constraintView?.constraints ?? [] {
            guard
                let view = constraint.firstItem as? UIView,
                view == self
                else {
                    continue
            }
            if constraint.firstAttribute == type {
                returnConstraint = constraint
            }
        }
        return returnConstraint
    }
    
    private func getInternalConstraint(type: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        return getConstraint(from: self, type: type)
    }
    
    var widthConstraint: NSLayoutConstraint? {
        return getInternalConstraint(type: .width)
    }
    
    var heightConstraint: NSLayoutConstraint? {
        return getInternalConstraint(type: .height)
    }
}

extension UIView {
    private func getSuperviewConstraint(type: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        return getConstraint(from: self.superview, type: type)
    }
    
    var leadingConstraint: NSLayoutConstraint? {
        return getSuperviewConstraint(type: .leading)
    }
    
    var topConstraint: NSLayoutConstraint? {
        return getSuperviewConstraint(type: .top)
    }
}

// MARK: Pinch Gesture
extension CanvasController {
    
    @objc func scaleSelectedView(_ sender: UIPinchGestureRecognizer) {
        guard let selectedView = selectedView else {
            return
        }
        
        var heightDifference: CGFloat = 0
        var widthDifference: CGFloat = 0
        
        // increase width and height according to scale
        if let widthConstraint = selectedView.widthConstraint {
            let previousWidth = widthConstraint.constant
            widthConstraint.constant = widthConstraint.constant * sender.scale
            widthDifference = widthConstraint.constant - previousWidth
        }
        
        
        if let heightConstraint = selectedView.heightConstraint {
            let previousHeight = heightConstraint.constant
            heightConstraint.constant = heightConstraint.constant * sender.scale
            
            if
                let selectedImageView = selectedView as? UIImageView,
                let image = selectedImageView.image
            {
                let ratio = image.size.height / image.size.width
                heightDifference = widthDifference * ratio
            }
            else {
                heightDifference = heightConstraint.constant - previousHeight
            }
        }
        
        // adjust leading and top anchors to keep view centered
        if let leadingConstraint = selectedView.leadingConstraint {
            leadingConstraint.constant = leadingConstraint.constant - widthDifference / 2
        }
        
        if let topConstraint = selectedView.topConstraint {
            topConstraint.constant = topConstraint.constant - heightDifference / 2
        }
        
        // reset scale after applying in order to keep scaling linear rather than exponential
        sender.scale = 1.0
    }
}
