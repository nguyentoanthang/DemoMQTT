//
//  SceneArray.swift
//  DemoMQTT
//
//  Created by mac on 5/11/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import Foundation
import Parse.PFUser

class SceneArray {
    
    static var array: [Scene] = []
    
    static func createScene() {
        let query = Scene.query()

        query?.whereKey("Email", equalTo: (PFUser.currentUser()?.email)!)
        
        do {
            let objects: [PFObject]? = try query?.findObjects()
            if let objects = objects {
                let scenes: [Scene]! = objects as? [Scene]
                array.appendContentsOf(scenes)
            }
        } catch {
            print("some thing went wrong")
        }
    }
    
}
