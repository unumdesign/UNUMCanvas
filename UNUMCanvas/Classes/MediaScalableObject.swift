//
//  StoryImageContainer.swift
//  StoryTest
//
//  Created by Li Zhao on 6/21/18.
//  Copyright © 2018 LiZhao. All rights reserved.
//

import Foundation

public class MediaScalableObject {
    
    //subclassable view
    public var scalableView: UIView!
    
    //Current constraints
    var topConstraint: NSLayoutConstraint?
    var trailingConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    
    //Previous constraints
    var previousTopConstraingValue:CGFloat = 0.0
    var previousTrailingConstraintValue:CGFloat = 0.0
    var previousLeadingConstraintValue:CGFloat = 0.0
    var previousBottomConstraintValue:CGFloat = 0.0
    
    //edges' gestures
    var topGesture: UIPanGestureRecognizer!
    var bottomGesture: UIPanGestureRecognizer!
    var leftGesture: UIPanGestureRecognizer!
    var rightGesture: UIPanGestureRecognizer!
    var topLeftGesture: UIPanGestureRecognizer!
    var topRightGesture: UIPanGestureRecognizer!
    var bottomLeftGesture: UIPanGestureRecognizer!
    var bottomRightGesture: UIPanGestureRecognizer!
    
    //Direction lockers, if false, cannot squeeze scalable view in that direction
    var isHorizontalMoveable = false
    var isVerticalMoveable = false
    var isZoomable = false
    var isMoveable = false
    
    //Points of reference for superview
    var topPoint: CGPoint?
    var bottomPoint: CGPoint?
    
    public var isEditing: Bool = false {
        didSet {
            
            //show or hide scalable view's border when is editing value changes
            self.scalableView.layer.borderColor = UIColor.black.cgColor
            self.scalableView.layer.borderWidth = isEditing ? 1 : 0
            
            //enable or disable edge gestures when is editing value changes
            topGesture.isEnabled = isEditing
            bottomGesture.isEnabled = isEditing
            leftGesture.isEnabled = isEditing
            rightGesture.isEnabled = isEditing
            topLeftGesture.isEnabled = isEditing
            topRightGesture.isEnabled = isEditing
            bottomLeftGesture.isEnabled = isEditing
            bottomRightGesture.isEnabled = isEditing
        }
    }
    
    //Initialization
    public init(scalableView: UIView, testModel: Bool = false){
        self.scalableView = scalableView
        scalableView.isUserInteractionEnabled = true
        self.setupEdgesGestures(testModel: testModel)
    }
    
    //setup initial constraint
    func attachConstraintsToSuperview() {
        if scalableView.superview == nil {
            print("attach a view first")
            return
        }
        
        self.scalableView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = self.scalableView.pinToTopOfSuperviewWithConstraint()
        trailingConstraint = self.scalableView.pinToRightOfSuperviewWithConstraint()
        leadingConstraint = self.scalableView.pinToLeftOfSuperviewWithConstraint()
        bottomConstraint = self.scalableView.pinToBottomOfSuperviewWithConstraint()
    }
    
    func updatePreviousConstraintValue(){
        
        self.previousTrailingConstraintValue = self.trailingConstraint?.constant ?? 0.0
        self.previousLeadingConstraintValue = self.leadingConstraint?.constant ?? 0.0
        
        self.previousTopConstraingValue = self.topConstraint?.constant ?? 0.0
        self.previousBottomConstraintValue = self.bottomConstraint?.constant ?? 0.0
    }
    
    /*---------------------------------------
     views and gestures for edge touches
     ---------------------------------------*/
    func setupEdgesGestures(testModel: Bool) {
        
        var viewColor = UIColor.clear
        
        if testModel {
            viewColor = .yellow
        }
        
        //initail corner gestures
        self.topLeftGesture = UIPanGestureRecognizer(target: self, action: #selector(moveTopLeftEdge(_:)))
        self.bottomLeftGesture = UIPanGestureRecognizer(target: self, action: #selector(moveBottomLeftEdge(_:)))
        self.topRightGesture = UIPanGestureRecognizer(target: self, action: #selector(moveTopRightEdge(_:)))
        self.bottomRightGesture = UIPanGestureRecognizer(target: self, action: #selector(moveBottomRightEdge(_:)))
        
        
        //initail edge gestures
        self.topGesture = UIPanGestureRecognizer(target: self, action: #selector(moveTopEdge(_:)))
        self.bottomGesture = UIPanGestureRecognizer(target: self, action: #selector(moveBottomEdge(_:)))
        self.leftGesture = UIPanGestureRecognizer(target: self, action: #selector(moveLeftEdge(_:)))
        self.rightGesture = UIPanGestureRecognizer(target: self, action: #selector(moveRightEdge(_:)))
        
        //setup views one view's edges to hold gestures
        let topGestureView = UIView(frame: .zero)
        topGestureView.tag = 88
        self.scalableView.addSubview(topGestureView)
        topGestureView.translatesAutoresizingMaskIntoConstraints = false
        _ = topGestureView.pinToTopOfSuperviewWithConstraint(constant: -10)
        _ = topGestureView.pinToLeftOfSuperviewWithConstraint(constant: 10)
        _ = topGestureView.pinToRightOfSuperviewWithConstraint(constant: -10)
        _ = topGestureView.forceHeightConstraint(height: 20)
        topGestureView.backgroundColor = viewColor
        
        let leftGestureView = UIView(frame: .zero)
        leftGestureView.tag = 88
        self.scalableView.addSubview(leftGestureView)
        _ = leftGestureView.translatesAutoresizingMaskIntoConstraints = false
        _ = leftGestureView.pinToTopOfSuperviewWithConstraint(constant: 10)
        _ = leftGestureView.pinToLeftOfSuperviewWithConstraint(constant: -10)
        _ = leftGestureView.pinToBottomOfSuperviewWithConstraint(constant: -10)
        _ = leftGestureView.forceWidthConstraint(width: 20)
        leftGestureView.backgroundColor = viewColor
        
        let rightGestureView = UIView(frame: .zero)
        rightGestureView.tag = 88
        self.scalableView.addSubview(rightGestureView)
        _ = rightGestureView.translatesAutoresizingMaskIntoConstraints = false
        _ = rightGestureView.pinToTopOfSuperviewWithConstraint(constant: 10)
        _ = rightGestureView.pinToRightOfSuperviewWithConstraint(constant: 10)
        _ = rightGestureView.pinToBottomOfSuperviewWithConstraint(constant: -10)
        _ = rightGestureView.forceWidthConstraint(width: 20)
        rightGestureView.backgroundColor = viewColor
        
        let bottomGestureView = UIView(frame: .zero)
        bottomGestureView.tag = 88
        scalableView.addSubview(bottomGestureView)
        bottomGestureView.translatesAutoresizingMaskIntoConstraints = false
        _ = bottomGestureView.pinToBottomOfSuperviewWithConstraint(constant: 10)
        _ = bottomGestureView.pinToLeftOfSuperviewWithConstraint(constant: 10)
        _ = bottomGestureView.pinToRightOfSuperviewWithConstraint(constant: -10)
        _ = bottomGestureView.forceHeightConstraint(height: 20)
        bottomGestureView.backgroundColor = viewColor
        
        let topLeftCornerGestureView = UIView(frame: .zero)
        topLeftCornerGestureView.tag = 88
        self.scalableView.addSubview(topLeftCornerGestureView)
        _ = topLeftCornerGestureView.translatesAutoresizingMaskIntoConstraints = false
        _ = topLeftCornerGestureView.pinToTopOfSuperviewWithConstraint(constant: -10)
        _ = topLeftCornerGestureView.pinToLeftOfSuperviewWithConstraint(constant: -10)
        _ = topLeftCornerGestureView.forceWidthConstraint(width: 20)
        _ = topLeftCornerGestureView.forceHeightConstraint(height: 20)
        topLeftCornerGestureView.backgroundColor = viewColor
        
        let toprightCornerGestureView = UIView(frame: .zero)
        toprightCornerGestureView.tag = 88
        self.scalableView.addSubview(toprightCornerGestureView)
        _ = toprightCornerGestureView.translatesAutoresizingMaskIntoConstraints = false
        _ = toprightCornerGestureView.pinToTopOfSuperviewWithConstraint(constant: -10)
        _ = toprightCornerGestureView.pinToRightOfSuperviewWithConstraint(constant: 10)
        _ = toprightCornerGestureView.forceWidthConstraint(width: 20)
        _ = toprightCornerGestureView.forceHeightConstraint(height: 20)
        toprightCornerGestureView.backgroundColor = viewColor
        
        let bottomLeftCornerGestureView = UIView(frame: .zero)
        bottomLeftCornerGestureView.tag = 88
        self.scalableView.addSubview(bottomLeftCornerGestureView)
        _ = bottomLeftCornerGestureView.translatesAutoresizingMaskIntoConstraints = false
        _ = bottomLeftCornerGestureView.pinToBottomOfSuperviewWithConstraint(constant: 10)
        _ = bottomLeftCornerGestureView.pinToLeftOfSuperviewWithConstraint(constant: -10)
        _ = bottomLeftCornerGestureView.forceWidthConstraint(width: 20)
        _ = bottomLeftCornerGestureView.forceHeightConstraint(height: 20)
        bottomLeftCornerGestureView.backgroundColor = viewColor
        
        let bottomRightCornerGestureView = UIView(frame: .zero)
        bottomRightCornerGestureView.tag = 88
        self.scalableView.addSubview(bottomRightCornerGestureView)
        _ = bottomRightCornerGestureView.translatesAutoresizingMaskIntoConstraints = false
        _ = bottomRightCornerGestureView.pinToBottomOfSuperviewWithConstraint(constant: 10)
        _ = bottomRightCornerGestureView.pinToRightOfSuperviewWithConstraint(constant: 10)
        _ = bottomRightCornerGestureView.forceWidthConstraint(width: 20)
        _ = bottomRightCornerGestureView.forceHeightConstraint(height: 20)
        bottomRightCornerGestureView.backgroundColor = viewColor
        
        topLeftCornerGestureView.addGestureRecognizer(topLeftGesture)
        toprightCornerGestureView.addGestureRecognizer(topRightGesture)
        bottomLeftCornerGestureView.addGestureRecognizer(bottomLeftGesture)
        bottomRightCornerGestureView.addGestureRecognizer(bottomRightGesture)
        
        topGestureView.addGestureRecognizer(topGesture)
        bottomGestureView.addGestureRecognizer(bottomGesture)
        leftGestureView.addGestureRecognizer(leftGesture)
        rightGestureView.addGestureRecognizer(rightGesture)
        
    }
    
    /*-----------------------------------
     Pan gesture functions for squeeze scalable view
     ------------------------------------*/
    
    @objc fileprivate func moveTopLeftEdge(_ sender: UIPanGestureRecognizer) {
        
        //check if this direction is locked
        guard isHorizontalMoveable && isVerticalMoveable else {
            return
        }
        print("moving top left edge")
        
        let translation = sender.translation(in: scalableView)
        
        if sender.state == .began {
            
        } else if sender.state == .changed {
            //moving top left corner
            self.topConstraint?.constant = self.previousTopConstraingValue + translation.y
            self.leadingConstraint?.constant = self.previousLeadingConstraintValue + translation.x
        } else if sender.state == .ended {
            
            //update previous constraint value
            updatePreviousConstraintValue()
        }
    }
    
    @objc fileprivate func moveBottomLeftEdge(_ sender: UIPanGestureRecognizer) {
        
        //check if this direction is locked
        guard isHorizontalMoveable && isVerticalMoveable else {
            return
        }
        
        let translation = sender.translation(in: scalableView)
        
        if sender.state == .began {
            
        } else if sender.state == .changed {
            
            //moving bottom left corner
            self.bottomConstraint?.constant = self.previousBottomConstraintValue + translation.y
            self.leadingConstraint?.constant = self.previousLeadingConstraintValue + translation.x
            
        } else if sender.state == .ended {
            
            //update previous constraint value
            updatePreviousConstraintValue()
        }
        
    }
    
    @objc fileprivate func moveTopRightEdge(_ sender: UIPanGestureRecognizer) {
        
        //check if this direction is locked
        guard isHorizontalMoveable && isVerticalMoveable else {
            return
        }
        
        let translation = sender.translation(in: scalableView)
        
        if sender.state == .began {
            
        } else if sender.state == .changed {
            
            //moving top right corner
            self.topConstraint?.constant = self.previousTopConstraingValue + translation.y
            self.trailingConstraint?.constant = self.previousTrailingConstraintValue + translation.x
        } else if sender.state == .ended {
            
            //update previous constraint value
            updatePreviousConstraintValue()
        }
    }
    
    @objc fileprivate func moveBottomRightEdge(_ sender: UIPanGestureRecognizer) {
        
        //check if this direction is locked
        guard isHorizontalMoveable && isVerticalMoveable else {
            return
        }
        
        let translation = sender.translation(in: scalableView)
        
        if sender.state == .began {
            
        } else if sender.state == .changed {
            
            //moving botton right corner
            self.bottomConstraint?.constant = self.previousBottomConstraintValue + translation.y
            self.trailingConstraint?.constant = self.previousTrailingConstraintValue + translation.x
        } else if sender.state == .ended {
            
            //update previous constraint value
            updatePreviousConstraintValue()
        }
    }
    
    @objc fileprivate func moveTopEdge(_ sender: UIPanGestureRecognizer) {
        
        //check if this direction is locked
        guard isVerticalMoveable else {
            return
        }
        
        let translation = sender.translation(in: scalableView)
        
        if sender.state == .began {
            
        } else if sender.state == .changed {
            
            //moving top edge
            self.topConstraint?.constant = self.previousTopConstraingValue + translation.y
        } else if sender.state == .ended {
            //update previous constraint value
            updatePreviousConstraintValue()
        }
    }
    
    @objc fileprivate func moveBottomEdge(_ sender: UIPanGestureRecognizer) {
        
        //check if this direction is locked
        guard isVerticalMoveable else {
            return
        }
        
        let translation = sender.translation(in: scalableView)
        
        if sender.state == .began {
            
        } else if sender.state == .changed {
            
            //moving bottom edge
            self.bottomConstraint?.constant = self.previousBottomConstraintValue + translation.y
        } else if sender.state == .ended {
            
            //update previous constraint value
            updatePreviousConstraintValue()
        }
    }
    
    @objc fileprivate func moveLeftEdge(_ sender: UIPanGestureRecognizer) {
        
        //check if this direction is locked
        guard isHorizontalMoveable else {
            return
        }
        
        let translation = sender.translation(in: scalableView)
        
        if sender.state == .began {
            
        } else if sender.state == .changed {
            
            //moving left edge
            self.leadingConstraint?.constant = self.previousLeadingConstraintValue + translation.x
        } else if sender.state == .ended {
            
            //update previous constraint value
            updatePreviousConstraintValue()
        }
    }
    
    @objc fileprivate func moveRightEdge(_ sender: UIPanGestureRecognizer) {
        
        //check if this direction is locked
        guard isHorizontalMoveable else {
            return
        }
        
        print("moving right edge")
        let translation = sender.translation(in: scalableView)
        
        if sender.state == .began {
            
        } else if sender.state == .changed {
            
            //moving right edge
            self.trailingConstraint?.constant = self.previousTrailingConstraintValue + translation.x
        } else if sender.state == .ended {
            
            //update previous constraint value
            updatePreviousConstraintValue()
        }
    }
}
