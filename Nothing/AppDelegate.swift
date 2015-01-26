//
//  AppDelegate.swift
//  Nothing
//
//  Created by Tomasz Szulc on 27/10/14.
//  Copyright (c) 2014 Tomasz Szulc. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(application: UIApplication) {
//        self.populateData()
        self.setupUI()
    }
    
    /// Mark: Debug
    private func taskWithTitle(title: String, description: String) -> Task {
        let task: Task = Task.create(CDHelper.mainContext)
        task.title = title
        task.longDescription = description
        return task
    }
    
    private func place(coordinate: CLLocationCoordinate2D, title: String, thumbnailKey: String?) -> Place {
        let place: Place = Place.create(CDHelper.mainContext)
        place.coordinate = coordinate
        place.originalName = title
        place.thumbnailKey = thumbnailKey
        return place
    }
    
    private func contact(name: String, email: String, thumbnailKey: String) -> Contact {
        let contact: Contact = Contact.create(CDHelper.mainContext)
        contact.name = name
        contact.email = email
        contact.thumbnailKey = thumbnailKey
        return contact
    }
    
    private func dateReminder(date: NSDate, repeatInterval: NSCalendarUnit) -> DateReminderInfo {
        let info: DateReminderInfo = DateReminderInfo.create(CDHelper.mainContext)
        info.fireDate = date
        info.repeatInterval = repeatInterval
        return info
    }
    
    private func locationReminder(place: Place, distance: Float) -> LocationReminderInfo {
        let info: LocationReminderInfo = LocationReminderInfo.create(CDHelper.mainContext)
        info.place = place
        info.distance = distance
        return info
    }
    
    private func populateData() {
        
        /// cache images
        let c1Image = UIImage(named: "avatar")
        let p1Image = UIImage(named: "city")
        let p2Image = UIImage(named: "city2")
        
        let (_, c1Key) = ThumbnailCache.sharedInstance.write(UIImagePNGRepresentation(c1Image))
        let (_, p1Key) = ThumbnailCache.sharedInstance.write(UIImagePNGRepresentation(p1Image))
        let (_, p2Key) = ThumbnailCache.sharedInstance.write(UIImagePNGRepresentation(p2Image))
        
        let c1 = self.contact("Tomasz Szulc", email: "mail@szulctomasz.com", thumbnailKey: c1Key)
        let p1 = self.place(CLLocationCoordinate2DMake(53.445152, 14.557538), title: "Home", thumbnailKey: p1Key)
        let p2 = self.place(CLLocationCoordinate2DMake(10, 10), title: "Office", thumbnailKey: p2Key)
        let p3 = self.place(CLLocationCoordinate2DMake(20, 20), title: "Grocery shop", thumbnailKey: nil)

        /// 1
        let t1 = self.taskWithTitle("Handwriting", description: "I was #sifting through my #dead-tree postal #mail and tossing #junk in the recycling bin. Nearly #everything that arrives in my #mailbox is #junk, so I was #tossing.")
        
        let date = NSDate()
        t1.dateReminder = self.dateReminder(date, repeatInterval: NSCalendarUnit.allZeros)
        t1.locationReminder = self.locationReminder(p1, distance: 1000)
        t1.addConnection(c1)
        
        /// 2
        let t2 = self.taskWithTitle("Buy a milk", description: "#shoppinglist")
        t2.locationReminder = self.locationReminder(p3, distance: 1500)
        
        /// 3
        let t3 = self.taskWithTitle("Call Tomasz", description: "Talk about job opportunities in #London")
        t3.addConnection(c1)
        t3.addConnection(p2)
        
        /// 4
        let t4 = self.taskWithTitle("Get rid of the old stuff", description: "Cannot look on this anymoaaaar!!!")
        t4.addConnection(c1)
        t4.addConnection(p1)
        t4.addConnection(p2)
        t4.addConnection(p3)
        
        CDHelper.mainContext.save(nil)
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        CDHelper.mainContext.save(nil)
    }
}

extension AppDelegate {
    func setupUI() {
        /// UINavigationBar
        UINavigationBar.appearance().barTintColor = UIColor.NTHMoodyBlueColor()
        UINavigationBar.appearance().translucent = true

        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.NTHWhiteColor(),
            NSFontAttributeName: UIFont.NTHNavigationBarTitleFont()
        ]

        UINavigationBar.appearance().tintColor = UIColor.NTHWhiteColor()

//        /// UITableView
        UITableView.appearance().separatorColor = UIColor.NTHWhiteLilacColor()
    }
}

