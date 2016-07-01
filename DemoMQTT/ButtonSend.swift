//
//  ButtonSend.swift
//  DemoMQTT
//
//  Created by mac on 4/27/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit

class ButtonSend: UIButton {
    
    var irCode: String?
    var codeType: String?
    weak var control: Control?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Build control
    
    func customInit() {
        self.layer.borderWidth = 2.0
        //self.layer.borderColor = UIColor.redColor().CGColor
        self.layer.cornerRadius = 7.0
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        //self.backgroundColor = UIColor.redColor()
        
        // http://stackoverflow.com/questions/4735623/uilabel-layer-cornerradius-negatively-impacting-performance
        layer.masksToBounds = false
        layer.rasterizationScale = UIScreen.mainScreen().scale
        layer.shouldRasterize = true
    }
   
}