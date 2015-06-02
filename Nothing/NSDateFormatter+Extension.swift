//
//  NSDateFormatter_Extension.swift
//  Nothing
//
//  Created by Tomasz Szulc on 11/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation

extension NSDateFormatter {
    private class var NTHSharedInstance: NSDateFormatter! {
        struct Static {
            static var instance = NSDateFormatter()
        }
        
        return Static.instance
    }
    
    private class var NTHSharedTimeInstance: NSDateFormatter! {
        struct Static {
            static var instance = NSDateFormatter()
        }
        
        return Static.instance
    }
    
    class func NTHStringFromDate(date: NSDate) -> String {
        var instance = NSDateFormatter.NTHSharedInstance
        if instance.dateFormat == "" {
            instance.dateFormat = "dd/MM/yy HH:mm"
        }
        
        return instance.stringFromDate(date)
    }
    
    class func NTHStringTimeFromDate(date: NSDate) -> String {
        var instance = NSDateFormatter.NTHSharedTimeInstance
        if instance.dateFormat == "" {
            instance.dateFormat = "HH:mm"
        }
        
        return instance.stringFromDate(date)
    }
}