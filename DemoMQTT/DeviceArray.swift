//
//  DeviceArray.swift
//  DemoMQTT
//
//  Created by mac on 4/28/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import Foundation
import Parse.PFUser

class DeviceArray {
    
    static var array: [Device] = []
    static var IRarray: [Device] = []
    
    static func createArray() {
        let query = Device.query()
        query?.whereKey("email", equalTo: (PFUser.currentUser()?.email)!)
        
        do {
            let objects: [PFObject]? = try query?.findObjects()
            if let objects = objects {
                let devices: [Device]? = objects as? [Device]
                array.appendContentsOf(devices!)
                let arr = array.filter({device in (device["Type"] as? Int) == 1 })
                IRarray.appendContentsOf(arr)
                print("")
            }
        } catch {
            print("some thing went wrong")
        }
    
        
    }
    
}