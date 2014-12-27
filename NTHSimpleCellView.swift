//
//  NTHSimpleCellView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 15/12/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHSimpleCellView: NTHBaseCellView {
    /// outlets
    @IBOutlet internal weak var titleLabel: UILabel!
    @IBOutlet internal weak var detailLabel: UILabel!
    
    override func setupUI() {
        super.setupUI()
        self.titleLabel.textColor = UIColor.NTHCadetGrayColor()
        self.detailLabel.textColor = UIColor.NTHLinkWaterColor()
    }

    override func nibName() -> String {
        return "NTHSimpleCellView"
    }
    
    func setTitle(title: String) {
        self.titleLabel.text = title.uppercaseString
    }
    
    func setDetail(detail: String?) {
        self.detailLabel.text = detail
    }
}
