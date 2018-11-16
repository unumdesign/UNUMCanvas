//
//  CanvasController+TapGesture.swift
//  UNUMCanvas
//
//  Created by Patrick Flanagan on 11/16/18.
//

import Foundation

// MARK: Tap Gesture
extension CanvasController {
    
    @objc func deleteButtonPressed(on view: UIView, sender: UITapGestureRecognizer) -> Bool {
        guard view == selectedView else {
            return false
        }
        
        var actionPerformed = false
        view.subviews.forEach { subview in
            if
                let subview = subview as? SelectionShowingView,
                subview.closeImageView.bounds.contains(sender.location(in: subview.closeImageView))
            {
                view.removeFromSuperview()
                
                canvasRegionViews.forEach({ canvasRegionView in
                    if let index = canvasRegionView.interactableViews.firstIndex(of: view) {
                        canvasRegionView.interactableViews.remove(at: index)
                    }
                })
                
                selectedView = nil
                actionPerformed = true
            }
        }
        return actionPerformed
    }
    
    @objc func tapOnViewController(_ sender: UITapGestureRecognizer) {
        
        // only act on completed clicks
        guard sender.state == .ended else {
            return
        }
        
        for canvasRegion in canvasRegionViews {
            
            // ensure the click was within the given region.
            let regionClicked = canvasRegion.regionView.point(inside: sender.location(in: canvasRegion.regionView), with: nil)
            guard regionClicked else {
                continue
            }
            
            // 'Reversed' makes sure the view at the highest layer is selected rather than views farther down.
            for view in canvasRegion.interactableViews.reversed() {
                
                // ensure the click was within the given interactableView
                let viewClicked = view.point(inside: sender.location(in: view), with: nil)
                guard viewClicked else {
                    continue
                }
                
                // since tap was within an interactableView, indicate that the tap was within a selectableView.
                selectedViewObservingDelegate?.tapWasInSelectableView?()
                
                // delete the view if the click was within the delete icon
                let deletedView = deleteButtonPressed(on: view, sender: sender)
                
                // don't continue after a successful delete
                guard deletedView == false else {
                    return
                }
                
                // If click was within selected view, then deselect and return.
                if let unwrappedView = selectedView, unwrappedView == view {
                    selectedView = nil
                    return
                }
                    // Otherwise set the clicked view as the selected view and return.
                else {
                    selectedView = view
                    return
                }
            }
        }
        
        //        // If click is within movableViews, set to first one.
        //        // 'Reversed' makes sure the view at the highest layer is selected rather than views farther down.
        //        for view in allInteractableViews.reversed() {
        //
        //            let deletedView = deleteButtonPressed(on: view, sender: sender)
        //
        //            guard
        //                sender.state == .ended,
        //                deletedView == false
        //                else {
        //                    return
        //            }
        //
        //            let viewClicked = view.point(inside: sender.location(in: view), with: nil)
        //            guard viewClicked else {
        //                continue
        //            }
        //            // If click was within selected view, then deselect and return.
        //            if let unwrappedView = selectedView, unwrappedView == view {
        //                selectedView = nil
        //                return
        //            }
        //            // Otherwise set the clicked view as the selected view and return.
        //            else {
        //                selectedView = view
        //                return
        //            }
        //        }
        
        // If click was not within any movableView, then set to nil (making all views deselected).
        selectedView = nil
    }
}
