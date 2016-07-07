//
//  IRCode.swift
//  DemoMQTT
//
//  Created by mac on 4/28/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import Foundation

class IRCode {
    
    static let dic: [String: String] = ["-1": "UNKNOW", "0": "UNUSED", "1": "RC5", "2": "RC6", "3": "NEC", "4": "SONY"]
    
    static var PANASONIC    =  5
    static var JVC          =  6
    static var SAMSUNG      =  7
    static var WHYNTER      =  8
    static var AIWA_RC_T501 =  9
    static var LG           =  10
    static var SANYO        =  11
    static var MITSUBISHI   =  12
    static var DISH         =  13
    static var SHARP        =  14
    static var DENON        =  15
    static var PRONTO       =  16
    
}