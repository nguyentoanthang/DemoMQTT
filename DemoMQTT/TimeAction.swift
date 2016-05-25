//
//  TimeAction.swift
//  DemoMQTT
//
//  Created by mac on 5/25/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import Foundation

class TimeAction {
    
    var time: NSDate?
    
    var controls: [ButtonSend] = []

    var name: String
    
    init(name: String) {
        self.name = name
    }
    
}
