//
//  CanvasController+PinchGesture+Sizing.swift
//  UNUMCanvas
//
//  Created by Patrick Flanagan on 11/20/18.
//

import Foundation

extension CanvasController {
    func adjustLeadingConstraint(of view: UIView, by amount: CGFloat) {
        if
            let topConstraint = view.topConstraint,
            let leadingConstraint = view.leadingConstraint,
            let heightConstraint = view.heightConstraint,
            let widthConstraint = view.widthConstraint
        {
            
            if view.heightIsBoundToWidth {
                // Need to do an extra update to topConstraint
                let ratio = view.frame.height / view.frame.width
                let ratioAmount = amount * ratio
                
                topConstraint.constant = topConstraint.constant + ratioAmount * 1/2
            }
            else if view.widthIsBoundToHeight {
                let ratio = view.frame.width / view.frame.height
                let ratioAmount = amount * ratio
                
                
                topConstraint.constant = topConstraint.constant + ratioAmount * 1/2
                
                let previousHeight = heightConstraint.constant
                heightConstraint.constant = heightConstraint.constant + ratioAmount * -1
                let heightDifference = heightConstraint.constant - previousHeight
                
                // Since width will be adjusted by the height, the leadingConstraint needs to be
                // adjusted not by the 'amount', but rather by the newly adjusted width amount.
                // This cannot be determined directly, and so we must find what the difference
                // in the height is and multiply it by the ratio in order to get the amount
                // the width has been adjusted.
                let widthDifference = heightDifference * ratio
                
                // The leading anchor is inversely related to the width (as the width increases,
                // the leading anchor must move left (negative) and as the width decreases, the leading
                // anchor must move right (positive). So our final formula must invert the
                // amount by multiplying by -1.
                leadingConstraint.constant = leadingConstraint.constant + widthDifference * -1
                
                return
            }
            
            leadingConstraint.constant = leadingConstraint.constant + amount
            widthConstraint.constant = widthConstraint.constant + amount * -1
        }
    }
    
    func adjustTopConstraint(of view: UIView, by amount: CGFloat) {
        if
            let topConstraint = view.topConstraint,
            let leadingConstraint = view.leadingConstraint,
            let heightConstraint = view.heightConstraint,
            let widthConstraint = view.widthConstraint
        {
            
            if view.heightIsBoundToWidth {
                let ratio = view.frame.height / view.frame.width
                let ratioAmount = amount * ratio
                
                
                leadingConstraint.constant = leadingConstraint.constant + ratioAmount * 1/2
                
                let previousWidth = widthConstraint.constant
                widthConstraint.constant = widthConstraint.constant + ratioAmount * -1
                let widthDifference = widthConstraint.constant - previousWidth
                
                // Since height will be adjusted by the width, the topConstraint needs to be
                // adjusted not by the 'amount', but rather by the newly adjusted height amount.
                // This cannot be determined directly, and so we must find what the difference
                // in the width is and multiply it by the ratio in order to get the amount
                // the height has been adjusted.
                let heightDifference = widthDifference * ratio
                
                // The top anchor is inversely related to the height (as the height increases,
                // the top anchor must move up (negative) and as the height decreases, the top
                // anchor must move down (positive). So our final formula must invert the
                // amount by multiplying by -1.
                topConstraint.constant = topConstraint.constant + heightDifference * -1
                
                return
            }
            else if view.widthIsBoundToHeight {
                // Need to do an extra update to leading constraint
                let ratio = view.frame.width / view.frame.height
                let ratioAmount = amount * ratio
                leadingConstraint.constant = leadingConstraint.constant + ratioAmount * 1/2
            }
            
            heightConstraint.constant = heightConstraint.constant + amount * -1
            topConstraint.constant = topConstraint.constant + amount
        }
    }
}
