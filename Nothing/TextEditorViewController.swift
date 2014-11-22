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
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var navigationBarHeight: NSLayoutConstraint!
    @IBOutlet private weak var bottomGuide: NSLayoutConstraint!
    
    var text: String?
    var confirmBlock: ConfirmBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarHeight.constant = 64.0;
        
        self.textView.contentInset = UIEdgeInsets(top: self.navigationBarHeight.constant, left: 0, bottom: 0, right: 0)
        self.textView.text = self.text
        
        self.observeKeyboard()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.textView.becomeFirstResponder()
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

    
    @IBAction func closePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onConfirmPressed(sender: AnyObject) {
        self.confirmBlock?(value: self.textView.text)
    }
}
