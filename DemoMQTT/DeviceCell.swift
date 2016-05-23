//
//  DeviceCell.swift
//  DemoMQTT
//
//  Created by mac on 4/23/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit

class DeviceCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var deviceId: UILabel!
    
    var device: Device! {
        didSet {
            icon.image = UIImage(named: "background.jpg")
            name.text = device["Name"] as? String
            deviceId.text = device["DeviceId"] as? String
        }
    }
}
