//
//  UIColor+Convenience.swift
//  DemoMQTT
//
//  Created by mac on 5/11/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func colorFromHex(hex: String, alpha: CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hex))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color

    }
    
    class func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: NSScanner = NSScanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersInString: "#")
        // Scan hex value
        scanner.scanHexInt(&hexInt)
        return hexInt
    }
}
