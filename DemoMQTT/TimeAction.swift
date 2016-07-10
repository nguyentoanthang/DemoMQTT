//
//  TimeAction.swift
//  DemoMQTT
//
//  Created by mac on 5/25/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import Foundation
import Parse.PFObject_Subclass

class TimeAction: PFObject, PFSubclassing{

    convenience init(name: String, time:String, deviceID: String, email: String) {
        self.init()
        self["Name"] = name
        self["DeviceId"] = deviceID
        self["Time"] = time
        self["Email"] = email
        self["Active"] = false
    }
    
    override class func initialize() {
        struct Static {
            static var onceToken: dispatch_once_t = 0;
        }
        
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Action"
    }
    
}
