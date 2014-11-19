//
//  UIImage_Extension.swift
//  Nothing
//
//  Created by Tomasz Szulc on 19/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

extension UIImage {
    func maskWithColor(color: UIColor) -> UIImage {
        let maskImage = self.CGImage
        let width = self.size.width
        let height = self.size.height
        
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        let bitmapContext = CGBitmapContextCreate(nil, UInt(width), UInt(height), 8, 0, colorSpace, bitmapInfo)
        
        CGContextClipToMask(bitmapContext, bounds, maskImage)
        CGContextSetFillColorWithColor(bitmapContext, color.CGColor)
        CGContextFillRect(bitmapContext, bounds)
        
        let cImage = CGBitmapContextCreateImage(bitmapContext)
        let coloredImage = UIImage(CGImage: cImage)!
        
        return coloredImage
    }
}
