//
//  String_Extensions.swift
//  Nothing
//
//  Created by Tomasz Szulc on 07/02/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

extension String {
    
    /// Forms
    static func titleHeaderString() -> String {
        return NSLocalizedString("Title", comment: "")
    }
    
    static func descriptionHeaderString() -> String {
        return NSLocalizedString("Description", comment: "")
    }
    
    static func remindMeAtLocationHeaderString() -> String {
        return NSLocalizedString("Remind me at location", comment: "")
    }
    
    static func regionHeaderString() -> String {
        return NSLocalizedString("Region", comment: "")
    }
    
    static func remindMeOnDateHeaderString() -> String {
        return NSLocalizedString("Remind me on date", comment: "")
    }
    
    static func repeatHeaderString() -> String {
        return NSLocalizedString("Repeat", comment: "")
    }
    
    static func connectionsHeaderString() -> String {
        return NSLocalizedString("Connections", comment: "")
    }
    
    static func noneString() -> String {
        return NSLocalizedString("None", comment: "")
    }
    
    static func arriveString() -> String {
        return NSLocalizedString("Arrive", comment: "")
    }
    
    static func leaveString() -> String {
        return NSLocalizedString("Leave", comment: "")
    }
    
    static func addANewConnectionString() -> String {
        return NSLocalizedString("+ Add a new connection", comment: "")
    }
    
    static func addANewPlaceString() -> String {
        return NSLocalizedString("+ Add a new place", comment: "")
    }
    
    static func addANewContactString() -> String {
        return NSLocalizedString("+ Add a new contact", comment: "")
    }
    
    static func noConnectionsString() -> String {
        return NSLocalizedString("No connections", comment: "")
    }
    
    /// Repeat Intervals
    static func noneRepeatInterval() -> String {
        return NSLocalizedString("None", comment: "")
    }
    
    static func onceADayRepeatInterval() -> String {
        return NSLocalizedString("Once a day", comment: "")
    }
    
    static func onceAWeakRepeatInterval() -> String {
        return NSLocalizedString("Once a week", comment: "")
    }
    
    static func onceAMonthRepeatInterval() -> String {
        return NSLocalizedString("Once a month", comment: "")
    }
    
    static func onceAYearRepeatInterval() -> String {
        return NSLocalizedString("Once a year", comment: "")
    }
    
    
    static func cancelString() -> String {
        return NSLocalizedString("Cancel", comment: "")
    }
    
    static func callString() -> String {
        return NSLocalizedString("Call", comment: "")
    }
    
    static func sendEmailString() -> String {
        return NSLocalizedString("Send Email", comment: "")
    }
    
    static func showOnMapString() -> String {
        return NSLocalizedString("Show on map", comment: "")
    }
    
    static func editString() -> String {
        return NSLocalizedString("Edit", comment: "")
    }
    
    static func markAsDoneString() -> String {
        return NSLocalizedString("Mark as Done", comment: "")
    }
    
    static func markAsActiveString() -> String {
        return NSLocalizedString("Mark as Active", comment: "")
    }
    
    static func okString() -> String {
        return NSLocalizedString("OK", comment: "")
    }
}