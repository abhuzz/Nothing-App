//
//  NTHTaskStatusView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 08/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHTaskStatusView: UIView {
    
    var status: Task.State = .Active {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(frame: CGRect) {
        super.drawRect(frame)
        self.backgroundColor = UIColor.clearColor()
        
        let circleLayer = CAShapeLayer()
        let path = UIBezierPath(ovalInRect: self.bounds)
        circleLayer.path = path.CGPath
        
        if self.status == .Done {
            circleLayer.fillColor = UIColor.NTHYellowGreenColor().CGColor
        } else {
            circleLayer.fillColor = UIColor.clearColor().CGColor
            circleLayer.strokeColor = UIColor.NTHWhiteLilacColor().CGColor
            circleLayer.borderWidth = 1.0
        }

        self.layer.addSublayer(circleLayer)
    }
}
