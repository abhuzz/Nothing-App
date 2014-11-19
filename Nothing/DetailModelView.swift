//
//  DetailModelView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 16/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation

class DetailModelView {
    let task: Task
    
    init(_ task: Task) {
        self.task = task
    }

    var title : String {
        return self.task.title
    }
    
    var longDescription : String {
        return self.task.longDescription ?? "No description"
    }
    
    var isDescription : Bool {
        if let value = self.task.longDescription {
            return countElements(value) > 0
        }
        return false
    }
}