//
//  CanvasController+PanGesture+Moving.swift
//  UNUMCanvas
//
//  Created by Patrick Flanagan on 11/20/18.
//

import Foundation

extension CanvasController {
    func moveView(_ sender: UIPanGestureRecognizer, selectedView: UIView, selectedRegion: CanvasRegionView) {
        for canvasView in selectedRegion.canvasViews {
            // store the view's transform so that it can be reapplied after moving the view.
            let transformToReapply = selectedView.transform

            // reset transform to allow proper directional navigation of object
            selectedView.transform = CGAffineTransform.identity

            let translation = sender.translation(in: canvasView)

            //            var updatedOrigin = CGPoint(
            //                x: selectedView.frame.origin.x + translation.x,
            //                y: selectedView.frame.origin.y + translation.y
            //            )
            //
            //            let centerX = canvasView.frame.origin.x + canvasView.frame.width / 2
            //            if shouldLock(selectedView, toCenterX: centerX, usingSender: sender) {
            //                updatedOrigin = CGPoint(x: centerX - selectedView.frame.width / 2, y: updatedOrigin.y)
            //                canvasView.showCenterXIndication()
            //            }
            //            else {
            //                canvasView.hideCenterXIndication()
            //            }

            //            let centerY = canvasView.frame.origin.y + canvasView.frame.height / 2
            //            if shouldLock(selectedView, toCenterY: centerY, usingSender: sender) {
            //                updatedOrigin = CGPoint(x: updatedOrigin.x, y: centerY - selectedView.frame.height / 2)
            //                canvasView.showCenterYIndication()
            //            }
            //            else {
            //                canvasView.hideCenterYIndication()
            //            }

            //            updatedOrigin = transformToBeOnScreen(updatedOrigin, for: selectedView, canvasRegionView: selectedRegion.regionView)

            // update sele
            //            selectedView.constraints.forEach { constraint in
            //                switch constraint.firstAttribute {
            //                case .leading:
            //                    constraint.constant += translation.x
            //                case .top:
            //                    constraint.constant += translation.y
            //                default:
            //                    return
            //                }
            //            }

            selectedView.superview?.constraints.forEach { constraint in
                guard
                    let view = constraint.firstItem as? UIView,
                    view == selectedView
                    else {
                        return
                }
                switch constraint.firstAttribute {
                case .leading:
                    constraint.constant += translation.x
                case .top:
                    constraint.constant += translation.y
                default:
                    return
                }
            }

            //            selectedView.frame.origin = updatedOrigin

            sender.setTranslation(.zero, in: canvasView)

            // return transform onto view in order to keep previous transformations on the view
            selectedView.transform = transformToReapply
        }
    }

    private func isWithinVelocityRangeToEnableLocking(velocity: CGFloat) -> Bool {
        return abs(velocity) > 50 && abs(velocity) < 150 //< absoluteVelocityEnablingLocking
    }

    private func isWithinDistanceRangeToEnableLocking(distance: CGFloat) -> Bool {
        return abs(distance) < absoluteDistanceEnablingLocking
    }

    // X Axis
    private func velocityIsWithinRangeToEnableLockingOnXAxis(sender: UIPanGestureRecognizer) -> Bool {
        let velocityX = sender.velocity(in: gestureRecognizingView).x
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
        let velocityY = sender.velocity(in: gestureRecognizingView).y
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

    // TODO: plf - will need to change from mainView to canvasRegionView
    /// Make sure the given view is always on screen. The borderControlAmount determines how 'on-screen' the view should be kept. This function ensures that selected views are not moved extremely far off-screen when user is panning.
    private func transformToBeOnScreen(_ origin: CGPoint, for view: UIView, canvasRegionView: UIView) -> CGPoint {

        let borderControlAmount: CGFloat = 2

        let minX = borderControlAmount - view.frame.width // canvasRegionView?
        let minY = borderControlAmount - view.frame.height
        let maxX = canvasRegionView.frame.maxX - borderControlAmount
        let maxY = canvasRegionView.frame.maxY - borderControlAmount

        // Keep view's x coordinate between the beginning and end of mainView
        var legitimateX: CGFloat
        if origin.x < minX {
            legitimateX = minX
        } else if origin.x > maxX {
            legitimateX = maxX
        } else {
            legitimateX = origin.x
        }

        // Keep view's y coordinate between the beginning and end of mainView
        var legitimateY: CGFloat
        if origin.y < minY {
            legitimateY = minY
        } else if origin.y > maxY {
            legitimateY = maxY
        } else {
            legitimateY = origin.y
        }

        return CGPoint(x: legitimateX, y: legitimateY)
    }
}
