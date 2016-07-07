//
//  CustomLabel.swift
//  DemoMQTT
//
//  Created by mac on 6/7/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    var control: Control?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
