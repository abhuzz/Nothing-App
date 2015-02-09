//
//  InsertTaskView.swift
//  Nothing
//
//  Created by Tomasz Szulc on 10/11/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit

class QuickInsertView: UIView, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet private weak var moreButtonLeading: NSLayoutConstraint!
    
    private var initialMoreButtonLeadingConstant: CGFloat?
    
    typealias DidSubmitBlock = (text: String) -> Void
    typealias DidTapMoreBlock = () -> Void
    
    var didSubmitBlock: DidSubmitBlock?
    var didTapMoreBlock: DidTapMoreBlock?
    
    var text: String {
        return self.textField.text
    }
    
    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        if self.subviews.count == 0 {
            let nib = UINib(nibName: "QuickInsertView", bundle: NSBundle.mainBundle())
            let view = nib.instantiateWithOwner(nil, options: nil).first! as! QuickInsertView
            view.setTranslatesAutoresizingMaskIntoConstraints(false)
            return view
        }
        
        return self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if (self.initialMoreButtonLeadingConstant == nil) {
            self.initialMoreButtonLeadingConstant = self.moreButtonLeading.constant
        }
        
        self.reset()
    }
    
    @IBAction func onSubmitPressed(sender: AnyObject) {
        self.didSubmitBlock?(text: self.textField.text)
    }
    
    @IBAction func textDidChange(sender: AnyObject) {
        self.updateView()
    }
    
    private func updateView() {
        let enabled = count(self.textField.text) > 0
        self.submitButton.enabled = enabled
        
        enabled ? self.showMoreAnimated(true) : self.hideMoreAnimated(true)
    }
    
    func reset(animated: Bool = false) {
        self.hideMoreAnimated(animated)
        self.textField.text = ""
        self.textField.font = UIFont.NTHQuickInsertTextfieldFont()
        self.textField.textColor = UIColor.NTHLynchColor()
        self.submitButton.titleLabel!.font = UIFont.NTHQuickInsertBoldFont()
        self.submitButton.setTitleColor(UIColor.NTHLinkWaterColor(), forState: .Disabled)
        self.submitButton.setTitleColor(UIColor.NTHMoodyBlueColor(), forState: .Normal)
        self.moreButton.setTitleColor(UIColor.NTHMoodyBlueColor(), forState: .Normal)
        self.updateView()
    }
    
    func finish() {
        self.reset()
        self.textField.resignFirstResponder()
    }
    
    func showMoreAnimated(animated: Bool) {
        self.moreButtonLeading.constant = self.initialMoreButtonLeadingConstant!
        UIView.animateWithDuration(animated ? 0.1 : 0.0, animations: {
            self.moreButton.layoutIfNeeded()
            self.textField.layoutIfNeeded()
        })
    }
    
    func hideMoreAnimated(animated: Bool) {
        self.moreButtonLeading.constant = -self.moreButton.frame.width
        UIView.animateWithDuration(animated ? 0.1 : 0.0, animations: {
            self.moreButton.layoutIfNeeded()
            self.textField.layoutIfNeeded()
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if count(self.textField.text) > 0 {
            self.didSubmitBlock?(text: self.textField.text)
        }
        
        self.textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onMorePressed(sender: AnyObject) {
        self.didTapMoreBlock?()
    }
}
