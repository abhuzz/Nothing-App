//
//  NTHCreateTaskController.swift
//  Nothing
//
//  Created by Tomasz Szulc on 25/01/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class NTHCreateTaskController: UIViewController {

    class TaskInfo {
        class Region {
            var distance: Float = 100
            var onArrive: Bool = true
        }
        
        var place: Place?
        var region = Region()
    }
    
    enum SegueIdentifier: String {
        case TextEditor = "TextEditor"
        case Places = "Places"
        case Region = "Region"
    }
    
    @IBOutlet weak var titleTextLabel: LabelContainer!
    @IBOutlet weak var descriptionTextLabel: LabelContainer!
    @IBOutlet weak var locationLabel: LabelContainer!
    @IBOutlet weak var regionLabel: LabelContainer!
    
    private var taskInfo = TaskInfo()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup() {
        let showTextEditor = {(label: LabelContainer) -> () in
            self.performSegueWithIdentifier(SegueIdentifier.TextEditor.rawValue, sender: label)
        }
        
        self.titleTextLabel.placeholder = "What's in your mind?"
        self.titleTextLabel.tapBlock = { [unowned self] in
            showTextEditor(self.titleTextLabel)
        }
        
        self.descriptionTextLabel.placeholder = "Describe this task"
        self.descriptionTextLabel.tapBlock = { [unowned self] in
            showTextEditor(self.descriptionTextLabel)
        }
        
        self.locationLabel.placeholder = "None"
        self.locationLabel.tapBlock = { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.Places.rawValue, sender: self.locationLabel)
        }
        
        self.regionLabel.placeholder = "None"
        self.regionLabel.enabled = false
        self.regionLabel.tapBlock = { [unowned self] in
            self.performSegueWithIdentifier(SegueIdentifier.Region.rawValue, sender: self.regionLabel)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == SegueIdentifier.TextEditor.rawValue) {
            let editorVC = (segue.destinationViewController as UINavigationController).topViewController as TextEditorController
            editorVC.title = "Text Editor"

            let label = (sender as LabelContainer)
            editorVC.text = label.isSet ? label.text : ""
            editorVC.confirmBlock = { text in
                (sender as LabelContainer).text = text
            }
        } else if (segue.identifier == SegueIdentifier.Places.rawValue) {
            let placesVC = (segue.destinationViewController as UINavigationController).topViewController as NTHSelectPlaceTableViewController
            placesVC.selectionBlock = { [unowned self] (place: Place) in
                self.taskInfo.place = place
                self.locationLabel.text = place.customName
                self.regionLabel.enabled = true
            }
        } else if (segue.identifier == SegueIdentifier.Region.rawValue) {
            let regionVC = segue.destinationViewController as NTHRegionViewController
            regionVC.successBlock = { (distance: Float, onArrive: Bool) in
                let label = (sender as LabelContainer)
                label.text = (onArrive ? "Arrive" : "Leave") + ", " + distance.distanceDescription()
                
                self.taskInfo.region.distance = distance
                self.taskInfo.region.onArrive = onArrive
            }
        }
    }
}
