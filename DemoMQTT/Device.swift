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
    
    var icon: UIImage?
    
    convenience init(name: String, deviceID: String) {
        self.init()
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