//
//  NTHCreatePlaceViewController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData

class NTHCreatePlaceViewController: UIViewController {

    @IBOutlet weak var originalNameLabel: LabelContainer!
    @IBOutlet weak var customNameLabel: LabelContainer!
    
    var annotation: NTHAnnotation!
    
    enum SegueIdentifier: String {
        case TextEditor = "TextEditor"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.originalNameLabel.isSet = true
        self.originalNameLabel.text = self.annotation.title
        self.originalNameLabel.enabled = false
        
        self.customNameLabel.isSet = false
        self.customNameLabel.placeholder = self.originalNameLabel.text!
        self.customNameLabel.text = self.originalNameLabel.text
        self.customNameLabel.tapBlock = { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.TextEditor.rawValue, sender: self.customNameLabel)
        }
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        let context = CDHelper.mainContext
        
        let place: Place = Place.create(CDHelper.mainContext)
        place.coordinate = self.annotation.coordinate
        place.originalName = self.annotation.title
        place.customName = self.customNameLabel.text!
        place.thumbnailKey = "DUMMY_KEY"
        
        CDHelper.mainContext.save(nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == SegueIdentifier.TextEditor.rawValue) {
            let editorVC = (segue.destinationViewController as UINavigationController).topViewController as NTHTextEditorViewController
            editorVC.text = self.customNameLabel.text
            editorVC.confirmBlock = { text in
                (sender as LabelContainer).text = text
            }
        }
    }
}
