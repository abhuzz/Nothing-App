//
//  NTHContactCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 01/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHLeftLabelRemoveCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    var clearPressedBlock: ((cell: UITableViewCell) -> Void)?
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    class func create(tableView: UITableView, title: String) -> NTHLeftLabelRemoveCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NTHLeftLabelRemoveCell") as! NTHLeftLabelRemoveCell
        cell.label.font = UIFont.NTHNormalTextFont()
        cell.label.text = title
        cell.selectedBackgroundView = UIView()
        return cell
    }
    
    @IBAction func clearPressed(sender: AnyObject) {
        self.clearPressedBlock?(cell: self)
    }
}
