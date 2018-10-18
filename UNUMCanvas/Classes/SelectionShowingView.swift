//
//  SelectionShowingView.swift
//  UNUMCanvas
//
//  Created by Patrick Flanagan on 10/18/18.
//

import Foundation

final class SelectionShowingView: UIView {

//    private let imageView = UIImageView(image: UIImage(named: "deleteIcon"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 4
        layer.borderColor = UIColor.blue.cgColor

//        addSubview(imageView)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
//        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
