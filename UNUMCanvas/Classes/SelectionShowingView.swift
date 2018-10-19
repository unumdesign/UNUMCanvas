//
//  SelectionShowingView.swift
//  UNUMCanvas
//
//  Created by Patrick Flanagan on 10/18/18.
//

import Foundation

//protocol SelectionShowingDelegate: AnyObject {
//    func deleteButtonPressed()
//}

final class SelectionShowingView: UIView {

    let button = UIButton()
//    var delegate: SelectionShowingDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 4
        layer.borderColor = UIColor.blue.cgColor

        let bundle = Bundle(identifier: "org.cocoapods.UNUMCanvas")
        let image = UIImage(named: "deleteImageIconMasked", in: bundle, compatibleWith: nil)
        button.setImage(image, for: .normal)

        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    @objc private func deleteButtonPressed() {
//        delegate?.deleteButtonPressed()
//    }
}
