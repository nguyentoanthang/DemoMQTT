//
//  SignupView.swift
//  DemoMQTT
//
//  Created by mac on 4/29/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit
import Parse.PFUser
import MBProgressHUD
import Async

class SignupView: UIViewController {

    @IBOutlet weak var name: DCBorderedTextField!
    
    @IBOutlet weak var pass: DCBorderedTextField!
    
    @IBOutlet weak var email: DCBorderedTextField!
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Sign up..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    @IBAction func Signup(sender: DCRoundedButton) {
        
        guard let _name = name.text where _name != "" else {
            raiseError()
            return
        }
        
        guard let _email = email.text where _email != "" else {
            raiseError()
            return
        }
        
        guard let _pass = pass.text where _pass != "" else {
            raiseError()
            return
        }
        
        let user = PFUser()
        
        user.username = _email
        user.password = _pass
        user.email = _email
        
        showLoadingHUD()
        
        user.signUpInBackgroundWithBlock({(successed: Bool, error: NSError?) -> Void in
            if successed == false {
                self.hideLoadingHUD()
                self.raiseError()
                return
            } else {
                let scene: Scene = Scene(name: "Living room", email: _email)
                scene.saveInBackground()
                self.hideLoadingHUD()
                self.performSegueWithIdentifier("signupSuccess", sender: nil)
            }})
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    func raiseSuccess() {
            
    }
        
    func raiseError() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
