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
        return self.task.longDescription ?? ""
    }
}