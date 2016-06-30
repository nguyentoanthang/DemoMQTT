//
//  ControlView.swift
//  DemoMQTT
//
//  Created by mac on 4/26/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit
import MBProgressHUD
import Async
import Parse
import ParseUI
import CocoaMQTT

class ControlView: UIViewController {

    var isShow: Bool = false
    var isChooseDevice: Bool = false
    var controls: [Control] = [Control]()
    var controlLabelView: [UILabel] = []
    var controlBtnView: [ButtonSend] = []
    weak var temp: UIView!
    //weak var controlTemp: Control?

    @IBOutlet weak var chooseColorView: UIView!
    @IBOutlet weak var nameBtn: UITextField!
    @IBOutlet weak var typeName: UILabel!
    
    @IBOutlet weak var deviceIcon: PFImageView!
    
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var chooseDeviceBtn: DCBorderedButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var deviceView: UIView!
    weak var selectedButton: ButtonSend?
    // the scene contain controls
    weak var currentScene: Scene!
    
    // Label config view
    @IBOutlet weak var configLabel: UIView!
    @IBOutlet weak var isTemp: UISwitch!
    
    
    
    
    
    @IBOutlet weak var configView: UIView!
    @IBOutlet weak var controlView: UIView!
    let blackView = UIView()

    func addControl() {
        let query = Control.query()
        query?.whereKey("SceneId", equalTo: self.currentScene.objectId!)
        showLoadingHUD()
        query?.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) in
            self.controls = objects as! [Control]
            for object in self.controls {
                if object["Type"] as! Int == 0 {
                    let button = ButtonSend(type: UIButtonType.System)
                    button.customInit()
                    button.setTitle("?", forState: .Normal)
                    button.frame = CGRectMake(object["X"] as! CGFloat, object["Y"] as! CGFloat, 50, 50)
                    
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
        
        // save control
        selectedButton?.control!["Name"] = nameBtn.text
        
        if chooseDeviceBtn.titleLabel?.text != "???" {
            selectedButton?.control!["DeviceId"] = chooseDeviceBtn.titleLabel?.text
        }
        
        selectedButton?.control?.saveInBackground()
        
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
                
                // save control to parse.com
                let control = Control(type: 1, sceneID: self.currentScene.objectId!)
                
                let longpress = UILongPressGestureRecognizer(target: self, action: #selector(ControlView.long(_:)))
                
                let pan = UIPanGestureRecognizer(target: self, action: #selector(ControlView.pan(_:)))

                temp.addGestureRecognizer(longpress)
                temp.addGestureRecognizer(pan)
                temp.userInteractionEnabled = true
                (temp as! CustomLabel).control = control
                
                controlLabelView.append(temp as! UILabel)
                
                let y = (self.navigationController?.navigationBar.frame.origin.y)! + (self.navigationController?.navigationBar.frame.height)!
                
                if temp.frame.origin.y < y {
                    temp.center = CGPoint(x: temp.center.x, y: y + temp.frame.height/2)
                }
                
                control["X"] = temp.frame.origin.x
                control["Y"] = temp.frame.origin.y
                control.saveInBackground()
                
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
                let control = Control(type: 0, sceneID: self.currentScene.objectId!)
                
                let longpress = UILongPressGestureRecognizer(target: self, action: #selector(ControlView.long(_:)))
                
                let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(_:)))
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(ControlView.handelTap(_:)))
                tap.delegate = self
                tap.requireGestureRecognizerToFail(longpress)
                tap.requireGestureRecognizerToFail(pan)
                
                temp.addGestureRecognizer(tap)
                temp.addGestureRecognizer(longpress)
                temp.addGestureRecognizer(pan)
                (temp as! ButtonSend).control = control
                
                controlBtnView.append(temp as! ButtonSend)
                
                let y = (self.navigationController?.navigationBar.frame.origin.y)! + (self.navigationController?.navigationBar.frame.height)!

                if temp.frame.origin.y < y {
                    temp.center = CGPoint(x: temp.center.x, y: y + temp.frame.height/2)
                }
                
                control["X"] = temp.frame.origin.x
                control["Y"] = temp.frame.origin.y
                control.saveInBackground()

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
        
        switch sender.tag {
        case 100:
            selectedButton?.backgroundColor = UIColor.redColor()
            break
        case 101:
            selectedButton?.backgroundColor = UIColor.brownColor()
            break
        case 103:
            selectedButton?.backgroundColor = UIColor.blueColor()
            break
        default:
            break
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
                self.showConfigView(self.configView)
            } else {
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
            self.selectedButton?.alpha = 0.5
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
        controlView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, controlView.frame.height)
        controlView.hidden = false
        self.view.addSubview(self.blackView)
        self.view.bringSubviewToFront(controlView)
        
        UIView.animateWithDuration(0.3) { 
            self.controlView.frame = CGRectMake(0, 508, UIScreen.mainScreen().bounds.size.width, self.controlView.frame.height)
        }
    }
    
    @IBAction func LearnIRCode(sender: AnyObject) {
        Connection.instance.mqtt?.publish("example1", withString: "first publish")
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
        
        if let file = device["Icon"] as? PFFile {
            deviceIcon.file = file
            deviceIcon.loadInBackground()
        } else {
            deviceIcon.backgroundColor = UIColor.grayColor()
        }
        
        deviceName.text = device["Name"] as? String
        
        print(self.configView.frame)
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
