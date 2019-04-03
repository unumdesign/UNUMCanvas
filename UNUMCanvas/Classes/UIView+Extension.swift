//
//  UIView+UNUM.swift
//  UNUM
//
//  Created by Jason Scharff on 7/7/17.
//  Copyright © 2017 CTRL LA. All rights reserved.
//
import Foundation

internal extension UIView {

    enum MediaType {
        case video
        case image
        case view
    }

    var mediaType: MediaType {
        if self is AVPlayerView {
            return .video
        }
        else if self is UIImageView {
            return .image
        }
        else {
            return .view
        }
    }
}
