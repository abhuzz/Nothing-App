//
//  NotificationPresenter.swift
//  Nothing
//
//  Created by Tomasz Szulc on 20/04/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import UIKit

class NotificationPresenter {
    
    private var window: UIWindow?
    private var queue = Array<NTHTaskNotificationViewController>()
    
    class var sharedInstance: NotificationPresenter! {
        struct Static {
            static var instance = NotificationPresenter()
        }
        return Static.instance
    }
    
    func enqueue(task: Task) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("NTHTaskNotificationViewController") as! NTHTaskNotificationViewController
        vc.task = task
        
        self.queue.append(vc)

        if self.window == nil {
            self._showNext(self.queue.first!)
            self.queue.removeAtIndex(0)
        }
    }
    
    private func _showNext(vc: NTHTaskNotificationViewController) {
        var frame = UIApplication.sharedApplication().keyWindow!.frame
        self.window = UIWindow(frame: frame)
        self.window!.windowLevel = UIWindowLevelAlert
        self.window!.rootViewController = vc
        
        self.window!.makeKeyAndVisible()
        vc.backgroundView.alpha = 0
        vc.containerView.alpha = 0
        
        UIView.animateWithDuration(NSTimeInterval(0.15), animations: { () -> Void in
            vc.backgroundView.alpha = 1
        }) { (finished) -> Void in
            vc.containerView.alpha = 1
            vc.containerView.frame.origin.y += vc.view.frame.size.height
            UIView.animateKeyframesWithDuration(NSTimeInterval(0.25), delay: 0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
                vc.containerView.frame.origin.y -= vc.view.frame.size.height
            }, completion: nil)
        }
    }
    
    func dequeue() {
        
        if self.window == nil {
            return
        }
        
        UIView.animateKeyframesWithDuration(NSTimeInterval(0.35), delay: 0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            self.window!.alpha = 0
        }) { (finished) -> Void in
            self.window!.resignKeyWindow()
            self.window = nil
            
            if self.queue.first != nil {
                self._showNext(self.queue.first!)
                self.queue.removeAtIndex(0)
            }
        }
    }
}