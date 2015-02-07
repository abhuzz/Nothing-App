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
        self.setupUI()
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

