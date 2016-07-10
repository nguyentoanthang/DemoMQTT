//
//  ControlView.swift
//  DemoMQTT
//
//  Created by mac on 4/26/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse
import ParseUI
import CocoaMQTT
import CZPicker

class ControlView: UIViewController {

    var isShow: Bool = false
    var isChooseDevice: Bool = false
    var controls: [Control] = [Control]()
    var controlLabelView: [UILabel] = []
    var controlBtnView: [ButtonSend] = []
    weak var temp: UIView!
    //weak var buttonTemp: ButtonSend!
    //weak var controlTemp: Control?

    @IBOutlet weak var chooseColorView: UIView!
    @IBOutlet weak var nameBtn: UITextField!
    @IBOutlet weak var typeName: UILabel!

    @IBOutlet weak var learnBtn: DCRoundedButton!
    
    @IBOutlet weak var deviceIcon: PFImageView!
    
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var chooseDeviceBtn: DCBorderedButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var deviceView: UIView!
    weak var selectedButton: ButtonSend?
    // the scene contain controls
    var currentSceneID: String!
    
    // Label config view
    @IBOutlet weak var configLabel: UIView!
    
    @IBOutlet weak var labelDeviceBtn: DCBorderedButton!
    @IBOutlet weak var tempertureBtn: UIButton!
    @IBOutlet weak var configView: UIView!
    
    @IBOutlet weak var controlView: UIView!
    let blackView = UIView()

    @IBOutlet weak var addBtn: UIBarButtonItem!
    
    
    /*************** flag and IRCODE receive **************/
    //var isReceive = false
    var irCode: String?
    
    /********** CONFIG BUTTON **********/
    
    
    
    func addControl() {
        let query = Control.query()
        query?.whereKey("SceneId", equalTo: self.currentSceneID)
        showLoadingHUD()
        query?.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) in
            self.controls = objects as! [Control]
            for object in self.controls {
                if object["Type"] as! Int == 0 {
                    let button = ButtonSend(type: UIButtonType.System)
                    button.customInit()
                    button.setTitle(object["Name"] as? String, forState: .Normal)
                    button.frame = CGRectMake(object["X"] as! CGFloat, object["Y"] as! CGFloat, 50, 50)
                    let colorIndex = object["Color"] as! Int
                    button.backgroundColor = Color.color[colorIndex]
                    button.layer.borderColor = Color.color[colorIndex].CGColor
                    
                    let longpress = UILongPressGestureRecognizer(target: self, action: #selector(ControlView.long(_:)))
                    
                    let pan = UIPanGestureRecognizer(target: self, action: #selector(ControlView.pan(_:)))
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(ControlView.handelTap(_:)))
                    tap.delegate = self
                    tap.requireGestureRecognizerToFail(longpress)
                    tap.requireGestureRecognizerToFail(pan)
                    
                    button.addGestureRecognizer(tap)
                    button.addGestureRecognizer(longpress)
                    button.addGestureRecognizer(pan)
                    button.control = object
                    
                    self.controlBtnView.append(button)
                    self.view.addSubview(button)
                } else {
                    let label = CustomLabel(frame: CGRectMake(object["X"] as! CGFloat, object["Y"] as! CGFloat, 50, 50))
                    label.textColor = UIColor.redColor()
                    label.text = "???"
                    label.frame = CGRectMake(object["X"] as! CGFloat, object["Y"] as! CGFloat, 50, 50)
                    let colorIndex = object["Color"] as! Int
                    label.textColor = Color.color[colorIndex]
                    
                    let longpress = UILongPressGestureRecognizer(target: self, action: #selector(ControlView.long(_:)))
                    
                    let pan = UIPanGestureRecognizer(target: self, action: #selector(ControlView.pan(_:)))
        
                    label.addGestureRecognizer(longpress)
                    label.addGestureRecognizer(pan)
                    label.control = object
                    label.userInteractionEnabled = true
                    
                    self.controlLabelView.append(label)
                    self.view.addSubview(label)
                }
            }
            self.hideLoadingHUD()
        })
        
    }
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Loading..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // config black View
        // config the view
        blackView.frame = UIScreen.mainScreen().bounds
        blackView.backgroundColor = UIColor.blackColor()
        blackView.alpha = 0.0
        
        controlView.hidden = true
        self.view.backgroundColor = UIColor.colorFromHex("#d3ffce")
        
        // setup configView
        self.configView.layer.cornerRadius = 10.0
        //self.configView.layer.borderColor = UIColor.lightGrayColor().CGColor
        //self.configView.layer.borderWidth = 1.0
        self.configView.clipsToBounds = true
        
        // setup controlView
        self.controlView.layer.cornerRadius = 10.0
        //self.configView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.controlView.layer.borderWidth = 1.0
        self.controlView.clipsToBounds = true
        
        // setup label config
        self.configLabel.layer.cornerRadius = 10.0
        self.configLabel.clipsToBounds = true
        
//        blurView.effect = blurEffect
//        blurView.frame = UIScreen.mainScreen().bounds
//        self.view.addSubview(blurView)
        
        // add tap gesture recognite to blur view
//        let tap = UITapGestureRecognizer(target: self, action: #selector(ControlView.blurViewTap(_:)))
//        blurView.addGestureRecognizer(tap)
        //self.view.addSubview(blurView)
        
        //self.navigationController?.navigationBar.barTintColor = UIColor.clearColor()
        
        // set translucent navigation bar
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.translucent = true
        
        addControl()
        Connection.instance.mqtt?.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(sender: AnyObject) {
        
        weak var control = (self.temp as! ButtonSend).control
        
        if self.irCode != nil {
            control!["IRCode"] = self.irCode
        }
        
        // save control
        control!["Name"] = nameBtn.text
        
        if chooseDeviceBtn.titleLabel?.text != "" {
            control!["DeviceId"] = chooseDeviceBtn.titleLabel?.text
        }
        
        control?.saveInBackground()
        irCode = nil
        
        self.configView.transform = CGAffineTransformMakeScale(1, 1)
        self.configView.hidden = false
        
        if isChooseDevice {
            isChooseDevice = false
            UIView.animateWithDuration(0.2, animations: {
                self.blackView.alpha = 0.0
                self.configView.transform = CGAffineTransformMakeScale(0.1, 0.1)
                self.deviceView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 200)}, completion: {conplete in
                    self.deviceView.hidden = true
                    self.configView.hidden = true
                    self.blackView.removeFromSuperview()})
        } else {
            UIView.animateWithDuration(0.2, animations: {
                self.blackView.alpha = 0.0
                self.configView.transform = CGAffineTransformMakeScale(0.1, 0.1)}, completion: {conplete in
                    self.configView.hidden = true
                    self.blackView.removeFromSuperview()})
        }
        
    }
    
    // this function handle pan gesture on Label
    @IBAction func labelPan(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            let label = CustomLabel(frame: CGRectMake((sender.view?.frame.origin.x)!, self.controlView.frame.origin.y + (sender.view?.frame.origin.y)!, 45, 45))
            label.textColor = UIColor.redColor()
            label.text = "???"
            
            // create a shadow of this button
            
            label.alpha = 0.5
            self.view.addSubview(label)
            print("began")
            temp = label
        }
        
        if sender.state == UIGestureRecognizerState.Changed {
            print("change")
            let translation = sender.translationInView(self.controlView)
            
            temp.center = CGPoint(x: temp.center.x + translation.x, y: temp.center.y + translation.y)
            
            sender.setTranslation(CGPointZero, inView: self.controlView)
            
            if temp.center.y < self.controlView.frame.origin.y {
                temp.alpha = 1.0
                temp.frame.size = CGSizeMake(50, 50)
            } else {
                temp.alpha = 0.5
                temp.frame.size = CGSizeMake(45, 45)
            }
        }
        
        if sender.state == UIGestureRecognizerState.Ended {
            
            if temp.center.y < self.controlView.frame.origin.y {
                
                (temp as! CustomLabel).control = Control(type: 1, sceneID: self.currentSceneID)
                // save control to parse.com
                let control = (temp as! CustomLabel).control
                
                let longpress = UILongPressGestureRecognizer(target: self, action: #selector(ControlView.long(_:)))
                
                let pan = UIPanGestureRecognizer(target: self, action: #selector(ControlView.pan(_:)))

                temp.addGestureRecognizer(longpress)
                temp.addGestureRecognizer(pan)
                temp.userInteractionEnabled = true
                (temp as! CustomLabel).control = control
                
                let y = (self.navigationController?.navigationBar.frame.origin.y)! + (self.navigationController?.navigationBar.frame.height)!
                
                if temp.frame.origin.y < y {
                    temp.center = CGPoint(x: temp.center.x, y: y + temp.frame.height/2)
                }
                
                control!["X"] = temp.frame.origin.x
                control!["Y"] = temp.frame.origin.y
                control!.saveInBackground()
                
            } else {
                temp.removeFromSuperview()
            }
            
            temp = nil
        }
    }
    
    
    // this function handle pan gesture on button
    @IBAction func handelPan(sender: UIPanGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Began {
            let button = ButtonSend(type: UIButtonType.System)
            button.customInit()
            button.setTitle("?", forState: UIControlState.Normal)
            // create a shadow of this button
            button.frame = CGRectMake((sender.view?.frame.origin.x)!, self.controlView.frame.origin.y + (sender.view?.frame.origin.y)!, 45, 45)
            button.alpha = 0.5
            button.layer.borderColor = UIColor.redColor().CGColor
            button.backgroundColor = UIColor.redColor()
            self.view.addSubview(button)
            print("began")
            temp = button
        }
        
        if sender.state == UIGestureRecognizerState.Changed {
            print("change")
            let translation = sender.translationInView(self.controlView)
 
            temp.center = CGPoint(x: temp.center.x + translation.x, y: temp.center.y + translation.y)
            
            sender.setTranslation(CGPointZero, inView: self.controlView)
            
            if temp.center.y < self.controlView.frame.origin.y {
                temp.alpha = 1.0
                temp.frame.size = CGSizeMake(50, 50)
            } else {
                temp.alpha = 0.5
                temp.frame.size = CGSizeMake(45, 45)
            }
        }
        
        if sender.state == UIGestureRecognizerState.Ended {
            
            if temp.center.y < self.controlView.frame.origin.y {
                
                // save control to parse.com
                (temp as! ButtonSend).control = Control(type: 0, sceneID: self.currentSceneID)
                let control = (temp as! ButtonSend).control
                let longpress = UILongPressGestureRecognizer(target: self, action: #selector(ControlView.long(_:)))
                
                let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(_:)))
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(ControlView.handelTap(_:)))
                tap.delegate = self
                tap.requireGestureRecognizerToFail(longpress)
                tap.requireGestureRecognizerToFail(pan)
                
                temp.addGestureRecognizer(tap)
                temp.addGestureRecognizer(longpress)
                temp.addGestureRecognizer(pan)
                
                self.controlBtnView.append(temp as! ButtonSend)
                
                let y = (self.navigationController?.navigationBar.frame.origin.y)! + (self.navigationController?.navigationBar.frame.height)!

                if temp.frame.origin.y < y {
                    temp.center = CGPoint(x: temp.center.x, y: y + temp.frame.height/2)
                }
                
                control!["X"] = temp.frame.origin.x
                control!["Y"] = temp.frame.origin.y
                control!.saveInBackground()

            } else {
                temp.removeFromSuperview()
            }
            
            temp = nil
        }
        
    }
    
    // this hide a choose color view
    @IBAction func cancelChooseColor(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: {
            self.chooseColorView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height, UIScreen.mainScreen().bounds.width, self.chooseColorView.frame.height)
            self.blackView.alpha = 0.0
        }) { (complete) in
                self.blackView.removeFromSuperview()
                self.chooseColorView.hidden = true
        }
    }
    
    // this function choose color of view
    @IBAction func chooseColor(sender: DCBorderedButton) {
        
        UIView.animateWithDuration(0.2, animations: {
            self.chooseColorView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height, UIScreen.mainScreen().bounds.width, self.chooseColorView.frame.height)
            self.blackView.alpha = 0.0
        }) { (complete) in
            self.blackView.removeFromSuperview()
            self.chooseColorView.hidden = true
        }
        
        if let view = self.temp as? ButtonSend {
            view.backgroundColor = Color.color[sender.tag]
            view.layer.borderColor = Color.color[sender.tag].CGColor
            
            let control = view.control
            control?["Color"] = sender.tag
            control?.saveInBackground()
        } else {
            let view = temp as! CustomLabel
            view.textColor = Color.color[sender.tag]
            
            let control = view.control
            control?["Color"] = sender.tag
            control?.saveInBackground()
        }
        
        if (self.temp as? ButtonSend) != nil {
            
        } else {
            
        }
        
        
        
    }
    
    // this function show a choose device View at bottom of screen
    @IBAction func chooseDevice(sender: AnyObject) {
        
        //picker.selectRow(1, inComponent: 0, animated: false)
        var view: UIView
        
        if (temp as? ButtonSend) != nil {
            view = self.configView
        } else {
            view = self.configLabel
        }
        
        if !isChooseDevice {
            isChooseDevice = true
            deviceView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 200)
            deviceView.hidden = false
            
            UIView.animateWithDuration(0.2, animations: {
                view.transform = CGAffineTransformMakeTranslation(0, -100)
                self.deviceView.frame = CGRectMake(0, 368, UIScreen.mainScreen().bounds.size.width, 200)})
        } else {
            isChooseDevice = false
            UIView.animateWithDuration(0.2, animations: {
                view.transform = CGAffineTransformMakeTranslation(0, 0)
                self.deviceView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 200)}, completion: { (complete) in
                    self.deviceView.hidden = true
            })
        }
        
        
        
    }
    @IBAction func cancel(sender: AnyObject) {
        
        self.configView.transform = CGAffineTransformMakeScale(1, 1)
        self.configView.hidden = false
        
        if isChooseDevice {
            isChooseDevice = false
            UIView.animateWithDuration(0.2, animations: {
                self.blackView.alpha = 0.0
                self.configView.transform = CGAffineTransformMakeScale(0.1, 0.1)
                self.deviceView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 200)}, completion: {conplete in
                    self.deviceView.hidden = true
                    self.configView.hidden = true
                    self.blackView.removeFromSuperview()})
        } else {
            UIView.animateWithDuration(0.2, animations: {
                self.blackView.alpha = 0.0
                self.configView.transform = CGAffineTransformMakeScale(0.1, 0.1)}, completion: {conplete in
                    self.configView.hidden = true
                    self.blackView.removeFromSuperview()})
        }
        
        
        
    }
    
    @IBAction func addButton(sender: ButtonSend) {
        
//        let button = ButtonSend(type: UIButtonType.System)
//        button.frame = CGRectMake(100, 100, 50, 50)
//        button.customInit()
//        button.setTitle("?", forState: UIControlState.Normal)
//        button.codeType = "SONY"
//        
//        self.view.addSubview(button)
//        controls.append(button)
//        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(ControlView.long(_:)))
//   
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(_:)))
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(ControlView.handelTap(_:)))
//        tap.delegate = self
//        tap.requireGestureRecognizerToFail(longpress)
//        
//        button.addGestureRecognizer(tap)
//        button.addGestureRecognizer(longpress)
//        button.addGestureRecognizer(pan)
//    
//        controls.append(button)
    }
    
    func handelTap(sender: UITapGestureRecognizer) {
        let control = (sender.view as! ButtonSend).control
        
        let irCode = control!["IRCode"] as? String
        if irCode != nil {
            Connection.instance.mqtt?.publish("example1", withString: irCode!)
        } else {
            let alert = UIAlertController.alertControllerWithTitle("Empty code", message: "This control don't have the IR code")
            presentViewController(alert, animated: true, completion: nil)
        }
        
        print("Tap")
    }
    
    func showConfigView(view: UIView) {
        self.view.addSubview(self.blackView)
        //self.blackView.layer.zPosition = 1
        
        self.view.bringSubviewToFront(view)
        self.view.bringSubviewToFront(self.deviceView)
        view.transform = CGAffineTransformMakeScale(0.1, 0.1)
        view.hidden = false
        UIView.animateWithDuration(0.2, animations:
            {self.blackView.alpha = 0.5
                view.transform = CGAffineTransformMakeScale(1, 1)})
    }
    
    func showActionSheet() {
        
        let actionSheet = UIAlertController(title: "Action", message: "choose your action", preferredStyle: .ActionSheet)
        
        let 💛 = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        let 💚 = UIAlertAction(title: "Config", style: .Default) { (action) in
            
            if (self.temp as? ButtonSend) != nil {
                let control = (self.temp as! ButtonSend).control
                if control!["IRCode"] != nil {
                    let array = (control!["IRCode"] as! String).componentsSeparatedByString("/")
                    self.typeName.text = IRCode.dic[array[0]]
                } else {
                    self.typeName.text = "UNKNOW"
                }
                
                
                var deviceID = (control!["DeviceId"] as? String)
                if deviceID == nil {
                    deviceID = "???"
                    self.learnBtn.enabled = false
                } else {
                    self.learnBtn.enabled = true
                }
                let name = (control!["Name"] as? String)
                
                self.chooseDeviceBtn.setTitle(deviceID, forState: UIControlState.Normal)
                self.nameBtn.text = name
            
                self.showConfigView(self.configView)
            } else {
                let control = (self.temp as! CustomLabel).control
                var deviceID = (control!["DeviceId"] as? String)
                
                if deviceID == nil {
                    deviceID = "???"
                    
                }
                
                var isTemperture = ""
                
                if control!["isTemperture"] as? Bool == nil {
                    isTemperture = "???"
                } else if control!["isTemperture"] as! Bool == true {
                    isTemperture = "Temperture"
                } else {
                    isTemperture = "Humidity"
                }
                
                self.tempertureBtn.setTitle(isTemperture, forState: .Normal)
                self.labelDeviceBtn.setTitle(deviceID, forState: .Normal)
                
                self.showConfigView(self.configLabel)
            }
            
//            self.configView.center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height/2)
//            
//            self.configView.frame.size = CGSizeMake(0, 0)
//            self.configView.hidden = false
//            UIView.animateWithDuration(0.2, animations: { 
//                self.configView.frame.size = CGSizeMake(240, 227)
//            })
        }
        
        let 💙 = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            
            if let view = (self.temp as? ButtonSend) {
                let control = view.control
                
                // remove control
                control?.deleteInBackground()
                let index = self.controls.indexOf(control!)
                self.controls.removeAtIndex(index!)
                
                // remove view
                let index1 = self.controlBtnView.indexOf(view)
                self.controlBtnView[index1!].removeFromSuperview()
                self.controlBtnView.removeAtIndex(index1!)
            } else {
                let control = (self.temp as! CustomLabel).control
                
                // remove control
                control?.deleteInBackground()
                let index = self.controls.indexOf(control!)
                self.controls.removeAtIndex(index!)
                
                // remove view
                let index1 = self.controlLabelView.indexOf((self.temp as! CustomLabel))
                self.controlLabelView[index1!].removeFromSuperview()
                self.controlLabelView.removeAtIndex(index1!)
            }
            
        }
        
        let 💜 = UIAlertAction(title: "Choose Color", style: .Default) { (acion) in
            self.view.addSubview(self.blackView)
            self.view.bringSubviewToFront(self.chooseColorView)
            self.chooseColorView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height, UIScreen.mainScreen().bounds.size.width, self.chooseColorView.frame.height)
            print(self.chooseColorView.frame)
            self.chooseColorView.hidden = false
            UIView.animateWithDuration(0.2) {
                self.chooseColorView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height - self.chooseColorView.frame.height, UIScreen.mainScreen().bounds.width, self.chooseColorView.frame.height)
                self.blackView.alpha = 0.5
            }
        }
        
        actionSheet.addAction(💛)
        actionSheet.addAction(💚)
        actionSheet.addAction(💜)
        actionSheet.addAction(💙)
        
        presentViewController(actionSheet, animated: true, completion: nil)
        
    }

    
    func pan(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            print("began")
        }
        
        if sender.state == UIGestureRecognizerState.Changed {
            print("change")
        }
        
        if sender.state == UIGestureRecognizerState.Ended {
            
            let y = (self.navigationController?.navigationBar.frame.origin.y)! + (self.navigationController?.navigationBar.frame.height)!
            
            if let view = sender.view {
                if view.frame.origin.y < y {
                    view.center = CGPoint(x: view.center.x, y: y + view.frame.height/2)
                }
            }
            
            print("end")
            
            if let view = sender.view as? ButtonSend {
                let control = view.control
                control!["X"] = sender.view?.frame.origin.x
                control!["Y"] = sender.view?.frame.origin.y
                control!.saveInBackground()
            } else {
                let control = (sender.view as! CustomLabel).control
                control!["X"] = sender.view?.frame.origin.x
                control!["Y"] = sender.view?.frame.origin.y
                control!.saveInBackground()
            }
            
            
            
       }
        let translation = sender.translationInView(self.view)
        if let view = sender.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        sender.setTranslation(CGPointZero, inView: self.view)

    }
    
    
    func long(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Began {
            //let button = sender.view as? ButtonSend
            //self.performSegueWithIdentifier("detail", sender: button)
            temp = sender.view
            showActionSheet()
        } else if sender.state == UIGestureRecognizerState.Ended {
            print("end")
        }
        
    }
    
    @IBAction func showView(sender: AnyObject) {
        if isShow {
            UIView.animateWithDuration(0.3, animations: { 
                self.controlView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height, UIScreen.mainScreen().bounds.width, self.controlView.frame.height)
                }, completion: { (complete) in
                    if complete {
                        self.controlView.hidden = true
                    }
            })
            self.isShow = false
            addBtn.title = "Add"
        } else {
            controlView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, controlView.frame.height)
            controlView.hidden = false
            //self.view.addSubview(self.blackView)
            self.view.bringSubviewToFront(controlView)
            
            UIView.animateWithDuration(0.3) {
                self.controlView.frame = CGRectMake(0, 508, UIScreen.mainScreen().bounds.size.width, self.controlView.frame.height)
            }
            self.isShow = true
            addBtn.title = "Done"
        
        }
    }
    
    @IBAction func LearnIRCode(sender: AnyObject) {
        Connection.instance.mqtt?.publish("example1", withString: "first publish")
        showLoadingHUD()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { 
            
            while self.irCode == nil {
                
            }
            
            // process IRcode
            let array = self.irCode?.componentsSeparatedByString("/")
            
            
            dispatch_async(dispatch_get_main_queue(), { 
                // update UI
                self.hideLoadingHUD()
                self.typeName.text = IRCode.dic[array![0]]
            })
        }
    }
    
    
    @IBAction func showChooseList(sender: UIButton) {
        let dialog = CZPickerView(headerTitle: "Choose temperture or humidity", cancelButtonTitle: "Cancel", confirmButtonTitle: "OK")
        
        dialog.delegate = self
        dialog.dataSource = self
        dialog.needFooterView = true
        dialog.show()
    }
    
    
    @IBAction func doneConfigLabel(sender: AnyObject) {
        
        let control = (temp as! CustomLabel).control
        
        if tempertureBtn.titleLabel?.text == "Temperture" {
            control!["isTemperture"] = true
        } else if tempertureBtn.titleLabel?.text == "Humidity"{
            control!["isTemperture"] = false
        } else {
            
        }
        
        if self.labelDeviceBtn.titleLabel?.text != "???" {
            control!["DeviceId"] = labelDeviceBtn.titleLabel?.text
        }
        
        control!.saveInBackground()
        
        if isChooseDevice {
            isChooseDevice = false
            UIView.animateWithDuration(0.2, animations: {
                self.blackView.alpha = 0.0
                self.configLabel.transform = CGAffineTransformMakeScale(0.1, 0.1)
                self.deviceView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 200)}, completion: {conplete in
                    self.deviceView.hidden = true
                    self.configLabel.hidden = true
                    self.blackView.removeFromSuperview()})
        } else {
            UIView.animateWithDuration(0.2, animations: {
                self.blackView.alpha = 0.0
                self.configLabel.transform = CGAffineTransformMakeScale(0.1, 0.1)}, completion: {conplete in
                    self.configLabel.hidden = true
                    self.blackView.removeFromSuperview()})
        }
        
    }
    
    
    @IBAction func cancelConfigLabel(sender: AnyObject) {
        
        if isChooseDevice {
            isChooseDevice = false
            UIView.animateWithDuration(0.2, animations: {
                self.blackView.alpha = 0.0
                self.configLabel.transform = CGAffineTransformMakeScale(0.1, 0.1)
                self.deviceView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 200)}, completion: {conplete in
                    self.deviceView.hidden = true
                    self.configLabel.hidden = true
                    self.blackView.removeFromSuperview()})
        } else {
            UIView.animateWithDuration(0.2, animations: {
                self.blackView.alpha = 0.0
                self.configLabel.transform = CGAffineTransformMakeScale(0.1, 0.1)}, completion: {conplete in
                    self.configLabel.hidden = true
                    self.blackView.removeFromSuperview()})
        }
        
    }
    
    
}

extension ControlView: CZPickerViewDelegate, CZPickerViewDataSource {
    
    func czpickerView(pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        return nil
    }
    
    func numberOfRowsInPickerView(pickerView: CZPickerView!) -> Int {
        return 2
    }
    
    func czpickerView(pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        if row == 0 {
            return "Temperture"
        } else {
            return "Humidity"
        }
    }
    
    func czpickerView(pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        if row == 0 {
            tempertureBtn.setTitle("Temperture", forState: .Normal)
            let control = (temp as! CustomLabel).control
            
            control!["isTemperture"] = true
            control?.saveInBackground()
        } else {
            tempertureBtn.setTitle("Humidity", forState: .Normal)
            
            let control = (temp as! CustomLabel).control
            control!["isTemperture"] = false
            control?.saveInBackground()
        }
    }
}

extension ControlView: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ControlView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DeviceArray.IRarray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (DeviceArray.IRarray[row]["DeviceId"] as! String)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let device = DeviceArray.IRarray[row]
        chooseDeviceBtn.setTitle(device["DeviceId"] as? String, forState: UIControlState.Normal)
        labelDeviceBtn.setTitle(device["DeviceId"] as? String, forState: UIControlState.Normal)
        
        if let file = device["Icon"] as? PFFile {
            deviceIcon.file = file
            deviceIcon.loadInBackground()
        } else {
            deviceIcon.backgroundColor = UIColor.grayColor()
        }
        
        deviceName.text = device["Name"] as? String
        
        self.learnBtn.enabled = true
    }
    
}

extension ControlView: CocoaMQTTDelegate {
    func mqtt(mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("didConnect \(host):\(port)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnect Ack")
        
    }
    
    func mqtt(mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage with message: \(message.string)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck with id: \(id)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("receive message on ControlView")
        
        if let view = temp as? ButtonSend {
            let deviceId = view.control!["DeviceId"] as! String
            let topicIr = deviceId + "/input"
            
            if message.topic == topicIr {
                irCode = message.string
            }
        } else {
            let view = (temp as! CustomLabel)
            let deviceId = view.control!["DeviceId"] as! String
            let topicTemp = deviceId + "/temp"
            
            if message.topic == topicTemp {
                
            } else {
                
            }
        }
    }
    
    func mqtt(mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic to \(topic)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("didUnsubscribeTopic to \(topic)")
    }
    
    func mqttDidPing(mqtt: CocoaMQTT) {
        print("didPing")
    }
    
    func mqttDidReceivePong(mqtt: CocoaMQTT) {
        _console("didReceivePong")
    }
    
    func mqttDidDisconnect(mqtt: CocoaMQTT, withError err: NSError?) {
        _console("mqttDidDisconnect")
    }
    
    func _console(info: String) {
        print("Delegate: \(info)")
    }
}
