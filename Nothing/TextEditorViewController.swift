//
//  TextEditorViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 21/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class TextEditorViewController: UIViewController {
    
    typealias ConfirmBlock = (value: String) -> Void
    
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var bottomGuide: NSLayoutConstraint!
    
    var text: String?
    var confirmBlock: ConfirmBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        
//        self.textView.contentInset = UIEdgeInsets(top: self.navigationController!.navigationBar.bounds.height, left: 0, bottom: 0, right: 0)
        self.textView.text = self.text
        
        self.observeKeyboard()
    }
    
    private func configureNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.Plain, target: self, action: "closePressed")
        self.navigationController?.navigationBar.topItem?.setLeftBarButtonItem(backButton, animated: false)
        
        let saveButton = UIBarButtonItem(image: UIImage(named: "confirm-enabled"), style: UIBarButtonItemStyle.Plain, target: self, action: "onConfirmPressed")
        self.navigationController?.navigationBar.topItem?.setRightBarButtonItem(saveButton, animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.textView.becomeFirstResponder()
        self.navigationController?.navigationBar.topItem?.title = self.title
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.textView.resignFirstResponder()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingKeyboard()
    }
    
    private func observeKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func stopObservingKeyboard() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let info = notification.userInfo {
            let kbFrame = info[UIKeyboardFrameEndUserInfoKey]!.CGRectValue()
            let animDuration = info[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
            
            self.bottomGuide.constant = kbFrame.height
            UIView.animateWithDuration(animDuration, animations: {
                self.textView.layoutIfNeeded()
            })
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let info = notification.userInfo {
            let animDuration = info[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
            self.bottomGuide.constant = 0
            UIView.animateWithDuration(animDuration, animations: {
                self.textView.layoutIfNeeded()
            })
        }
    }

    
    func closePressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onConfirmPressed() {
        self.confirmBlock?(value: self.textView.text)
    }
}
