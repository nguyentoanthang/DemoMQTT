//
//  ConfigtionIRView.swift
//  DemoMQTT
//
//  Created by mac on 4/27/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit

class ConfigtionIRView: UIViewController {

    @IBOutlet weak var deviceView: UIView!
    
    @IBAction func donePicker(sender: AnyObject) {
    }
    
    @IBOutlet weak var picker: UIPickerView!
    
    
    var codeType: String?
    
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var code: UITextField!
    
    // picker View
    var actionView: UIView = UIView()
    var window: UIWindow? = nil

    var pickerView: UIView!
    var alertcontrol: UIAlertController!
    var colorView = UIView()
    var blurEffect = UIBlurEffect(style: .Dark)
    var blurView = UIVisualEffectView()
    var array: [IRDevice] = []
    
    @IBAction func cancelPicker(sender: AnyObject) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.deviceView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 200)
            self.blurView.alpha = 0}, completion: {a in
                self.blurView.removeFromSuperview()
                self.deviceView.hidden = true})
    }
    

    @IBAction func learn(sender: UIButton) {
        
    }
    
    func createPickerViewWithAlertController() {
       /*
        self.pickerView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 200))
        
        self.pickerView.backgroundColor = UIColor.clearColor()
        
        self.devicePicker = UIPickerView(frame: CGRectMake(0, 0, self.view.frame.width, 200))
        self.devicePicker.dataSource = self
        self.devicePicker.delegate = self
        
        self.pickerView.addSubview(self.devicePicker)
        
        alertcontrol = UIAlertController(title: "Choose Device", message: "Choose a device to attach", preferredStyle: .ActionSheet)
        
        alertcontrol.view.addSubview(pickerView)
        
        // cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            action in
            return
        }
        
        alertcontrol.addAction(cancelAction)
        
        // OK Action
        let OKAction = UIAlertAction(title: "OK", style: .Default) {
            action in
            return
        }
        
        alertcontrol.addAction(OKAction)
 */
    }
    
    @IBAction func ChoseDevice(sender: DCBorderedButton) {
        
        deviceView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 200)
        deviceView.hidden = false
        
        self.blurView.effect = blurEffect
        self.blurView.frame = self.view.frame
        //deviceView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(blurView)
        blurView.alpha = 0
        self.deviceView.layer.zPosition = 1
        UIView.animateWithDuration(0.4, animations: {
            self.blurView.alpha = 1.0
        self.deviceView.frame = CGRectMake(0, 368, UIScreen.mainScreen().bounds.size.width, 200)})
      
        
        //self.presentViewController(alertcontrol, animated: true) {}
        /*
        let kSCREEN_WIDTH  =    UIScreen.mainScreen().bounds.size.width
        
        picker.frame = CGRectMake(0.0, 44.0, kSCREEN_WIDTH, 216.0)
        picker.dataSource = self
        picker.delegate = self
        picker.showsSelectionIndicator = true;
        picker.backgroundColor = UIColor.lightGrayColor()
        
        var pickerDateToolbar = UIToolbar(frame: CGRectMake(0, 0, kSCREEN_WIDTH, 44))
        pickerDateToolbar.barStyle = UIBarStyle.Black
        pickerDateToolbar.barTintColor = UIColor.whiteColor()
        pickerDateToolbar.translucent = true
        
        var barItems: [UIBarButtonItem] = []

        let titleCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(self.cancelPickerSelectionButtonClicked(_:)))
        barItems.append(titleCancel)
        
        var flexSpace: UIBarButtonItem
        flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        flexSpace.width = 20.0
        barItems.append(flexSpace)
        
        picker.selectRow(0, inComponent: 0, animated: false)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(self.doneClicked(_:)))
        barItems.append(doneBtn)
        
        pickerDateToolbar.setItems(barItems, animated: true)
        
        actionView.addSubview(pickerDateToolbar)
        actionView.addSubview(picker)
        
        if ((window) != nil) {
            window!.addSubview(actionView)
        }
        else
        {
            self.view.addSubview(actionView)
        }
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 260.0, UIScreen.mainScreen().bounds.size.width, 260.0)
            
        })
    */
    }
    
    func doneClicked(sender: UIBarButtonItem) {
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 260.0)
            
            }, completion: { _ in
                for obj: AnyObject in self.actionView.subviews {
                    if let view = obj as? UIView
                    {
                        view.removeFromSuperview()
                    }
                }
        })
    }
    
    func cancelPickerSelectionButtonClicked(sender: UIBarButtonItem) {
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 260.0)
            
            }, completion: { _ in
                for obj: AnyObject in self.actionView.subviews {
                    if let view = obj as? UIView
                    {
                        view.removeFromSuperview()
                    }
                }
        })
    }
    
    func handelTap(tap: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.4, animations: {
            self.deviceView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 200)
            self.blurView.alpha = 0}, completion: {a in
                self.deviceView.hidden = true
        self.blurView.removeFromSuperview()})
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        type.text = codeType
        blurView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handelTap(_:)))
        blurView.addGestureRecognizer(tap)
        
        /*
        var delegate = UIApplication.sharedApplication()
        var myWindow: UIWindow? = delegate.keyWindow
        var myWindow2: NSArray = delegate.windows
        
        if let myWindow: UIWindow = UIApplication.sharedApplication().keyWindow
        {
            window = myWindow
        }
        else
        {
            window = myWindow2[0] as? UIWindow
        }
        
        
        actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 260.0)
        */
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ConfigtionIRView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DeviceArray.IRarray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (DeviceArray.IRarray[row]["DeviceId"] as! String)
    }
    
}
