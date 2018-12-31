//
//  SelectionShowingView.swift
//  UNUMCanvas
//
//  Created by Patrick Flanagan on 10/18/18.
//

import Foundation
import Anchorage

public final class SelectionShowingView: UIView {

    let closeImageView: UIImageView
    
    private func addCloseButton() {
        addSubview(closeImageView)
        closeImageView.sizeAnchors == CGSize(width: 40, height: 40)
        closeImageView.topAnchor == topAnchor + 5
        closeImageView.trailingAnchor == trailingAnchor - 5
    }
    
    init() {
        var bundle = Bundle(for: SelectionShowingView.self)
        if let resourcePath = bundle.path(forResource: "UNUMCanvas", ofType: "bundle") {
            if let resourcesBundle = Bundle(path: resourcePath) {
                bundle = resourcesBundle
            }
        }
        let closeImage = UIImage(named: "deleteImageIcon", in: bundle, compatibleWith: nil)
        closeImageView = UIImageView(image: closeImage)
        
        super.init(frame: .zero)

        layoutView()
    }
    
    private func layoutView() {
        layer.borderWidth = 4
        layer.borderColor = UIColor.blue.cgColor
        addCloseButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
