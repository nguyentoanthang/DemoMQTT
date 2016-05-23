//
//  SceneView.swift
//  DemoMQTT
//
//  Created by mac on 4/26/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit
import Parse.PFUser
import Async
import MBProgressHUD

class SceneView: UICollectionViewController, UIGestureRecognizerDelegate {
    
    var sellectedSceneIndexPath: NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.colorFromHex("#53802d")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.collectionView?.backgroundColor = UIColor.colorFromHex("#d3ffce")
        showLoadingHUD()
        // Do any additional setup after loading the view.
        //PFUser.logOut()
        
        if PFUser.currentUser() != nil {
            Async.background {
                let longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.handelLongpress(_:)))
                
                longpress.delegate = self
                self.collectionView?.addGestureRecognizer(longpress)
                //excute all of work before loading UI
                DeviceArray.createArray()
                SceneArray.createScene()
                }.main {
                    self.hideLoadingHUD()
                    self.collectionView?.reloadData()
            }
            
            print("")
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
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(chooseAction)
        actionSheet.addAction(camera)
        
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
        }
    }
    
    @IBAction func loginSuccess(segue: UIStoryboardSegue) {
        
    }
    
    //1
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SceneArray.array.count
    }
    
    //3
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SceneCell", forIndexPath: indexPath) as! SceneCell
        
        let scene: Scene? = SceneArray.array[indexPath.row]
        if let scene = scene {
            cell.name = scene["Name"] as? String
            cell.img = scene["Image"] as? PFFile
        }
        
        // Configure the cell
        return cell
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //sellectedSceneIndex = indexPath.row
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show" {
        if let destinationViewController = segue.destinationViewController as? ControlView {
            destinationViewController.hidesBottomBarWhenPushed = true
            if let cell = sender as? SceneCell {
                let index = collectionView?.indexPathForCell(cell)
                if let index = index {
                    destinationViewController.currentScene = SceneArray.array[index.row]
                }
            }
            
            }
        }
    }
}

extension SceneView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        dismissViewControllerAnimated(true, completion: nil)
        if let 🗻 = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let cell = collectionView!.cellForItemAtIndexPath(sellectedSceneIndexPath) as! SceneCell
            
            cell.icon = 🗻
            let data = UIImagePNGRepresentation(🗻)
            let imageFile = PFFile(name: "icon.png", data: data!)
            
            SceneArray.array[sellectedSceneIndexPath.row]["Image"] = imageFile
            SceneArray.array[sellectedSceneIndexPath.row].saveInBackground()
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
