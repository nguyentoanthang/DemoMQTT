//
//  Scene.swift
//  DemoMQTT
//
//  Created by mac on 4/26/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import Foundation
import Parse.PFObject_Subclass

class Scene: PFObject, PFSubclassing {
    
    @NSManaged var name: String?
    @NSManaged var email: String?
    @NSManaged var image: UIImage?
    
    convenience init(name: String, email: String) {
        self.init()
        self.name = name
        self["Name"] = name
        self.email = email
        self["Email"] = email
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
        return "Scene"
    }
    
}