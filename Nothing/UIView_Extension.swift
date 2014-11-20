//
//  UIView_E.swift
//  Nothing
//
//  Created by Tomasz Szulc on 03/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

extension UIView {
    func animatePushViewInside() {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = 10
        animation.toValue = 0
        animation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
        animation.toValue = NSValue(CATransform3D: CATransform3DMakeScale(0.95, 0.95, 1.0))
        animation.duration = 0.15
        animation.autoreverses = true
        self.layer.addAnimation(animation, forKey: nil)
    }
}