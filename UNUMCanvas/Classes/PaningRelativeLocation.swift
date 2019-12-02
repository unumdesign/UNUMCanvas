//
//  PaningRelativeLocation.swift
//  UNUMCanvas
//
//  Created by Patrick Flanagan on 11/20/18.
//

import Foundation

// Scaling Logic
struct PaningRelativeLocation {
    let location: CGPoint
    let frame: CGRect

    var isNearBottomEdgeOfFrame: Bool {
        return isHorizontallyCloseEnoughForActivation && abs(location.y - frame.height) <= 25
    }

    var isNearTopEdgeOfFrame: Bool {
        return isHorizontallyCloseEnoughForActivation && abs(location.y) <= 25
    }

    var isNearLeadingEdgeOfFrame: Bool {
        return isVerticallyCloseEnoughForActivation && abs(location.x) <= 25
    }

    var isNearTrailingEdgeOfFrame: Bool {
        return isVerticallyCloseEnoughForActivation && abs(location.x - frame.width) <= 25
    }

    var isHorizontallyCloseEnoughForActivation: Bool {
        return location.x >= -25 && location.x <= frame.width + 25
    }

    var isVerticallyCloseEnoughForActivation: Bool {
        return location.y >= -25 && location.y <= frame.height + 25
    }
}
