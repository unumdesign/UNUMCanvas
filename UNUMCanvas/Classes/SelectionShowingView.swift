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

public enum SelectionShowingViewStyle {
    case `default`, thin
}

public final class SelectionShowingView: UIView {
    let closeImageView: UIImageView
    let volumeButton: UIImageView
    let selectionViewMediaType: MediaType

    internal func setVolumeState(to isMuted: Bool) {
        guard
            let isMutedImage = UIImage(
                named: "Volume-Off",
                in: bundle,
                compatibleWith: nil)?
                .withRenderingMode(.alwaysTemplate),
            let isNotMutedImage = UIImage(
                named: "Volume",
                in: bundle,
                compatibleWith: nil)?
                .withRenderingMode(.alwaysTemplate) else {
                    assertionFailure("There should be images.")
                    return
        }

        volumeButton.image = isMuted ? isMutedImage : isNotMutedImage
    }
    
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

    private let style: SelectionShowingViewStyle
    
    init(mediaType: MediaType, style: SelectionShowingViewStyle) {
        self.style = style

        let closeImage = UIImage(named: "deleteImageIcon", in: bundle, compatibleWith: nil)
        closeImageView = UIImageView(image: closeImage)

        self.selectionViewMediaType = mediaType

        let volumeImage = UIImage(
            named: "Volume",
            in: bundle,
            compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
        volumeButton = UIImageView(image: volumeImage)
        volumeButton.tintColor = .white
        volumeButton.backgroundColor = .init(white: 0.0, alpha: 0.7)
        volumeButton.layer.cornerRadius = 20

        super.init(frame: .zero)

        layoutView()
    }
    
    private func layoutView() {

        if selectionViewMediaType == .video {
            addVolumeButton()
        }

        addCloseButton()


        switch style {
        case .default:
            layer.borderWidth = 4
        case .thin:
            layer.borderWidth = 1

            let cornerArrowImage = UIImage(named: "corner_arrow", in: bundle, compatibleWith: nil)!

            let topLeftArrow = UIImageView(image: cornerArrowImage)
            let topRightArrow = UIImageView(image: cornerArrowImage)
            topRightArrow.transform = CGAffineTransform(rotationAngle: .pi/2)
            let bottomRightArrow = UIImageView(image: cornerArrowImage)
            bottomRightArrow.transform = CGAffineTransform(rotationAngle: .pi)
            let bottomLeftArrow = UIImageView(image: cornerArrowImage)
            bottomLeftArrow.transform = CGAffineTransform(rotationAngle: -.pi/2)

            addSubview(topLeftArrow)
            addSubview(topRightArrow)
            addSubview(bottomLeftArrow)
            addSubview(bottomRightArrow)

            let offset: CGFloat = 1

            topLeftArrow.topAnchor == topAnchor - offset
            topRightArrow.topAnchor == topAnchor - offset

            topRightArrow.trailingAnchor == trailingAnchor + offset
            bottomRightArrow.trailingAnchor == trailingAnchor + offset

            bottomRightArrow.bottomAnchor == bottomAnchor + offset
            bottomLeftArrow.bottomAnchor == bottomAnchor + offset

            bottomLeftArrow.leadingAnchor == leadingAnchor - offset
            topLeftArrow.leadingAnchor == leadingAnchor - offset
        }
        layer.borderColor = UIColor.blue.cgColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
