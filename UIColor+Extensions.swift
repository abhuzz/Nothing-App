//
//  NTHColors.swift
//  Nothing
//
//  Created by Tomasz Szulc on 07/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

extension UIColor {
//    class func NTHMoodyBlueColor() -> UIColor {
//        return UIColor(red:0.48, green:0.47, blue:0.79, alpha:1)
//    }
//    
//

//    
//    class func NTHWhiteSmokeColor() -> UIColor {
//        return UIColor(red:0.96, green:0.96, blue:0.96, alpha:1)
//    }
//    
//    class func NTHWhiteColor() -> UIColor {
//        return UIColor(red:1, green:1, blue:1, alpha:1)
//    }
//    
//

//    

    
//    private class func NTH_LynchColor() -> UIColor {
//        return UIColor(red:0.41, green:0.47, blue:0.53, alpha:1)
//    }
}

extension UIColor {
    
    class func NTHNavigationBarColor() -> UIColor { return NTH_BrownColor() }
    class func NTHAppBackgroundColor() -> UIColor { return NTH_WhiteColor() }
    class func NTHTableViewSeparatorColor() -> UIColor { return NTH_WhiteLilacColor() }
    class func NTHHeaderTextColor() -> UIColor { return NTH_CadetGrayColor() }
    class func NTHSubtitleTextColor() -> UIColor { return NTH_LinkWaterColor() }
    class func NTHPlaceholderTextColor() -> UIColor { return NTH_LavenderGrayColor() }
    
    class func NTHStatusDoneColor() -> UIColor { return NTH_YellowGreenColor() }
    class func NTHStatusActiveColor() -> UIColor { return NTH_WhiteLilacColor() }

    /// Palette
    
    private class func NTH_WhiteColor() -> UIColor {
        return UIColor(red:1, green:1, blue:1, alpha:1)
    }
    
    private class func NTH_BrownColor() -> UIColor {
        return UIColor(red:0.75, green:0.43, blue:0.33, alpha:1)
    }
    
    private class func NTH_BlueBayoux() -> UIColor {
        return UIColor(red:0.31, green:0.39, blue:0.46, alpha:1)
    }
    
    private class func NTH_WhiteLilacColor() -> UIColor {
        return UIColor(red:0.9, green:0.9, blue:0.9, alpha:1)
    }

    private class func NTH_YellowGreenColor() -> UIColor {
        return UIColor(red:0.48, green:0.82, blue:0.22, alpha:1)
    }

    private class func NTH_CadetGrayColor() -> UIColor {
        return UIColor(red:0.49, green:0.54, blue:0.61, alpha:1)
    }
    
    class func NTH_LinkWaterColor() -> UIColor {
        return UIColor(red:0.68, green:0.73, blue:0.79, alpha:1)
    }
    
    class func NTH_LavenderGrayColor() -> UIColor {
        return UIColor(red:0.78, green:0.78, blue:0.8, alpha:1)
    }
}