//
//  SceneView.swift
//  DemoMQTT
//
//  Created by mac on 4/26/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit
import Parse.PFUser
import MBProgressHUD
import CocoaMQTT

class SceneView: UICollectionViewController, UIGestureRecognizerDelegate {
    
    var sellectedSceneIndexPath: NSIndexPath!
    
    var reachability: Reachability?
    
    override func viewWillAppear(animated: Bool) {
        print("view will appear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.colorFromHex("#53802d")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.collectionView?.backgroundColor = UIColor.colorFromHex("#d3ffce")
        Connection.instance.mqtt?.delegate = self
        // Do any additional setup after loading the view.
        

        
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create reachability")
        }
        
        if let reachability = reachability {
            if reachability.isReachable() {
                
                if PFUser.currentUser() != nil {
                    showLoadingHUD()
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { 
                        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.handelLongpress(_:)))
                        
                        longpress.delegate = self
                        self.collectionView?.addGestureRecognizer(longpress)
                        //excute all of work before loading UI
                        DeviceArray.createArray()
                        SceneArray.createScene()
                        Connection.instance.connect()
                        dispatch_async(dispatch_get_main_queue(), { 
                            self.hideLoadingHUD()
                            self.collectionView?.reloadData()
                        })
                    })
                }
            } else {
                
            }
        }
        
    }
    
    
    func handelLongpress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            return
        }
        
        if sender.state == UIGestureRecognizerState.Began {
            let p = sender.locationInView(self.collectionView)
            
            if let indexPath: NSIndexPath = self.collectionView?.indexPathForItemAtPoint(p) {
                self.sellectedSceneIndexPath = indexPath
                showChoosePicture()
            }
        }    
        
    }
    
    func showChoosePicture() {
        let actionSheet = UIAlertController(title: "Choose", message: "Choose a picture or take from camera", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            action in
            return
        }
        
        let chooseAction = UIAlertAction(title: "Open library", style: .Default) {
            action in
            self.showLibrary()
            return
        }
        
        let camera = UIAlertAction(title: "Camera", style: .Default) {
            action in
            self.showCamera()
            return
        }
        
        let delete = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            
            // delete scene and all control of this scene
            
            
            let confirm = UIAlertController(title: "Delete this scene", message: "This action can't be undo", preferredStyle: .Alert)
            
            let ok = UIAlertAction(title: "Yes", style: .Default, handler: { (action) in
                // delete
                
                let scene = SceneArray.array[self.sellectedSceneIndexPath.row]
                
                self.showLoadingHUD()
                
                let query = Control.query()
                query?.whereKey("SceneId", equalTo: scene.objectId!)
                
                query?.findObjectsInBackgroundWithBlock({ (object: [PFObject]?, error: NSError?) in
                    
                    PFObject.deleteAllInBackground(object)
                    
                    scene.deleteInBackground()
                    
                    let index = SceneArray.array.indexOf(scene)
                    
                    SceneArray.array.removeAtIndex(index!)
                    
                    self.collectionView?.reloadData()
                    self.hideLoadingHUD()
                    
                })
                
                
            })
            
            let cancel = UIAlertAction(title: "No", style: .Default, handler: nil)
            
            confirm.addAction(cancel)
            confirm.addAction(ok)
            
            self.presentViewController(confirm, animated: true, completion: nil)
            
        }
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(chooseAction)
        actionSheet.addAction(camera)
        actionSheet.addAction(delete)
        
        presentViewController(actionSheet, animated: true) {
            
        }
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showLibrary() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Loading..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    func raiseError() {
        
    }
    
    @IBAction func addScene(sender: UIBarButtonItem) {
        
        let alert = UIAlertController.alertControllerWithStringInput("Add Scene", message: "Enter name of scene", buttonTitle: "OK") { value in
            guard let _name = value where _name != "" else {
                return
            }
            self.showLoadingHUD()
            let scene = Scene(name: _name, email: (PFUser.currentUser()?.email)!)
            
            scene.saveInBackgroundWithBlock() {(successed: Bool, error: NSError?) -> Void in
                if successed == true {
                    SceneArray.array.append(scene)
                    self.collectionView?.reloadData()
                    print("success")
                    self.hideLoadingHUD()
                    return
                } else {
                    print("error")
                    self.raiseError()
                    self.hideLoadingHUD()
                    return
                }}
        }
        presentViewController(alert, animated: true) {}
    }
    
    override func viewDidAppear(animated: Bool) {
        let currentUser = PFUser.currentUser()
        
        if currentUser == nil {
            performSegueWithIdentifier("login", sender: nil)
        } else {
            if reachability?.currentReachabilityStatus == Reachability.NetworkStatus.NotReachable {
                // present view controller here
                let alert = UIAlertController(title: "No internet connection", message: "You must connect to the internet to use this app", preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    
    @IBAction func loginSuccess(segue: UIStoryboardSegue) {
        print("login success")
        if PFUser.currentUser() != nil {
            showLoadingHUD()
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                let longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.handelLongpress(_:)))
                
                longpress.delegate = self
                self.collectionView?.addGestureRecognizer(longpress)
                //excute all of work before loading UI
                DeviceArray.createArray()
                SceneArray.createScene()
                Connection.instance.connect()
                dispatch_async(dispatch_get_main_queue(), {
                    self.hideLoadingHUD()
                    self.collectionView?.reloadData()
                })
            })
        }
        
    }

    // collectionView data source
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SceneArray.array.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SceneCell", forIndexPath: indexPath) as! SceneCell
        
        let scene: Scene? = SceneArray.array[indexPath.row]
        if let scene = scene {
            cell.currentScene = scene
        }
        
        // Configure the cell
        return cell
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    // collectionView Delegate
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        let cellSize = CGSizeMake(260/320*UIScreen.mainScreen().bounds.width, 380/568*UIScreen.mainScreen().bounds.height)
        return cellSize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSizeMake(0, 25/568*(UIScreen.mainScreen().bounds.height))
        
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //sellectedSceneIndex = indexPath.row
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show" {
        if let destinationViewController = segue.destinationViewController as? ControlView {
                if let cell = sender as? SceneCell {
                let index = collectionView?.indexPathForCell(cell)
                if let index = index {
                    destinationViewController.currentSceneID = SceneArray.array[index.row].objectId
                }
            }
            
            }
        }
    }
}

extension SceneView: CocoaMQTTDelegate {
    
    func mqtt(mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("didConnect \(host):\(port)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnect Ack")
        if ack == .ACCEPT {
            for device in DeviceArray.IRarray {
                mqtt.subscribe((device["DeviceId"] as! String) + "/input")
            }
            
            for device in DeviceArray.DHTArray {
                mqtt.subscribe((device["DeviceId"] as! String) + "/temp")
                mqtt.subscribe((device["DeviceId"] as! String) + "/humi")
            }
            mqtt.ping()
        }
        
    }
    
    func mqtt(mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage with message: \(message.string)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck with id: \(id)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("didReceivedMessage: \(message.string!) with id \(id) in topic \(message.topic)")
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

extension SceneView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        dismissViewControllerAnimated(true, completion: nil)
        if let 🗻 = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let cell = collectionView!.cellForItemAtIndexPath(sellectedSceneIndexPath) as! SceneCell
            
            cell.image.image = 🗻
            let data = UIImageJPEGRepresentation(🗻, 0.5)
            let imageFile = PFFile(name: "icon.png", data: data!)
            
            SceneArray.array[sellectedSceneIndexPath.row]["Image"] = imageFile
            SceneArray.array[sellectedSceneIndexPath.row].saveInBackground()
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
