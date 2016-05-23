//
//  Device.swift
//  DemoMQTT
//
//  Created by mac on 4/22/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import Foundation
import Parse.PFObject_Subclass

class Device: PFObject, PFSubclassing {
    
    @NSManaged var name: String?
    @NSManaged var deviceID: String?
    @NSManaged var status: Bool
    @NSManaged var iconFile: PFFile?
    
    convenience init(name: String, deviceID: String) {
        self.init()
        self.deviceID = deviceID
        self.name = name
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
        return "Device"
    }
    
}