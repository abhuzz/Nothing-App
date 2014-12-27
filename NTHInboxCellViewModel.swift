//
//  NTHInboxCellViewModel.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation

class NTHInboxCellViewModel {
    private var _task: Task
    
    init(task: Task) {
        self._task = task
    }
    
    var title: String {
        return self._task.title
    }
    
    var longDescription: String {
        return self._task.longDescription ?? ""
    }
    
    var state: Task.State {
        return self._task.state
    }
}