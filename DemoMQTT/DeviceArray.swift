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
    
    static var array: [Device] = [Device]()
    static var IRarray: [Device] = [Device]()
    static var DHTArray: [Device] = [Device]()
    
    static func createArray() {
        let query = Device.query()
        query?.whereKey("email", equalTo: (PFUser.currentUser()?.email)!)
        
        do {
            let objects: [PFObject]? = try query?.findObjects()
            if let objects = objects {
                let arr: [Device]! = objects as? [Device]
                
                array.appendContentsOf(arr)
                
                let arr1 = array.filter({($0["Type"] as? Int) == 1 })
                let arr2 = array.filter({($0["Type"] as? Int) == 0})
            
                DHTArray.appendContentsOf(arr2)
                IRarray.appendContentsOf(arr1)
                print("")
            }
        } catch {
            print("some thing went wrong")
        }
    
        
    }
    
}