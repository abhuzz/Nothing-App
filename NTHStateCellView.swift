//
//  NTHStateCellView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 16/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHStateCellView: NTHSimpleCellView {
    /// views
    @IBOutlet weak var statusView: NTHTaskStatusView!
    
    override func nibName() -> String {
        return "NTHStateCellView"
    }
}
