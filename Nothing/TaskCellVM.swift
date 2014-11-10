//
//  TaskCellViewModel.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

func == (lhs: TaskCellVM, rhs: TaskCellVM) -> Bool {
    return lhs.task == rhs.task
}

class TaskCellVM: Equatable {
    let task: Task
    init (_ task: Task) {
        self.task = task
    }
    
    var title: String { return self.task.title }
    
    var description: NSAttributedString {
        let desc = self.task.longDescription ?? ""
        
        var attributedText = NSMutableAttributedString(string: desc)
        
        let hashtagAttributes = [NSForegroundColorAttributeName: UIColor.appBlueColor()]
        
        self.hashtags = HashtagDetector(desc).detect() as [HashtagDetector.Result]!
        
        self.hashtagsAsString.removeAll(keepCapacity: true)
        for (text, range) in self.hashtags {
            attributedText.addAttributes(hashtagAttributes, range: range)
            self.hashtagsAsString.append(text)
        }
        
        return attributedText
    }
    
    var hashtags: [HashtagDetector.Result] = Array<HashtagDetector.Result>()
    var hashtagsAsString: [String] = [String]()
    
    var datePlaceDescription: String {
        var value = ""
        if let reminder = self.task.dateReminder {
            value += self.dateFormatter.stringFromDate(reminder.fireDate)
        }
        
        if let reminder = self.task.locationReminder {
            if countElements(value) > 0 {
                value += " "
            }
            
            value += "@ \(reminder.place.customName)"
        }
        
        return value
    }
    
    lazy var images: [UIImage] = {
        var images = [UIImage]()
        for connection in self.task.allConnections.allObjects as [Connection] {
            if let key = connection.thumbnailKey {
                if let data = ThumbnailCache.sharedInstance.read(key) {
                    let image = UIImage(data: data)
                    images.append(image!)
                }
            }
        }
        
        return images
    }()
    
    lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMM yyyy hh:mm"
        return formatter
    }()
    
    lazy var titleLabelAttributes: UILabel.Attributes = {
        let attr = UILabel.Attributes()
        attr.font = UIFont(name: "HelveticaNeue-Medium", size: 17.0)!
        attr.textColor = UIColor.appBlack()
        return attr
    }()
    
    lazy var descriptionLabelAttributes: UILabel.Attributes = {
        let attr = UILabel.Attributes()
        attr.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)!
        attr.textColor = UIColor.appBlack()
        attr.numberOfLines = 4
        return attr
    }()
    
    lazy var datePlaceLabelAttributes: UILabel.Attributes = {
        let attr = UILabel.Attributes()
        attr.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)!
        attr.textColor = UIColor.appWhite186()
        attr.numberOfLines = 0
        return attr
    }()
}