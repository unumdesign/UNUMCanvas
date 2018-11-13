//
//  SelectionShowingView.swift
//  UNUMCanvas
//
//  Created by Patrick Flanagan on 10/18/18.
//

import Foundation
import Anchorage

final class SelectionShowingView: UIView {

    let closeImage = UIImageView()
    
    init(image: UIImage? = nil) {
        super.init(frame: .zero)

        if let image = image {
            let image = image.imageWithBorder(width: 90, color: .blue)
            let selectedImageView = UIImageView(image: image)
            selectedImageView.clipsToBounds = true
            selectedImageView.contentMode = .scaleAspectFit
            
            addSubview(selectedImageView)
            selectedImageView.topAnchor == self.topAnchor
            selectedImageView.leadingAnchor == self.leadingAnchor
            selectedImageView.sizeAnchors == self.sizeAnchors
        }
        else {
            layer.borderWidth = 4
            layer.borderColor = UIColor.blue.cgColor
        }
    }

//    override init(frame: CGRect) {
//        var bundle = Bundle(identifier: "org.cocoapods.UNUMCanvas")
//        if let resourcePath = bundle?.path(forResource: "UNUMStory", ofType: "bundle") {
//            bundle = Bundle(path: resourcePath)!
//        }
//        
////        let image = UIImage(named: "deleteImageIcon", in: bundle, compatibleWith: nil)
////        closeImage = UIImageView(image: image)
////
//        super.init(frame: frame)
////
////        addSubview(closeImage)
////        closeImage.translatesAutoresizingMaskIntoConstraints = false
////        closeImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
////        closeImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
////        closeImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
////        closeImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
//    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
