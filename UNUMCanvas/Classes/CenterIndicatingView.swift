import UIKit

class CenterIndicatingView: UIView {
    let indicatorOne = UIView()
    let indicatorTwo = UIView()
    
    let indicatorThickness: CGFloat = 3
    let indicatorLengthMultiplier: CGFloat = 0.25
    
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
        indicatorOne.widthAnchor.constraint(equalTo: widthAnchor, multiplier: indicatorLengthMultiplier).isActive = true
        indicatorOne.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        indicatorTwo.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicatorTwo.heightAnchor.constraint(equalToConstant: indicatorThickness).isActive = true
        indicatorTwo.widthAnchor.constraint(equalTo: widthAnchor, multiplier: indicatorLengthMultiplier).isActive = true
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
        indicatorOne.heightAnchor.constraint(equalTo: heightAnchor, multiplier: indicatorLengthMultiplier).isActive = true
        indicatorOne.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        indicatorTwo.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicatorTwo.widthAnchor.constraint(equalToConstant: indicatorThickness).isActive = true
        indicatorTwo.heightAnchor.constraint(equalTo: heightAnchor, multiplier: indicatorLengthMultiplier).isActive = true
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
    
    private func addIndicatorSubview(view: UIView) {
        view.isUserInteractionEnabled = false
        
        properViewForSubviews.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: properViewForSubviews.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: properViewForSubviews.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: properViewForSubviews.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: properViewForSubviews.bottomAnchor).isActive = true
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
            addIndicatorSubview(view: newXIndicatingView)
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
            addIndicatorSubview(view: newYIndicatingView)
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
