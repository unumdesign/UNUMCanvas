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
        var selectedViewWasDeleted = false

        guard
            let selectionShowingView = selectionShowingView,
            let selectedView = selectedView,
            let superview = selectedView.superview
            else {
                return selectedViewWasDeleted
        }

        if selectionShowingView.closeImageView.bounds.contains(sender.location(in: selectionShowingView.closeImageView)) {
            selectedViewObservingDelegate?.selectedViewWasRemoved?(from: superview)
            selectedView.removeFromSuperview()

            canvasRegionViews.forEach({ canvasRegionView in
                if let index = canvasRegionView.interactableViews.firstIndex(of: selectedView) {
                    canvasRegionView.interactableViews.remove(at: index)
                }
            })

            self.selectedView = nil
            selectedViewWasDeleted = true
        }

        return selectedViewWasDeleted
    }

    @objc func volumeButtonPressed(on view: UIView, sender: UITapGestureRecognizer) -> Bool {
        if
            let selectionShowingView = selectionShowingView,
            let selectedView = selectedView,
            let playerView = selectedView as? AVPlayerView,
            selectionShowingView.volumeButton.bounds.contains(
                sender.location(in: selectionShowingView.volumeButton)
            )
        {
            playerView.videoPlayer.isMuted.toggle()
            selectionShowingView.setVolumeState(to: playerView.videoPlayer.isMuted)

            return true
        }
        return false
    }

    @objc func tapOnViewController(_ sender: UITapGestureRecognizer) {

        // only act on completed clicks
        guard sender.state == .ended else {
            return
        }

        // CanvasRegions for different pages will not have the same superview. Therefore they won't be sorted against each other. This shouldn't cause any issues, though, because a tap will only occur in one particular page, and those canvasRegions will be ordered appropriately against themselves.
        let regionViewsOrderedByViewZLayering = canvasRegionViews.sorted { (first, second) -> Bool in
            guard
                let firstSuperview = first.regionView.superview,
                let secondSuperview = second.regionView.superview,
                firstSuperview == secondSuperview, // should both be in same view hierarchy. If not, maintain original order.
                let firstsIndexPosition = firstSuperview.subviews.firstIndex(of: first.regionView),
                let secondsIndexPosition = secondSuperview.subviews.firstIndex(of: second.regionView)
                else {
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
            case .media:
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

        // CanvasRegions for different pages will not have the same superview. Therefore they won't be sorted against each other. This shouldn't cause any issues, though, because a tap will only occur in one particular page, and those canvasRegions will be ordered appropriately against themselves.
        let interactableViewsOrderedByViewZLayering = canvasRegion.interactableViews.sorted { (first, second) -> Bool in
            guard
                let firstSuperview = first.superview,
                let secondSuperview = second.superview,
                firstSuperview == secondSuperview, // should both be in same view hierarchy. If not, maintain original order.
                let firstsIndexPosition = firstSuperview.subviews.firstIndex(of: first),
                let secondsIndexPosition = secondSuperview.subviews.firstIndex(of: second)
                else {
                    return true
            }
            return firstsIndexPosition > secondsIndexPosition // The greater the index position, the higher in the view hierarchy
        }


        for view in interactableViewsOrderedByViewZLayering {

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

            // if the click was within volume button, then handle volume
            if volumeButtonPressed(on: view, sender: sender) {
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
        let viewWasDeleted = deleteButtonPressed(on: canvasRegion.regionView, sender: sender)

        // don't continue after a successful delete
        if viewWasDeleted {
            return true
        }

        // if the click was within volume button, then handle volume
        if volumeButtonPressed(on: canvasRegion.regionView, sender: sender) {
            return true
        }

        if selectableView == selectedView {
            // If click was within selected canvasRegion, then deselect the selectedView and return.
            selectedView = nil
        }
        else {
            // Otherwise set the clicked view as the selected view and return.
            selectedView = selectableView
        }

        return true
    }
}
