//
//  CanvasController+PinchGesture.swift
//  UNUMCanvas
//
//  Created by Patrick Flanagan on 11/16/18.
//

import Foundation

extension UIView {
    
    private func getConstraint(from constraintView: UIView?, type: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        for constraint in constraintView?.constraints ?? [] {
            guard
                let view = constraint.firstItem as? UIView,
                view == self
                else {
                    continue
            }
            if constraint.firstAttribute == type {
                return constraint
            }
        }
        return nil
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
            heightDifference = heightConstraint.constant - previousHeight
        }
        
        // adjust leading and top anchors to keep view centered
        if let leadingConstraint = selectedView.leadingConstraint {
            leadingConstraint.constant = leadingConstraint.constant - widthDifference / 2
        }
        
        if let topConstraint = selectedView.topConstraint {
            topConstraint.constant = topConstraint.constant - heightDifference / 2
        }
//
//
//        // increase width and height according to scale
//        selectedView.constraints.forEach { constraint in
//            guard
//                let view = constraint.firstItem as? UIView,
//                view == selectedView
//                else {
//                    return
//            }
//            switch constraint.firstAttribute {
//            case .width:
//                let previousWidth = constraint.constant
//                constraint.constant = constraint.constant * sender.scale
//                widthDifference = constraint.constant - previousWidth
//            case .height:
//                let previousHeight = constraint.constant
//                constraint.constant = constraint.constant * sender.scale
//                heightDifference = constraint.constant - previousHeight
//            default:
//                return
//            }
//        }
//
//        // adjust leading and top anchors to keep view centered
//        selectedView.superview?.constraints.forEach { constraint in
//            guard
//                let view = constraint.firstItem as? UIView,
//                view == selectedView,
//                let heightDifference = heightDifference,
//                let widthDifference = widthDifference
//                else {
//                    return
//            }
//            switch constraint.firstAttribute {
//            case .leading:
//                constraint.constant = constraint.constant - widthDifference / 2
//            case .top:
//                constraint.constant = constraint.constant - heightDifference / 2
//            default:
//                return
//            }
//        }
        
        // reset scale after applying in order to keep scaling linear rather than exponential
        sender.scale = 1.0
    }
}
