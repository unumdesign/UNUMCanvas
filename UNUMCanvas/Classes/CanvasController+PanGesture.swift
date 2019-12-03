//
//  CanvasController+PanGesture.swift
//  UNUMCanvas
//
//  Created by Patrick Flanagan on 11/16/18.
//

import Foundation

// MARK: Pan Gesture
extension CanvasController {

    @objc
    func panOnViewController(_ sender: UIPanGestureRecognizer) {
        guard let selectedView = selectedView else {
            return
        }

        updateTapGestureEnabledStateBasedOnOpposite(of: sender)

        if sender.state == .ended {
            hideAllAxisIndicators()
            indicateViewWasModified()
            return
        }

        moveSelectedViewAndShowIndicatorViewsIfNecessary(sender, selectedView: selectedView)
    }

    private func updateTapGestureEnabledStateBasedOnOpposite(of sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            tapGesture.isEnabled = false
        } else if sender.state == .ended {
            tapGesture.isEnabled = true
        }
    }

    private func hideAllAxisIndicators() {
        allCanvasViews.forEach({
            $0.hideCenterXIndication()
            $0.hideCenterYIndication()
        })
    }

    private func moveSelectedViewAndShowIndicatorViewsIfNecessary(_ sender: UIPanGestureRecognizer, selectedView: UIView) {
        assert(allCanvasViews.count > 0)
        guard let selectedRegion = canvasRegionViews.filter({ $0.interactableViews.contains(selectedView) }).first else {
            return
        }

        let location = sender.location(in: selectedView)
        let frame = selectedView.convert(selectedView.frame, to: gestureRecognizingView)
        let relativeLocation = PaningRelativeLocation(location: location, frame: frame)

        if sender.state == .began {
            setScalingType(relativeLocation: relativeLocation)
        }

        // will be reactivated with https://unumdesign.atlassian.net/browse/IOS-105
//        if panScalingType.horizontal == .notActivated && panScalingType.vertical == .notActivated {
        moveView(sender, selectedView: selectedView, selectedRegion: selectedRegion)
//            return
//        }
//
//        scaleView(sender, selectedView: selectedView, selectedRegion: selectedRegion)
    }

    private func setScalingType(relativeLocation: PaningRelativeLocation) {
        // setup verticalScaling
        if relativeLocation.isNearBottomEdgeOfFrame {
            panScalingType.vertical = .bottom
        } else if relativeLocation.isNearTopEdgeOfFrame {
            panScalingType.vertical = .top
        } else {
            panScalingType.vertical = .notActivated
        }

        // setup horizontalScaling
        if relativeLocation.isNearLeadingEdgeOfFrame {
            panScalingType.horizontal = .leading
        } else if relativeLocation.isNearTrailingEdgeOfFrame {
            panScalingType.horizontal = .trailing
        } else {
            panScalingType.horizontal = .notActivated
        }
    }

    private func scaleView(_ sender: UIPanGestureRecognizer, selectedView: UIView, selectedRegion: CanvasRegionView) {

        for canvasView in selectedRegion.canvasViews {
            // store the view's transform so that it can be reapplied after moving the view.
            let transformToReapply = selectedView.transform

            // reset transform to allow proper directional navigation of object
            selectedView.transform = CGAffineTransform.identity

            let translation = sender.translation(in: canvasView)
            scale(selectedView: selectedView, translation: translation)

            sender.setTranslation(.zero, in: canvasView)

            // return transform onto view in order to keep previous transformations on the view
            selectedView.transform = transformToReapply
        }
    }

    private func scale(selectedView: UIView, translation: CGPoint) {
        switch panScalingType.horizontal {
        case .leading:
            adjustLeadingConstraint(of: selectedView, by: translation.x)
        case .trailing:
            adjustTrailingConstraint(of: selectedView, by: translation.x)
        case .notActivated:
            print("horizontal not activated")
        }

        switch panScalingType.vertical {
        case .top:
            adjustTopConstraint(of: selectedView, by: translation.y)
        case .bottom:
            adjustBottomConstraint(of: selectedView, by: translation.y)
        case .notActivated:
            print("vertical not activated")
        }
    }
}
