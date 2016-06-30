//
//  DeviceCell.swift
//  DemoMQTT
//
//  Created by mac on 4/23/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit
import ParseUI

class DeviceCell: UITableViewCell {

    @IBOutlet weak var icon: PFImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var deviceId: UILabel!
    
    @IBOutlet weak var statusView: UIView!
    
    var device: Device! {
        didSet {
            
            if let file = device["Icon"] as? PFFile {
                icon.file = file
                icon.loadInBackground()
            } else {
                icon.backgroundColor = UIColor.grayColor()
            }
            
            
            name.text = device["Name"] as? String
            deviceId.text = device["DeviceId"] as? String
            
            statusView.layer.cornerRadius = statusView.frame.width/2
            statusView.clipsToBounds = true
        }
    }
}
