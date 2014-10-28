//
//  TaskCellVMCache.swift
//  Nothing
//
//  Created by Tomasz Szulc on 28/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation

class TaskCellVMCache {
    private var cache = [TaskCellVM]()
    
    func add(model: TaskCellVM) {
        if let index = find(self.cache, model) {
            self.cache[index] = model
        } else {
            self.cache.append(model)
        }
    }
    
    func model(task: Task) -> TaskCellVM? {
        for model in self.cache {
            if (model.task == task) {
                return model
            }
        }
        
        return nil
    }
}