//
//  SelectionShowingView.swift
//  UNUMCanvas
//
//  Created by Patrick Flanagan on 10/18/18.
//

import Foundation
import Anchorage

final class SelectionShowingView: UIView {

    let closeImageView: UIImageView
    
    private func addToView(image: UIImage) {
        
        let selectedImageView = UIImageView(image: image)
        selectedImageView.clipsToBounds = true
        selectedImageView.contentMode = .scaleAspectFit
        
        addSubview(selectedImageView)
        selectedImageView.topAnchor == self.topAnchor
        selectedImageView.leadingAnchor == self.leadingAnchor
        selectedImageView.sizeAnchors == self.sizeAnchors
    }
    
    private func addCloseButton() {
        
        addSubview(closeImageView)
        closeImageView.sizeAnchors == CGSize(width: 40, height: 40)
        closeImageView.topAnchor == topAnchor + 5
        closeImageView.trailingAnchor == trailingAnchor - 5

    }
    
    init(image: UIImage? = nil) {
        
        var bundle = Bundle(identifier: "org.cocoapods.UNUMCanvas")
        if let resourcePath = bundle?.path(forResource: "UNUMCanvas", ofType: "bundle") {
            bundle = Bundle(path: resourcePath)!
        }
        let closeImage = UIImage(named: "deleteImageIcon", in: bundle, compatibleWith: nil)
        closeImageView = UIImageView(image: closeImage)
        
        super.init(frame: .zero)

        layoutView(image: image)
    }
    
    private func layoutView(image: UIImage?) {
        if let image = image {
            addToView(image: image)
        }
        
        layer.borderWidth = 4
        layer.borderColor = UIColor.blue.cgColor
        addCloseButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
