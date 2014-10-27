//
//  FileCache.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation

class FileCache: FileManager {
    
    private func generateKey() -> String {
        return NSUUID().UUIDString
    }
    
    private func generateUniqueKey() -> String {
        let mgr = NSFileManager.defaultManager()
        var key: String!
        
        do {
            key = self.generateKey()
        } while (mgr.fileExistsAtPath(self.pathToFile(key)))
        
        return key
    }
    
    func write(data: NSData) -> (success: Bool, key: String) {
        let key = self.generateUniqueKey()
        return (super.write(data, fileName: key), key)
    }
    
    override func read(key: String) -> NSData? {
        return super.read(key)
    }
}