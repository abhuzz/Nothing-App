//
//  NTHFonts.swift
//  Nothing
//
//  Created by Tomasz Szulc on 07/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

extension UIFont {
    
    /**
        Font names
    */
    
    private class func NTHRegularFontName() -> String {
        return "HelveticaNeue"
    }
    
    private class func NTHLightFontName() -> String {
        return "HelveticaNeue-Light"
    }
    
    private class func NTHMediumFontName() -> String {
        return "HelveticaNeue-Medium"
    }
    
    /**
        Fonts
    */
    
    class func NTHInboxCellTitleFont() -> UIFont {
        return UIFont(name: NTHRegularFontName(), size: 16)!
    }
    
    class func NTHInboxCellDescriptionFont() -> UIFont {
        return UIFont(name: NTHLightFontName(), size: 12)!
    }
    
    class func NTHNavigationBarTitleFont() -> UIFont {
        return UIFont(name: NTHLightFontName(), size: 17)!
    }
}