//
//  SelectionShowingView.swift
//  UNUMCanvas
//
//  Created by Patrick Flanagan on 10/18/18.
//

import Foundation
import Anchorage

internal var bundle: Bundle {
    var bundle = Bundle(for: SelectionShowingView.self)
    if let resourcePath = bundle.path(forResource: "UNUMCanvas", ofType: "bundle") {
        if let resourcesBundle = Bundle(path: resourcePath) {
            bundle = resourcesBundle
        }
    }
    return bundle
}

public final class SelectionShowingView: UIView {
    let closeImageView: UIImageView
    let volumeButton: UIImageView
    let selectionViewMediaType: MediaType
    
    private func addCloseButton() {
        addSubview(closeImageView)
        closeImageView.sizeAnchors == CGSize(width: 40, height: 40)
        closeImageView.topAnchor == topAnchor + 5
        closeImageView.trailingAnchor == trailingAnchor - 5
    }

    private func addVolumeButton() {
        addSubview(volumeButton)
        volumeButton.sizeAnchors == CGSize(width: 40, height: 40)
        volumeButton.bottomAnchor == bottomAnchor - 5
        volumeButton.trailingAnchor == trailingAnchor - 5

    }
    
    init(mediaType: MediaType) {

        let closeImage = UIImage(named: "deleteImageIcon", in: bundle, compatibleWith: nil)
        closeImageView = UIImageView(image: closeImage)

        self.selectionViewMediaType = mediaType

        let volumeImage = UIImage(named: "Volume", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        volumeButton = UIImageView(image: volumeImage)
        volumeButton.tintColor = .black
        volumeButton.backgroundColor = .white
        volumeButton.layer.borderColor = UIColor.black.cgColor
        volumeButton.layer.cornerRadius = 20
        volumeButton.layer.borderWidth = 2

        super.init(frame: .zero)

        layoutView()
    }
    
    private func layoutView() {
        layer.borderWidth = 4

        layer.borderColor = UIColor.blue.cgColor

        if selectionViewMediaType == .video {
            addVolumeButton()
        }

        addCloseButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
