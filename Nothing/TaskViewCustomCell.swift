//
//  TaskViewCustomCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 06/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class TaskViewCustomCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let view = UIView()
        view.backgroundColor = UIColor.appBlueColorAlpha50()
        self.selectedBackgroundView = view
    }
}
