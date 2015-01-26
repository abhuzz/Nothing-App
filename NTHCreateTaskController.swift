//
//  NTHCreateTaskController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 25/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHCreateTaskController: UIViewController {
    
    @IBOutlet weak var titleTextLabel: LabelContainer!
    @IBOutlet weak var descriptionTextLabel: LabelContainer!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup() {
        let showTextEditor = {(label: LabelContainer) -> () in
            self.performSegueWithIdentifier("ShowTextEditor", sender: label)
        }
        
        titleTextLabel.placeholder = "What's in your mind?"
        titleTextLabel.tapBlock = { [unowned self] in showTextEditor(self.titleTextLabel)}
        
        descriptionTextLabel.placeholder = "Describe this task"
        descriptionTextLabel.tapBlock = { [unowned self] in showTextEditor(self.descriptionTextLabel)}
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowTextEditor") {
            let editor = (segue.destinationViewController as UINavigationController).topViewController as TextEditorController
            editor.title = "Text Editor"

            let label = (sender as LabelContainer)
            editor.text = label.isSet ? label.text : ""
            editor.confirmBlock = { text in
                (sender as LabelContainer).text = text
            }
        }
    }
}
