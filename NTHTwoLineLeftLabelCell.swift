//
//  NTHTwoLineLeftLabelCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 19/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHTwoLineLeftLabelCell: UITableViewCell {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    class func create(tableView: UITableView, title: String, subtitle: String) -> NTHTwoLineLeftLabelCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NTHTwoLineLeftLabelCell") as! NTHTwoLineLeftLabelCell
        cell.topLabel.font = UIFont.NTHNormalTextFont()
        cell.topLabel.text = title
        
        cell.bottomLabel.font = UIFont.NTHAddNewCellFont()
        cell.bottomLabel.text = subtitle
        cell.selectedBackgroundView = UIView()
        return cell
    }
}
