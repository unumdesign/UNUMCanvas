//
//  CanvasController+RotateGesture.swift
//  UNUMCanvas
//
//  Created by Patrick Flanagan on 11/16/18.
//

import Foundation

// MARK: Rotate Gesture
extension CanvasController {

    @objc
    func rotateSelectedViewController(_ sender: UIRotationGestureRecognizer) {
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

        if abs(sender.velocity) < 0.2 {
            if near0 {
                selectedView.transform = CGAffineTransform(rotationAngle: -1 * rotation).concatenating(selectedView.transform)
            } else if near90 {
                selectedView.transform = CGAffineTransform(rotationAngle: degree90 - rotation).concatenating(selectedView.transform)
            } else if near180 {
                selectedView.transform = CGAffineTransform(rotationAngle: degree180 - rotation).concatenating(selectedView.transform)
            } else if near270 {
                selectedView.transform = CGAffineTransform(rotationAngle: degree270 - rotation).concatenating(selectedView.transform)
            } else {
                selectedView.transform = t
            }
        } else {
            selectedView.transform = t
        }

        sender.rotation = 0

        if sender.state == .ended {
            indicateViewWasModified()
        }
    }
}
