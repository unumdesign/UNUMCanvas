//
//  AVPlayerLayer.swift
//  UNUMCanvas
//
//  Created by Patrick Flanagan on 4/2/19.
//

import Foundation
import AVKit

public class AVPlayerView: UIView {

    public var videoPlayer: AVPlayer {
        guard
            let playerLayer = layer as? AVPlayerLayer,
            let player = playerLayer.player
            else {
                assertionFailure("Player Layer should be set at init.")
                return AVPlayer(playerItem: nil)
        }
        return player
    }

    override public class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    public init(player: AVPlayer) {
        super.init(frame: .zero)
        guard let castedLayer = layer as? AVPlayerLayer else {
            assertionFailure("Layer is not able to be cast properly")
            return
        }
        castedLayer.player = player
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
