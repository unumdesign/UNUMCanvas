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
        
        var heightDifference: CGFloat?
        var widthDifference: CGFloat?
        
        // increase width and height according to scale
        selectedView.constraints.forEach { constraint in
            guard
                let view = constraint.firstItem as? UIView,
                view == selectedView
                else {
                    return
            }
            switch constraint.firstAttribute {
            case .width:
                let previousWidth = constraint.constant
                constraint.constant = constraint.constant * sender.scale
                widthDifference = constraint.constant - previousWidth
            case .height:
                let previousHeight = constraint.constant
                constraint.constant = constraint.constant * sender.scale
                heightDifference = constraint.constant - previousHeight
            default:
                return
            }
        }
        
        // adjust leading and top anchors to keep view centered
        selectedView.superview?.constraints.forEach { constraint in
            guard
                let view = constraint.firstItem as? UIView,
                view == selectedView,
                let heightDifference = heightDifference,
                let widthDifference = widthDifference
                else {
                    return
            }
            switch constraint.firstAttribute {
            case .leading:
                constraint.constant = constraint.constant - widthDifference / 2
            case .top:
                constraint.constant = constraint.constant - heightDifference / 2
            default:
                return
            }
        }
        
        // reset scale after applying in order to keep scaling linear rather than exponential
        sender.scale = 1.0
    }
}
