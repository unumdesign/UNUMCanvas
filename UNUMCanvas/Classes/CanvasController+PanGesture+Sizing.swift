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
            let topConstraint = view.internalTopConstraint,
            let leadingConstraint = view.internalLeadingConstraint,
            let heightConstraint = view.internalHeightConstraint,
            let widthConstraint = view.internalWidthConstraint
        {
            
            if view.heightIsBoundToWidth {
                // Need to do an extra update to topConstraint
                let ratio = view.frame.width / view.frame.height
                let ratioAmount = amount * ratio
                
                topConstraint.constant = topConstraint.constant + ratioAmount * 1/2
            }
            else if view.widthIsBoundToHeight {
                let ratio = view.frame.height / view.frame.width
                let ratioAmount = amount * ratio
                
                topConstraint.constant = topConstraint.constant + ratioAmount * 1/2
                heightConstraint.constant = heightConstraint.constant + ratioAmount * -1
                leadingConstraint.constant = leadingConstraint.constant + amount
                
                return
            }
            
            leadingConstraint.constant = leadingConstraint.constant + amount
            widthConstraint.constant = widthConstraint.constant + amount * -1
        }
    }
    
    func adjustTrailingConstraint(of view: UIView, by amount: CGFloat) {
        if
            let topConstraint = view.internalTopConstraint,
            let heightConstraint = view.internalHeightConstraint,
            let widthConstraint = view.internalWidthConstraint
        {
            
            if view.heightIsBoundToWidth {
                // Need to do an extra update to topConstraint
                let ratio = view.frame.height / view.frame.width
                let ratioAmount = amount * ratio
                
                topConstraint.constant = topConstraint.constant + ratioAmount * -1/2
            }
            else if view.widthIsBoundToHeight {
                let ratio = view.frame.height / view.frame.width
                let ratioAmount = amount * ratio
                
                topConstraint.constant = topConstraint.constant + ratioAmount * -1/2
                heightConstraint.constant = heightConstraint.constant + ratioAmount
                
                return
            }
            
            widthConstraint.constant = widthConstraint.constant + amount
        }
    }
    
    func adjustTopConstraint(of view: UIView, by amount: CGFloat) {
        if
            let topConstraint = view.internalTopConstraint,
            let leadingConstraint = view.internalLeadingConstraint,
            let heightConstraint = view.internalHeightConstraint,
            let widthConstraint = view.internalWidthConstraint
        {
            
            if view.heightIsBoundToWidth {
                let ratio = view.frame.width / view.frame.height
                let ratioAmount = amount * ratio
                
                leadingConstraint.constant = leadingConstraint.constant + ratioAmount * 1/2
                widthConstraint.constant = widthConstraint.constant + ratioAmount * -1
                topConstraint.constant = topConstraint.constant + amount
                
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
    
    func adjustBottomConstraint(of view: UIView, by amount: CGFloat) {
        if
            let leadingConstraint = view.internalLeadingConstraint,
            let heightConstraint = view.internalHeightConstraint,
            let widthConstraint = view.internalWidthConstraint
        {
            
            if view.heightIsBoundToWidth {
                let ratio = view.frame.width / view.frame.height
                let ratioAmount = amount * ratio
                
                leadingConstraint.constant = leadingConstraint.constant + ratioAmount * -1/2
                widthConstraint.constant = widthConstraint.constant + ratioAmount
                
                return
            }
            else if view.widthIsBoundToHeight {
                // Need to do an extra update to leading constraint
                let ratio = view.frame.width / view.frame.height
                let ratioAmount = amount * ratio
                leadingConstraint.constant = leadingConstraint.constant + ratioAmount * -1/2
            }
            
            heightConstraint.constant = heightConstraint.constant + amount
        }
    }
}
