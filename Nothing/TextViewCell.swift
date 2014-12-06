//
//  TextViewCell.swift
//  Nothing
//
//  Created by Tomasz Szulc on 20/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class TextViewCell: UITableViewCell {
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsetsZero
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textView.text = ""
        self.textView.textColor = UIColor.appBlack()
    }
    
    var preferredHeight: CGFloat {
        return self.textView.proposedHeight
    }
    
    func setText(text: String) {
        self.textView.text = text
        self.updateConstraintsIfNeeded()
        self.textView.sizeToFit()
    }
}
