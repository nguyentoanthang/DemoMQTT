//
//  ControlView.swift
//  DemoMQTT
//
//  Created by mac on 4/26/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit

class ControlView: UIViewController {

    var isShow: Bool = false
    var isChooseDevice: Bool = false
    var controls:[UIView] = []
    
    @IBOutlet weak var chooseDeviceBtn: DCBorderedButton!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var deviceView: UIView!
    var selectedButton: ButtonSend?
    // the scene contain controls
    var currentScene: Scene!
    
    @IBOutlet weak var configView: UIView!
    @IBOutlet weak var controlView: UIView!
    let blurEffect = UIBlurEffect(style: .Light)
    let blurView = UIVisualEffectView()
    let blackView = UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // config black View
        // config the view
        blackView.frame = UIScreen.mainScreen().bounds
        blackView.backgroundColor = UIColor.blackColor()
        blackView.alpha = 0.0
        
        controlView.hidden = true
        let backgroundImageView = UIImageView(image: currentScene.image)
        backgroundImageView.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(backgroundImageView)
        
        blurView.effect = blurEffect
        blurView.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(blurView)
        
        // add tap gesture recognite to blur view
        let tap = UITapGestureRecognizer(target: self, action: #selector(ControlView.blurViewTap(_:)))
        blurView.addGestureRecognizer(tap)
        //self.view.addSubview(blurView)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.clearColor()
        
        // set translucent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(sender: AnyObject) {
        
        self.configView.transform = CGAffineTransformMakeScale(1, 1)
        self.configView.hidden = false
        UIView.animateWithDuration(0.2, animations: {
            self.blackView.alpha = 0.0
            self.configView.transform = CGAffineTransformMakeScale(0.1, 0.1)}, completion: {
                conplete in
                self.blackView.removeFromSuperview()
                self.configView.hidden = true})   
        
    }
    
    // this function show a choose device View at bottom of screen
    @IBAction func chooseDevice(sender: AnyObject) {
        
        
        if isChooseDevice == false {
            isChooseDevice = true
            deviceView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 200)
            deviceView.hidden = false
            
            UIView.animateWithDuration(0.2, animations: {
                self.configView.transform = CGAffineTransformMakeTranslation(0, -100)
                self.deviceView.frame = CGRectMake(0, 368, UIScreen.mainScreen().bounds.size.width, 200)})
        } else {
            isChooseDevice = false
            UIView.animateWithDuration(0.2, animations: {
                self.configView.transform = CGAffineTransformMakeTranslation(0, 0)
                self.deviceView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 200)}, completion: { (complete) in
                    self.deviceView.hidden = true
            })
        }
        
        
        
    }
    @IBAction func cancel(sender: AnyObject) {
        
        self.configView.transform = CGAffineTransformMakeScale(1, 1)
        self.configView.hidden = false
        UIView.animateWithDuration(0.2, animations: {
            self.blackView.alpha = 0.0
            self.configView.transform = CGAffineTransformMakeScale(0.1, 0.1)}, completion: {conplete in self.configView.hidden = true
        self.blackView.removeFromSuperview()})
        
    }
    
    func blurViewTap(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.3, animations: {self.controlView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, self.controlView.frame.height)}) { (complete) in
            self.controlView.hidden = true
        }
    }
    
    @IBAction func addButton(sender: ButtonSend) {
        
        let button = ButtonSend(type: UIButtonType.System)
        button.frame = CGRectMake(100, 100, 50, 50)
        button.customInit()
        button.setTitle("?", forState: UIControlState.Normal)
        button.codeType = "SONY"
        
        self.view.addSubview(button)
        controls.append(button)
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(ControlView.long(_:)))
   
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(_:)))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ControlView.handelTap(_:)))
        tap.delegate = self
        tap.requireGestureRecognizerToFail(longpress)
        
        button.addGestureRecognizer(tap)
        button.addGestureRecognizer(longpress)
        button.addGestureRecognizer(pan)
    
        controls.append(button)
    }
    
    func handelTap(sender: UITapGestureRecognizer) {
        print("Tap")
    }
    
    func showActionSheet() {
        
        let actionSheet = UIAlertController(title: "Action", message: "choose your action", preferredStyle: .ActionSheet)
        
        let 💛 = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        let 💚 = UIAlertAction(title: "Config", style: .Default) { (action) in
        
            self.view.addSubview(self.blackView)
            //self.blackView.layer.zPosition = 1
            
            self.view.bringSubviewToFront(self.configView)
            self.view.bringSubviewToFront(self.deviceView)
                self.configView.transform = CGAffineTransformMakeScale(0.1, 0.1)
                self.configView.hidden = false
                UIView.animateWithDuration(0.2, animations:
                    {self.blackView.alpha = 0.7
                    self.configView.transform = CGAffineTransformMakeScale(1, 1)})
            
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
            self.showColor()
        }
        
        actionSheet.addAction(💛)
        actionSheet.addAction(💚)
        actionSheet.addAction(💜)
        actionSheet.addAction(💙)
        
        presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    func showColor() {
        
    }
    
    func pan(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            print("began")
        }
        
        if sender.state == UIGestureRecognizerState.Changed {
            print("change")
        }
        
        if sender.state == UIGestureRecognizerState.Ended {
            print("end")
        }
        let translation = sender.translationInView(self.view)
        if let view = sender.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        sender.setTranslation(CGPointZero, inView: self.view)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            if let des = segue.destinationViewController as? ConfigtionIRView {
                let a = sender as? ButtonSend
                des.codeType = a!.codeType
                des.hidesBottomBarWhenPushed = true
                des.title = "Button"
            }
        }
    }
    
    func long(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Began {
            //let button = sender.view as? ButtonSend
            //self.performSegueWithIdentifier("detail", sender: button)
            selectedButton = sender.view as? ButtonSend
            showActionSheet()
        } else if sender.state == UIGestureRecognizerState.Ended {
            print("end")
        }
        
    }
    
    @IBAction func showView(sender: AnyObject) {
        controlView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, controlView.frame.height)
        controlView.hidden = false
        self.view.bringSubviewToFront(controlView)
        
        UIView.animateWithDuration(0.3) { 
            self.controlView.frame = CGRectMake(0, 508, UIScreen.mainScreen().bounds.size.width, self.controlView.frame.height)
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
        chooseDeviceBtn.setTitle(DeviceArray.IRarray[row]["DeviceId"] as? String, forState: UIControlState.Normal)
        print(self.configView.frame)
    }
    
}
