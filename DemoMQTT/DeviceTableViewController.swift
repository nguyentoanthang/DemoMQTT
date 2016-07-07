//
//  DeviceTableViewController.swift
//  DemoMQTT
//
//  Created by mac on 4/22/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse.PFObject
import CocoaMQTT

class DeviceTableViewController: UITableViewController {

    var selectedDeviceIndexPath: NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.colorFromHex("#53802d")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DeviceArray.array.count
    }

    
    @IBAction func addDevice(sender: AnyObject) {

            let alert = UIAlertController.alertControllerWithNumberInput("Add Device", message: "Enter device ID in the product", buttonTitle: "OK") { value in
                guard let deviceId = value where deviceId != "" else {
                    return
                }
                
                self.showLoadingHUD()
                let query = Device.query()
                query?.whereKey("DeviceId", equalTo: deviceId)
                query?.getFirstObjectInBackgroundWithBlock({(object: PFObject?, error: NSError?) -> Void in
                    if let object = object {
                        object["email"] = PFUser.currentUser()?.email
                        object.saveInBackground()
                        let device: Device! = object as! Device
                        DeviceArray.array.append(device)
                        if (device["Type"] as? Int) == 1 {
                            DeviceArray.IRarray.append(device)
                        } else {
                            DeviceArray.IRarray.append(device)
                        }
                        self.tableView.reloadData()
                        self.hideLoadingHUD()
                    }})
        }
        
        presentViewController(alert, animated: true) {}
    }
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(self.tableView, animated: true)
        hud.labelText = "Loading..."
    }

    private func hideLoadingHUD() {
        MBProgressHUD.hideHUDForView(self.tableView, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DeviceCell", forIndexPath: indexPath) as! DeviceCell

        // Configure the cell...
        
        let device = DeviceArray.array[indexPath.row] as Device
        //print("\(device["Name"])")
        cell.device = device
        
        return cell
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedDeviceIndexPath = indexPath
        
        let name = (tableView.cellForRowAtIndexPath(indexPath) as! DeviceCell).name.text
        
        let actionSheet = UIAlertController(title: name, message: "Choose your action", preferredStyle: .ActionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
        }
        
        let picture = UIAlertAction(title: "Change Icon", style: .Default) { (action) in
            self.showLibrary()
        }
        
        let changeUser = UIAlertAction(title: "Change User", style: .Default) { (action) in
            let action = UIAlertController.alertControllerWithStringInput("Change User", message: "Enter the email of user you want to change", buttonTitle: "OK", handler: { (string) in
                
                guard let _email = string where _email != "" else {
                    return
                }
                
                let alert = UIAlertController(title: "Change User", message: "This action can't be undo, are you sure to change?", preferredStyle: .Alert)
                
                let ok = UIAlertAction(title: "OK", style:
                    .Default, handler: { (action) in
                        // get the current device and change email
                })
                
                let cancel = UIAlertAction(title: "Cancel", style: .Default, handler: { (action) in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                
                alert.addAction(cancel)
                alert.addAction(ok)
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                
            })
            
            self.presentViewController(action, animated: true, completion: nil)
        }
        
        actionSheet.addAction(changeUser)
        actionSheet.addAction(picture)
        actionSheet.addAction(cancel)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showLibrary() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DeviceTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        dismissViewControllerAnimated(true, completion: nil)
        if let 🗻 = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let cell = tableView.cellForRowAtIndexPath(selectedDeviceIndexPath) as! DeviceCell
            
            cell.icon.image = 🗻
            let data = UIImageJPEGRepresentation(🗻, 0.3)
            let imageFile = PFFile(name: "icon.png", data: data!)
            
            DeviceArray.array[selectedDeviceIndexPath.row]["Icon"] = imageFile
            DeviceArray.array[selectedDeviceIndexPath.row].saveInBackground()
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
