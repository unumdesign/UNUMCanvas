//
//  UIView+UNUM.swift
//  UNUM
//
//  Created by Jason Scharff on 7/7/17.
//  Copyright © 2017 CTRL LA. All rights reserved.
//

import Foundation
extension UIView {
    func parentViewController() -> UIViewController? {
        var parent = self.next
        while parent != nil && !(parent is UIViewController) {
            parent = parent?.next
        }
        return parent as? UIViewController
    }

    func addConstraintsToCenterInSuperview() {
        addConstraintToCenterHorizontallyInSuperview()
        addConstraintToCenterVerticallyInSuperview()
    }

    func addConstraintToCenterHorizontallyInSuperview() {
        assert((self.superview != nil), "View does not have a superview")

        let x = NSLayoutConstraint(item: self,
                                   attribute: .centerX,
                                   relatedBy: .equal,
                                   toItem: self.superview,
                                   attribute: .centerX,
                                   multiplier: 1.0,
                                   constant: 0)

        self.superview?.addConstraint(x)
    }

    func addConstraintToCenterVerticallyInSuperview() {
        assert((self.superview != nil), "View does not have a superview")

        let y = NSLayoutConstraint(item: self,
                                   attribute: .centerY,
                                   relatedBy: .equal,
                                   toItem: self.superview,
                                   attribute: .centerY,
                                   multiplier: 1.0,
                                   constant: 0)
        self.superview?.addConstraint(y)
    }

    func forceWidthConstraint(width: CGFloat) {
        let width = NSLayoutConstraint(item: self,
                                       attribute: .width,
                                       relatedBy: .equal,
                                       toItem: nil,
                                       attribute: .notAnAttribute,
                                       multiplier: 1.0,
                                       constant: width)
        self.addConstraint(width)
    }

    func forceHeightConstraint(height: CGFloat) {
        let height = NSLayoutConstraint(item: self,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0,
                                        constant: height)
        self.addConstraint(height)
    }

    func setHorizontalToVerticalAspectRatio(ratio : CGFloat) {
        let aspectRatio = NSLayoutConstraint(item: self,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .height,
                                             multiplier: ratio,
                                             constant: 0)
        self.addConstraint(aspectRatio)
    }


    func applyConstraintToSuperviewWithVisualFormat(format: String) {
        _ = applyConstraintToSuperviewWithVisualFormatWithConstraint(format: format)
    }

    func applyConstraintToSuperviewWithVisualFormatWithConstraint(format: String) -> [NSLayoutConstraint] {
        assert((self.superview != nil), "View does not have a superview")

        let constraint = NSLayoutConstraint.constraints(withVisualFormat: format,
                                                        options: NSLayoutConstraint.FormatOptions(rawValue:0),
                                                        metrics: nil,
                                                        views: ["view" : self])

        self.superview!.addConstraints(constraint)
        return constraint
    }

    func fillWidthOfSuperview() {
        applyConstraintToSuperviewWithVisualFormat(format: "H:|[view]|")
    }

    func fillHeightOfSuperview() {
        applyConstraintToSuperviewWithVisualFormat(format: "V:|[view]|")
    }

    func pinToBottomOfSuperview() {
        applyConstraintToSuperviewWithVisualFormat(format: "V:[view]|")
    }

    func pinToBottomOfSuperviewWithConstraint(constant: CGFloat = 0) -> NSLayoutConstraint {

        let bottom = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: self.superview,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: constant)
        self.superview!.addConstraint(bottom)
        return bottom
    }

    func pinToTopOfSuperview() {
        applyConstraintToSuperviewWithVisualFormat(format: "V:|[view]")
    }

    func pinToTopOfSuperviewWithConstraint(constant: CGFloat = 0) -> NSLayoutConstraint {

        let top = NSLayoutConstraint(item: self,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: self.superview,
                                     attribute: .top,
                                     multiplier: 1.0,
                                     constant: constant)
        self.superview!.addConstraint(top)
        return top

    }

    func pinToLeftOfSuperview() {
        applyConstraintToSuperviewWithVisualFormat(format: "H:|[view]")
    }

    func pinToLeftOfSuperviewWithConstraint(constant: CGFloat = 0) -> NSLayoutConstraint {
        let leading = NSLayoutConstraint(item: self,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self.superview,
                                         attribute: .leading,
                                         multiplier: 1.0,
                                         constant: constant)
        self.superview!.addConstraint(leading)
        return leading

    }

    func pinToRightOfSuperview() {
        applyConstraintToSuperviewWithVisualFormat(format: "H:[view]|")
    }

    func pinToRightOfSuperviewWithConstraint(constant: CGFloat = 0) -> NSLayoutConstraint {

        let trailing = NSLayoutConstraint(item: self,
                                          attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: self.superview,
                                          attribute: .trailing,
                                          multiplier: 1.0,
                                          constant: constant)
        self.superview!.addConstraint(trailing)
        return trailing

    }

    func addConstraintsToFillSuperview() {
        applyConstraintToSuperviewWithVisualFormat(format: "H:|[view]|")
        applyConstraintToSuperviewWithVisualFormat(format: "V:|[view]|")

    }

}
