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
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    private var locationManager: CLLocationManager!
    var regionManager = RegionManager()

    func applicationDidFinishLaunching(application: UIApplication) {
        self.setupUI()
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        self.startLocationService()
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        CDHelper.mainContext.save(nil)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        println("log")
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        println("local notification received")
        println("notification " + "\(notification)")
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

extension AppDelegate {
    
    func startLocationService() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.AuthorizedWhenInUse || status == CLAuthorizationStatus.Denied {
            let title = (status == CLAuthorizationStatus.Denied) ? "Location services are off" : "Background location is not enabled"
            let message = "To use background location you must turn on 'Always' in the Location Services Settings"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            /// Settings
            alertController.addAction(UIAlertAction.normalAction("Settings", handler: { _ in
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
                return
            }))
            
            /// Cancel
            alertController.addAction(UIAlertAction.cancelAction(String.cancelString(), handler: nil))
            
            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        } else if status == CLAuthorizationStatus.NotDetermined {
            /// nothing
        }
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
    }
    
    /// Mark: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            self.regionManager.processLocation(location)
        }
    }
}
