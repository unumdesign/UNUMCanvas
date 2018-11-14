import UIKit
import Anchorage


// TODO: plf - see about making this functionality part of how the canvas works rather than needing it here.
public extension UIView {
    public func removeCanvasSupportingViews() {
        self.subviews.forEach { view in
            view.removeCanvasSupportingViews()
        }
        
        if self is CenterYIndicatingView || self is CenterXIndicatingView {
            self.removeFromSuperview()
        }
    }
}

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
        
        indicatorOne.backgroundColor = .black
        indicatorTwo.backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CenterYIndicatingView: CenterIndicatingView {

    override init() {
        super.init()
        
        indicatorOne.centerYAnchor == centerYAnchor
        indicatorOne.heightAnchor == indicatorThickness
        indicatorOne.widthAnchor == widthAnchor * indicatorLengthMultiplier
        indicatorOne.leadingAnchor == leadingAnchor
        
        indicatorTwo.centerYAnchor == centerYAnchor
        indicatorTwo.heightAnchor == indicatorThickness
        indicatorTwo.widthAnchor == widthAnchor * indicatorLengthMultiplier
        indicatorTwo.trailingAnchor == trailingAnchor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CenterXIndicatingView: CenterIndicatingView {
    
    override init() {
        super.init()
        
        indicatorOne.centerXAnchor == centerXAnchor
        indicatorOne.widthAnchor == indicatorThickness
        indicatorOne.heightAnchor == heightAnchor * indicatorLengthMultiplier
        indicatorOne.topAnchor == topAnchor
        
        indicatorTwo.centerXAnchor == centerXAnchor
        indicatorTwo.widthAnchor == indicatorThickness
        indicatorTwo.heightAnchor == heightAnchor * indicatorLengthMultiplier
        indicatorTwo.bottomAnchor == bottomAnchor
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
        view.edgeAnchors == properViewForSubviews.edgeAnchors
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
