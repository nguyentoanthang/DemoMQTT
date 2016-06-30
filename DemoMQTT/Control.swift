//
//  Control.swift
//  DemoMQTT
//
//  Created by mac on 5/13/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import Foundation
import Parse.PFObject_Subclass

class Control: PFObject, PFSubclassing {
    
    convenience init(type: Int, sceneID: String) {
        self.init()
        self["Type"] = type
        self["SceneId"] = sceneID
        self["Color"] = 0
        self["Name"] = "?"
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
        return "Control"
    }
}

