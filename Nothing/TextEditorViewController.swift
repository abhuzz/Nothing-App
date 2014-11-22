//
//  TextEditorViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 21/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class TextEditorViewController: UIViewController {
    
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var navigationBarHeight: NSLayoutConstraint!
    
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarHeight.constant = 64.0;
        self.textView.contentInset = UIEdgeInsets(top: self.navigationBarHeight.constant, left: 0, bottom: 0, right: 0)
        self.textView.text = self.text
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
