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
        var actionPerformed = false
        view.subviews.forEach { subview in
            if
                let subview = subview as? SelectionShowingView,
                subview.closeImageView.bounds.contains(sender.location(in: subview.closeImageView))
            {
                guard let selectView = selectedView else {
                    assertionFailure("There shouldn't be a delete button if there is no view selected")
                    return
                }
                if let superview = selectView.superview {
                    selectedViewObservingDelegate?.selectedViewWasRemoved?(from: superview)
                }
                selectView.removeFromSuperview()
                
                canvasRegionViews.forEach({ canvasRegionView in
                    if let index = canvasRegionView.interactableViews.firstIndex(of: selectView) {
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
        
        let regionViewsOrderedByViewZLayering = canvasRegionViews.sorted { (first, second) -> Bool in
            guard
                let firstSuperview = first.regionView.superview,
                let secondSuperview = second.regionView.superview,
                firstSuperview == secondSuperview, // should both be in same view hierarchy. If not, maintain original order.
                let firstsIndexPosition = firstSuperview.subviews.firstIndex(of: first.regionView),
                let secondsIndexPosition = secondSuperview.subviews.firstIndex(of: second.regionView)
                else {
                    assertionFailure("This doesn't seem like it should be possible except by improperly setting up the Canvas. assertion here to investigate if it ever does occur.")
                    return true
            }
            return firstsIndexPosition > secondsIndexPosition // The greater the index position, the higher in the view hierarchy
        }

        for canvasRegion in regionViewsOrderedByViewZLayering {
            
            // ensure the click was within the given region.
            let regionClicked = canvasRegion.regionView.point(inside: sender.location(in: canvasRegion.regionView), with: nil)
            guard regionClicked else {
                continue
            }
            
            switch viewSelectionStyle {
            case .image:
                if handleTapEventInImage(in: canvasRegion, sender: sender) {
                    return
                }
            case .region:
                if handleTapEventInRegion(in: canvasRegion, sender: sender) {
                    return
                }
            }
        }
        
        // If click was not within any movableView, then set to nil (making all views deselected).
        selectedView = nil
    }
    
    /// Return true if the tap resulted in a view selection-event
    /// Return false if the tap did not result in any view selection-event
    func handleTapEventInImage(in canvasRegion: CanvasRegionView, sender: UITapGestureRecognizer) -> Bool {
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
                return true
            }
            
            // If click was within selected view, then deselect and return.
            if let unwrappedView = selectedView, unwrappedView == view {
                selectedView = nil
                return true
            }
                // Otherwise set the clicked view as the selected view and return.
            else {
                selectedView = view
                return true
            }
        }
        return false
    }
    
    /// Return true if the tap resulted in a view selection-event
    /// Return false if the tap did not result in any view selection-event
    func handleTapEventInRegion(in canvasRegion: CanvasRegionView, sender: UITapGestureRecognizer) -> Bool {
        // this functionality does not support multiple interactable views in a canvasRegion for the time being.
        guard canvasRegion.interactableViews.count < 2 else {
            assertionFailure("We have not done the necessary work to be able to have multiple interactable views per region. For now it can be assumed that each region will only ever have one interactable view.")
            return false
        }
        
        // make sure region has a selectable view.
        guard let selectableView = canvasRegion.interactableViews.first else {
            return false
        }
        
        // ensure the click was within the given canvasRegion
        let viewClicked = canvasRegion.regionView.point(inside: sender.location(in: canvasRegion.regionView), with: nil)
        guard viewClicked else {
            return false
        }
        
        // since tap was within a regionView, indicate that the tap was within a selectableView.
        selectedViewObservingDelegate?.tapWasInSelectableView?()
        
        // delete the view if the click was within the delete icon
        let deletedView = deleteButtonPressed(on: canvasRegion.regionView, sender: sender)
        
        // don't continue after a successful delete
        guard deletedView == false else {
            return true
        }
        
        // If click was within selected canvasRegion, then deselect the selectedView and return.
        for subview in canvasRegion.regionView.subviews {
            if subview is SelectionShowingView {
                selectedView = nil
                return true
            }
        }
        
        // Otherwise set the clicked view as the selected view and return.
        selectedView = selectableView
        return true
    }
}
