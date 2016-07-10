//
//  AddActionViewController.swift
//  DemoMQTT
//
//  Created by mac on 5/31/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse

class AddActionViewController: UIViewController {
    
    @IBOutlet weak var controlView: UIScrollView!
    
    var controls: [Control] = [Control]()
    var controlBtnView: [ButtonSend] = [ButtonSend]()
    
    var controlChoosedView: [ButtonSend] = [ButtonSend]()
    
    var intervalLabel: [UILabel] = [UILabel]()
    
    weak var temp: ButtonSend!
    
    var originPoint: CGPoint?
    
    var deviceID: String?
    
    let distanceBetweenTowControl = 60
    
    
    
    var action: TimeAction!
    
    var currentActionID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addControl()
        //self.addChooseControlView()
//        let query = TimeAction.query()
//        
//        query?.whereKey("objectId", equalTo: currentActionID!)
//        
//        query?.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) in
//            
//            self.action = object as! TimeAction
//            
//        })

        //deviceID = currentAction!["DeviceId"] as? String

    }

    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Loading..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    
    func addChooseControlView() {
        
        let objectID: [String]? = action["objectID"] as? [String]
        let intervals: [String]? = action["TimeInterval"] as? [String]
        let n: Int
        
        if objectID == nil {
            
        } else {
            n = objectID!.count
            
            for i in 0...(n-1) {
                
                let id = objectID![i]
                let button = ButtonSend(type: UIButtonType.System)
                button.customInit()
                button.backgroundColor = UIColor.redColor()
                button.frame = CGRectMake(50*CGFloat(i) + CGFloat(distanceBetweenTowControl*i) + 20, 10, 50, 50)
                
                self.controlView.addSubview(button)
                self.controlChoosedView.append(button)
                
                if i != 0 {
                    let interval = UILabel()
                    
                    interval.frame.size = CGSize(width: 28, height: 22)
                    interval.center = CGPoint(x: button.frame.origin.x - CGFloat(distanceBetweenTowControl/2), y: button.center.y)
                    interval.text = intervals![i - 1]
                    interval.textAlignment = .Center
                    interval.sizeToFit()
                    interval.userInteractionEnabled = true
                    let tap = UITapGestureRecognizer(target: self, action: #selector(AddActionViewController.addInterval(_:)))
                    interval.addGestureRecognizer(tap)
                    self.controlView.addSubview(interval)
                    self.intervalLabel.append(interval)
                    
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                    
                    var colorIndex = 0
                    var name = ""
                    
                    for i in 0...(self.controlBtnView.count - 1) {
                        
                        if id == self.controlBtnView[i].control?.objectId {
                            
                            colorIndex = self.controlBtnView[i].control!["Color"] as! Int
                            name = self.controlBtnView[i].control!["Name"] as! String
                            button.control = self.controlBtnView[i].control
                            
                            break;
                            
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        button.backgroundColor = Color.color[colorIndex]
                        button.layer.borderColor = Color.color[colorIndex].CGColor
                        
                        button.setTitle(name, forState: .Normal)
                    })
                    
                })
            }
        }
        
        
        
        
    }
    
    func addControl() {
        let query = Control.query()
        query?.whereKey("DeviceId", equalTo:deviceID!)
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
                    
                    let pan = UIPanGestureRecognizer(target: self, action: #selector(ControlView.pan(_:)))
                    
                    button.addGestureRecognizer(pan)
                    button.control = object
                    
                    self.controlBtnView.append(button)
                    self.view.addSubview(button)
                    
                } else {
                    
                }
            }
            self.addChooseControlView()
            self.hideLoadingHUD()
        })
    }

    func pan(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            print("began")
            let view = sender.view as! ButtonSend
            let button = ButtonSend(type: UIButtonType.System)
            button.customInit()
            button.setTitle(view.titleLabel?.text, forState: UIControlState.Normal)
            // create a shadow of this button
            button.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 45, 45)
            button.alpha = 0.5
            button.layer.borderColor = view.layer.borderColor
            button.backgroundColor = view.backgroundColor
            self.view.addSubview(button)
            temp = button
        }
        
        if sender.state == UIGestureRecognizerState.Changed {
            print("change")
            let translation = sender.translationInView(self.view)
            
            temp.center = CGPoint(x: temp.center.x + translation.x, y: temp.center.y + translation.y)
            
            sender.setTranslation(CGPointZero, inView: self.view)
            
            
            if temp.center.y < 89 {
                temp.alpha = 1.0
                temp.frame.size = CGSize(width: 50, height: 50)
            } else {
                temp.alpha = 0.5
                temp.frame.size = CGSize(width: 45, height: 45)
            }
            
        }
        
        if sender.state == UIGestureRecognizerState.Ended {
            
            if temp.center.y < 89 {
                let index = controlChoosedView.count
                temp.removeFromSuperview()
                let pan = UIPanGestureRecognizer(target: self, action: #selector(AddActionViewController.HandelPan(_:)))
                temp.frame = CGRectMake(50*CGFloat(index) + CGFloat(distanceBetweenTowControl*index) + 20, 10, 50, 50)
                
                temp.addGestureRecognizer(pan)
                self.controlView.addSubview(temp)
                temp.control = (sender.view as! ButtonSend).control
                self.controlChoosedView.append(temp)
                
                if index != 0 {
                    let interval = UILabel()
                    
                    interval.frame.size = CGSize(width: 28, height: 22)
                    interval.center = CGPoint(x: temp.frame.origin.x - CGFloat(distanceBetweenTowControl/2), y: temp.center.y)
                    interval.text = "000"
                    interval.sizeToFit()
                    interval.userInteractionEnabled = true
                    let tap = UITapGestureRecognizer(target: self, action: #selector(AddActionViewController.addInterval(_:)))
                    interval.addGestureRecognizer(tap)
                    self.controlView.addSubview(interval)
                    self.intervalLabel.append(interval)

                }
                let width = 50*index + distanceBetweenTowControl*index + 70
                self.controlView.contentSize = CGSize(width: width, height: 69)
                temp = nil
        
                // add interval between two view
                
                
 
            } else {
                temp.removeFromSuperview()
                temp = nil
            }
            
        }
        
    }
    
    func addInterval(sender: UITapGestureRecognizer) {
        
        let input = UIAlertController.alertControllerWithNumberInput("Interval Time", message: "Enter an interval between two control", buttonTitle: "OK") {
            intervalString in
            
            guard let interval = intervalString where interval != "" else {
                return
            }
            
            (sender.view as! UILabel).text = interval
            
        }
        presentViewController(input, animated: true, completion: nil)
    }
    
    func HandelPan(sender: UIPanGestureRecognizer) {

        if sender.state == UIGestureRecognizerState.Began {
            originPoint = sender.view!.center
        }
        
        if sender.state == UIGestureRecognizerState.Changed {
            
            let translation = sender.translationInView(self.view)
            
            sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
            
            sender.setTranslation(CGPointZero, inView: self.view)
            
        }
        
        if sender.state == UIGestureRecognizerState.Ended {
            if sender.view?.center.y > 89 {
                if let index = self.controlChoosedView.indexOf((sender.view! as? ButtonSend)!) {
                    if index == controlChoosedView.count - 1 {
                        self.controlChoosedView.removeLast()
                        if self.controlChoosedView.count != 0 {
                            self.intervalLabel.last?.removeFromSuperview()
                            self.intervalLabel.removeLast()
                        }
                        
                    } else {
                        if index == 0 {
                            self.intervalLabel.first?.removeFromSuperview()
                            self.intervalLabel.removeFirst()
                        } else {
                            self.intervalLabel[index - 1].removeFromSuperview()
                            self.intervalLabel.removeAtIndex(index - 1)
                        }
                        self.controlChoosedView.removeAtIndex(index)
                        
                        processView(index)
                    }
                    
                    sender.view?.removeFromSuperview()
                    let width = 50*index + distanceBetweenTowControl*index + 70
                    self.controlView.contentSize = CGSize(width: width, height: 69)
                    
                }
                originPoint = nil
            } else {
                sender.view?.center = originPoint!
                originPoint = nil
            }
        }
        
    }
    
    func processView(index: Int) {
        let length = self.controlChoosedView.count
        for i in index...(length - 1) {
            self.controlChoosedView[i].frame.origin.x = 20 + 50*CGFloat(i) + CGFloat(distanceBetweenTowControl*i)
            if i != 0 {
                self.intervalLabel[i - 1].center.x = self.controlChoosedView[i].frame.origin.x - CGFloat(distanceBetweenTowControl/2)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            if let des = segue.destinationViewController as? ActionTableViewController {
                
                action.removeObjectForKey("objectID")
                action.removeObjectForKey("TimeInterval")
                let n = controlChoosedView.count
                
                var codeTosend = ""
                
                if n == 1 {
                    codeTosend += controlChoosedView[0].control!["IRCode"] as! String
                    codeTosend += "/"
                    codeTosend += "0"
                    
                } else {
                    for i in 0...(n-1) {
                        
                        action.addObject((controlChoosedView[i].control?.objectId)!, forKey: "objectID")
                        if i == n - 1 {
                            codeTosend += controlChoosedView[i].control!["IRCode"] as! String
                            codeTosend += "/"
                            codeTosend += "0"
                        } else {
                            codeTosend += controlChoosedView[i].control!["IRCode"] as! String
                            codeTosend += "/"
                            codeTosend += intervalLabel[i].text!
                            codeTosend += "-"
                            action.addObject(intervalLabel[i].text!, forKey: "TimeInterval")
                        }
                    }
                }
                
                action["ExcuteCode"] = codeTosend
                action.saveInBackground()
                
                des.dataBack = codeTosend
            }
        
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
