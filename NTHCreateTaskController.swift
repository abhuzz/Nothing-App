//
//  NTHCreateTaskController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 25/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHCreateTaskController: UIViewController {
    
    @IBOutlet weak var titleTextLabel: Label!
    @IBOutlet weak var descriptionTextLabel: Label!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup() {
        let showTextEditor = {(label: Label) -> () in
            self.performSegueWithIdentifier("ShowTextEditor", sender: label)
        }
        
        titleTextLabel.tapBlock = { [unowned self] in showTextEditor(self.titleTextLabel)}
        descriptionTextLabel.tapBlock = { [unowned self] in showTextEditor(self.descriptionTextLabel)}
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowTextEditor") {
            let editor = (segue.destinationViewController as UINavigationController).topViewController as TextEditorController
            editor.text = (sender as Label).text
            editor.title = "Text Editor"
            editor.confirmBlock = { text in
                (sender as Label).text = text
            }
        }
    }
}
