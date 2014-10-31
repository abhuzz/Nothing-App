//
//  ThumbnailCache.swift
//  Nothing
//
//  Created by Tomasz Szulc on 31/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation

class ThumbnailCache: FileCache {
    class var sharedInstance: ThumbnailCache! {
        struct Static {
            static var instance = ThumbnailCache(path: NSTemporaryDirectory().stringByAppendingPathComponent("thumbnails"))
        }
        
        return Static.instance
    }
}
