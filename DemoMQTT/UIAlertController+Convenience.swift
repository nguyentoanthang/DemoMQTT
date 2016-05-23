//
//  UIAlertController+Convenience.swift
//  DemoMQTT
//
//  Created by mac on 4/23/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit

extension UIAlertController {
    class func alertControllerWithTitle(title:String, message:String) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        return controller
    }
    
    class func alertControllerWithStringInput(title:String, message:String, buttonTitle:String, handler:(String?)->Void) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        controller.addTextFieldWithConfigurationHandler { $0.keyboardType = .Default }
        
        controller.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        controller.addAction(UIAlertAction(title: buttonTitle, style: .Default) { action in
            let textFields = controller.textFields
            let value = textFields?[0].text
            handler(value)
            } )
        
        return controller
    }
    
    class func alertControllerWithNumberInput(title:String, message:String, buttonTitle:String, handler:(String?)->Void) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        controller.addTextFieldWithConfigurationHandler { $0.keyboardType = .NumberPad }
        
        controller.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        controller.addAction(UIAlertAction(title: buttonTitle, style: .Default) { action in
            let textFields = controller.textFields
            let value = textFields?[0].text
            handler(value)
            } )
        
        return controller
    }
}


