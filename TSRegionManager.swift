//
//  RegionManager.swift
//  Nothing
//
//  Created by Tomasz Szulc on 11/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

protocol TSRegionManagerDelegate {
    func regionManager(manager: TSRegionManager, didNotify regions: [TSRegion])
    func regionManagerNeedRegions(manager: TSRegionManager) -> [TSRegion]
}

class TSRegionManager {
 
    private var regions = [TSRegion]()
    private var lastLocation: CLLocation?
    
    var delegate: TSRegionManagerDelegate!
    var distanceUpdate: CLLocationDistance = 10
    
    
    func update(location: CLLocation) {
        /// Check if distance is greater than `distanceUpdate` to avoid non-stop updates
        if let previous = self.lastLocation {
            if previous.distanceFromLocation(location) < self.distanceUpdate {
                return
            }
        }
        
        self.lastLocation = location
        
        self.refresh()
    }
    
    func refresh() {
        self._refreshRegions()
        let regionsToNotify = self._checkRules(self.lastLocation!)
        self.delegate.regionManager(self, didNotify: regionsToNotify)
    }
    
    private func _refreshRegions() {
        /// get new regions
        let newRegions = self.delegate.regionManagerNeedRegions(self)
        
        /// enumerate new regions and find new to add, update existing and remove non existing
        var updatedRegions = [TSRegion]()
        
        for newRegion in newRegions {
            if let foundRegion = self._findRegion(newRegion.identifier) {
                foundRegion.updateRegion(newRegion)
                updatedRegions.append(foundRegion)
            } else {
                updatedRegions.append(newRegion)
            }
        }
        
        self.regions = updatedRegions
    }
    
    private func _findRegion(identifier: String) -> TSRegion? {
        return self.regions.filter({ $0.identifier == identifier }).first
    }
    
    /// Check rules and return those regions that should be send with notification
    private func _checkRules(location: CLLocation) -> [TSRegion] {
        var output = [TSRegion]()
        for region in self.regions {
            let diffDistance = location.distanceFromLocation(CLLocation(coordinate: region.coordinate))
            
            var notify = false
            if region.notifyOnArrive && region.distance > diffDistance {
                if !region.onArriveNotificationSent {
                    notify = true
                    region.onArriveNotificationSent = true
                }
                region.satisfiesOnArrive = true
            } else {
                region.satisfiesOnArrive = false
                region.onArriveNotificationSent = false
            }
            
            if region.notifyOnLeave && region.distance < diffDistance {
                if !region.onLeaveNotificationSent {
                    notify = true
                    region.onLeaveNotificationSent = true
                }
                region.satisfiesOnLeave = true
            } else {
                region.satisfiesOnLeave = false
                region.onLeaveNotificationSent = false
            }
            
            if notify {
                output.append(region)
            }
        }
        
        return output
    }
}
