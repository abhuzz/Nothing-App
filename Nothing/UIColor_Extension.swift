//
//  Colors.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func appGreenColor() -> UIColor {
        return UIColor(red: 106.0/255.0, green: 191.0/255.0, blue: 130.0/255.0, alpha: 1.0)
    }
    
    class func appBlueColor() -> UIColor {
        return UIColor(red: 0, green: 121.0/255.0, blue: 1.0, alpha: 1.0)
    }
    
    class func appBlueColorAlpha50() -> UIColor {
        return UIColor(red: 0, green: 121.0/255.0, blue: 1.0, alpha: 0.5)
    }
    
    class func appRedColor() -> UIColor {
        return UIColor(red: 237.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1.0)
    }
    
    class func appWhite255() -> UIColor {
        return UIColor(white: 255.0, alpha: 1.0)
    }
    
    class func appWhite250() -> UIColor {
        return UIColor(white: 250.0/255.0, alpha: 1.0)
    }
    
    class func appWhite216() -> UIColor {
        return UIColor(white: 216.0/255.0, alpha: 1.0)
    }
    
    class func appWhite186() -> UIColor {
        return UIColor(white: 186.0/255.0, alpha: 1.0)
    }
    
    class func appWhite95() -> UIColor {
        return UIColor(white: 95.0/255.0, alpha: 1.0)
    }
    
    class func appBlack() -> UIColor {
        return UIColor(white: 0, alpha: 1)
    }
}