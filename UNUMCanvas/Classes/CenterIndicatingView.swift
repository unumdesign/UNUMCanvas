import UIKit

class CenterIndicatingView: UIView {
    let indicatorOne = UIView()
    let indicatorTwo = UIView()
    
    let indicatorThickness: CGFloat = 3
    
    var isVisible: Bool = true {
        didSet {
            indicatorOne.alpha = isVisible ? 1.0 : 0.0
            indicatorTwo.alpha = isVisible ? 1.0 : 0.0
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        addSubview(indicatorOne)
        addSubview(indicatorTwo)
        
        indicatorOne.translatesAutoresizingMaskIntoConstraints = false
        indicatorOne.backgroundColor = .black
        
        indicatorTwo.translatesAutoresizingMaskIntoConstraints = false
        indicatorTwo.backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CenterYIndicatingView: CenterIndicatingView {

    override init() {
        super.init()
        
        indicatorOne.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicatorOne.heightAnchor.constraint(equalToConstant: indicatorThickness).isActive = true
        indicatorOne.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        indicatorOne.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        indicatorTwo.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicatorTwo.heightAnchor.constraint(equalToConstant: indicatorThickness).isActive = true
        indicatorTwo.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        indicatorTwo.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CenterXIndicatingView: CenterIndicatingView {
    
    override init() {
        super.init()
        
        indicatorOne.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicatorOne.widthAnchor.constraint(equalToConstant: indicatorThickness).isActive = true
        indicatorOne.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
        indicatorOne.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        indicatorTwo.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicatorTwo.widthAnchor.constraint(equalToConstant: indicatorThickness).isActive = true
        indicatorTwo.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
        indicatorTwo.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    
    private var properViewForSubviews: UIView {
        if let view = self as? UITableViewCell {
            return view.contentView
        }
        else if let view = self as? UICollectionViewCell {
            return view.contentView
        }
        else {
            return self
        }
    }
    
    func showCenterXIndication() {
        var xIndicatingView: CenterXIndicatingView?
        
        for subview in subviews where subview.isKind(of: CenterXIndicatingView.classForCoder()) {
            guard let subview = subview as? CenterXIndicatingView else {
                continue
            }
            
            if xIndicatingView == nil {
                xIndicatingView = subview
            }
            else {
                subview.removeFromSuperview()
            }
        }
        xIndicatingView?.isVisible = true
        
        if xIndicatingView == nil {
            let newXIndicatingView = CenterXIndicatingView()
            newXIndicatingView.isUserInteractionEnabled = false
            
            properViewForSubviews.addSubview(newXIndicatingView)
            newXIndicatingView.translatesAutoresizingMaskIntoConstraints = false
            newXIndicatingView.topAnchor.constraint(equalTo: properViewForSubviews.topAnchor).isActive = true
            newXIndicatingView.leadingAnchor.constraint(equalTo: properViewForSubviews.leadingAnchor).isActive = true
            newXIndicatingView.trailingAnchor.constraint(equalTo: properViewForSubviews.trailingAnchor).isActive = true
            newXIndicatingView.bottomAnchor.constraint(equalTo: properViewForSubviews.bottomAnchor).isActive = true
        }
    }
    
    func hideCenterXIndication() {
        for subview in properViewForSubviews.subviews {
            if let centerXIndicatingView = subview as? CenterXIndicatingView {
                centerXIndicatingView.isVisible = false
            }
        }
    }
    
    func showCenterYIndication() {
        var yIndicatingView: CenterYIndicatingView?
        
        for subview in subviews where subview.isKind(of: CenterYIndicatingView.classForCoder()) {
            guard let subview = subview as? CenterYIndicatingView else {
                continue
            }
            
            if yIndicatingView == nil {
                yIndicatingView = subview
            }
            else {
                subview.removeFromSuperview()
            }
        }
        yIndicatingView?.isVisible = true
        
        if yIndicatingView == nil {
            let newYIndicatingView = CenterYIndicatingView()
            newYIndicatingView.isUserInteractionEnabled = false
            
            properViewForSubviews.addSubview(newYIndicatingView)
            newYIndicatingView.translatesAutoresizingMaskIntoConstraints = false
            newYIndicatingView.topAnchor.constraint(equalTo: properViewForSubviews.topAnchor).isActive = true
            newYIndicatingView.leadingAnchor.constraint(equalTo: properViewForSubviews.leadingAnchor).isActive = true
            newYIndicatingView.trailingAnchor.constraint(equalTo: properViewForSubviews.trailingAnchor).isActive = true
            newYIndicatingView.bottomAnchor.constraint(equalTo: properViewForSubviews.bottomAnchor).isActive = true
        }
    }
    
    func hideCenterYIndication() {
        for subview in properViewForSubviews.subviews {
            if let centerYIndicatingView = subview as? CenterYIndicatingView {
                centerYIndicatingView.isVisible = false
            }
        }
    }
}
