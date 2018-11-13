//
//  SelectionShowingView.swift
//  UNUMCanvas
//
//  Created by Patrick Flanagan on 10/18/18.
//

import Foundation

final class SelectionShowingView: UIView {

    let closeImage: UIImageView

    override init(frame: CGRect) {
        var bundle = Bundle(identifier: "org.cocoapods.UNUMCanvas")
        if let resourcePath = bundle?.path(forResource: "UNUMStory", ofType: "bundle") {
            bundle = Bundle(path: resourcePath)!
        }
        
        let image = UIImage(named: "deleteImageIcon", in: bundle, compatibleWith: nil)
        closeImage = UIImageView(image: image)

        super.init(frame: frame)
        layer.borderWidth = 4
        layer.borderColor = UIColor.blue.cgColor

        addSubview(closeImage)
        closeImage.translatesAutoresizingMaskIntoConstraints = false
        closeImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        closeImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        closeImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
