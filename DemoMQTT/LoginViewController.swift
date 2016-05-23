//
//  LoginViewController.swift
//  DemoMQTT
//
//  Created by mac on 4/21/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit
import Parse.PFUser
import MBProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var email: DCBorderedTextField!
    
    @IBOutlet weak var pass: DCBorderedTextField!
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Login..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    @IBAction func Login(sender: DCRoundedButton) {
        
        guard let _email = email.text where _email != "" else {
            raiseError()
            return
        }
        
        guard let _pass = pass.text where _pass != "" else {
            raiseError()
            return
        }
        
        showLoadingHUD()
        
        PFUser.logInWithUsernameInBackground(_email, password: _pass, block: {(user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.hideLoadingHUD()
                self.performSegueWithIdentifier("loginSuccess", sender: nil)
            } else {
                self.hideLoadingHUD()
                self.raiseError()
                return
            }})
        
    }
    
    func raiseError() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelSignUp(segue: UIStoryboardSegue) {
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
