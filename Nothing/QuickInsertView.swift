//
//  InsertTaskView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 10/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class QuickInsertView: UIView {
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var submitButton: UIButton!

    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        if self.subviews.count == 0 {
            let nib = UINib(nibName: "QuickInsertView", bundle: NSBundle.mainBundle())
            let view = nib.instantiateWithOwner(nil, options: nil).first! as QuickInsertView
            view.setTranslatesAutoresizingMaskIntoConstraints(false)
            return view
        }
        
        return self
    }
    
    @IBAction func onSubmitPressed(sender: AnyObject) {
    }
}
