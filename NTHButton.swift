//
//  NTHButton.swift
//  Nothing
//
//  Created by Tomasz Szulc on 21/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHButton: UIButton {
    
    @IBInspectable var normalBorderColor: UIColor! = UIColor.NTHNavigationBarColor()
    @IBInspectable var normalBackgroundColor: UIColor! = UIColor.clearColor()
    @IBInspectable var normalTitleColor: UIColor! = UIColor.NTHNavigationBarColor()
    
    @IBInspectable var pressedBorderColor: UIColor! = UIColor.NTHNavigationBarColor()
    @IBInspectable var pressedBackgroundColor: UIColor! = UIColor.NTHNavigationBarColor()
    @IBInspectable var pressedTitleColor: UIColor! = UIColor.whiteColor()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1
        self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2.0
        
        self._styleToNormalState(false)
    }
    
    override func sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
        
        func animate(animations: (() -> Void), completion: (() -> Void)) {
            
            UIView.animateWithDuration(NSTimeInterval(0.2), animations: { () -> Void in
                animations()
            }) { (finished) -> Void in
                completion()
            }
        }
        
        
        if event == nil {
            super.sendAction(action, to: target, forEvent: event)
            return
        }
        
        let touch = (event!.touchesForView(self) as NSSet!).anyObject() as! UITouch
        if touch.phase != .Ended {
            super.sendAction(action, to: target, forEvent: event)
            return
        }
        
        animate({ () -> Void in
            self._styleToPressedState(true)
        }, { () -> Void in
            animate({ () -> Void in
                self._styleToNormalState(true)
            }, { () -> Void in
                self._super_sendAction(action, to: target, forEvent: event)
            })
        })
    }
    
    private func _super_sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
        super.sendAction(action, to: target, forEvent: event)
    }
    
    private func _styleToPressedState(animated: Bool) {
        self._styleButton(self.pressedTitleColor, backgroundColor: self.pressedBackgroundColor, borderColor: self.pressedBorderColor, animated: animated)
    }
    
    private func _styleToNormalState(animated: Bool) {
        self._styleButton(self.normalTitleColor, backgroundColor: self.normalBackgroundColor, borderColor: self.normalBorderColor, animated: animated)
    }
    
    private func _styleButton(titleColor: UIColor, backgroundColor: UIColor, borderColor: UIColor, animated: Bool) {
        if self.layer.borderWidth >= 1.0 {
            if animated {
                let animation = CABasicAnimation(keyPath: "borderColor")
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                animation.fromValue = self.layer.borderColor
                animation.toValue = borderColor.CGColor
                animation.duration = 0.1
                
                self.layer.addAnimation(animation, forKey: "borderColor")
                
                self.layer.borderColor = borderColor.CGColor
                self.backgroundColor = backgroundColor
            } else {
                self.layer.borderColor = borderColor.CGColor
                self.backgroundColor = backgroundColor
            }
        }
        
        self.setTitleColor(titleColor, forState: UIControlState.Normal)
        self.setTitleColor(titleColor, forState: UIControlState.Highlighted)
        self.setTitleColor(titleColor, forState: UIControlState.Selected)
    }
}
