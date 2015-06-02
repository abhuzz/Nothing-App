//
//  Cache.swift
//  CoreDataDemo
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation

class FileManager {
    let path: String
    
    init(path: String) {
        self.path = path
        println("File manager created with path: \(path)")
        self.prepare()
    }
    
    private func prepare() {
        let fileManager = NSFileManager.defaultManager()
        var isDirectory: ObjCBool = false
        var exists = fileManager.fileExistsAtPath(self.path, isDirectory: &isDirectory)
        
        if exists && isDirectory {
            return
        } else if exists && !isDirectory {
            println("File at path \(self.path) already exists and it is not a directory")
        } else if !exists {
            var error: NSError?
            if !fileManager.createDirectoryAtPath(self.path, withIntermediateDirectories: true, attributes: nil, error: &error) {
                println("Cannot create directory at path \(self.path). Error = \(error?.localizedDescription)")
            }
        }
    }
    
    func pathToFile(key: String) -> String {
        return self.path.stringByAppendingPathComponent(key)
    }
    
    // write data on disk, return key
    func write(data: NSData, fileName: String) -> Bool {
        return data.writeToFile(self.pathToFile(fileName), atomically: true)
    }
    
    /// read data from this, return data or nil
    func read(fileName: String) -> NSData? {
        return NSData(contentsOfFile: self.pathToFile(fileName))
    }
}