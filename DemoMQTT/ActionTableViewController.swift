//
//  ActionTableViewController.swift
//  DemoMQTT
//
//  Created by mac on 5/25/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit
import Parse.PFUser
import MBProgressHUD

class ActionTableViewController: UITableViewController {

    var selectedIndexPath: NSIndexPath?
    
    var actions: [TimeAction] = []
    
    var dataBack: String?
    
    @IBAction func addAction(sender: UIBarButtonItem) {
        
        let actionController = UIAlertController.alertControllerWithStringInput("Create Action", message: "Enter name of action", buttonTitle: "OK") { (name) in
            
            guard let _name = name where _name != "" else {
                return
            }
            
            let action = TimeAction(name: _name, time: "00:00 AM", deviceID: "", email: (PFUser.currentUser()?.email)!)
            
            action.saveInBackground()
            
            self.actions.append(action)
            
            self.tableView.reloadData()
            
        }
        
        presentViewController(actionController, animated: true, completion: nil)
        
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
        
        action()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func action() {
        let query = TimeAction.query()
        query?.whereKey("Email", equalTo: (PFUser.currentUser()?.email)!)
        
        showLoadingHUD()
        query?.findObjectsInBackgroundWithBlock({ (object: [PFObject]?, error: NSError?) in
            self.actions.appendContentsOf(object as! [TimeAction])
            self.tableView.reloadData()
            self.hideLoadingHUD()
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        for cell in tableView.visibleCells as! [TimeActionTableViewCell] {
            cell.ignoreFrameChanges()
        }
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
        return actions.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimeAction", forIndexPath: indexPath) as! TimeActionTableViewCell
        
        let action = actions[indexPath.row]

        cell.name.text = action["Name"] as? String
        cell.timeBtn.tag = indexPath.row
        cell.setBtn.tag = indexPath.row
        
        cell.timeBtn.setTitle(action["Time"] as? String, forState: .Normal)
        cell.setBtn.addTarget(self, action: #selector(ActionTableViewController.setTime(_:)), forControlEvents: .TouchUpInside)
        
        cell.timeBtn.addTarget(self, action: #selector(ActionTableViewController.chooseTime(_:)), forControlEvents: .TouchUpInside)
        
        cell.icon.layer.cornerRadius = cell.icon.frame.width/2
        cell.icon.clipsToBounds = true
        print(indexPath.row)
        print(indexPath.section)
        if let file = action["icon"] as? PFFile {
            print("file")
            cell.icon.file = file
            cell.icon.loadInBackground()
        } else {
            cell.icon.image = nil
            cell.icon.backgroundColor = UIColor.grayColor()
        }
        // Configure the cell...

        return cell
    }
    
    func setTime(sender: DCBorderedButton) {
        print(sender.tag)
        let dateFortmater = NSDateFormatter()
        dateFortmater.timeStyle = NSDateFormatterStyle.ShortStyle
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as!TimeActionTableViewCell
        
        let time = dateFortmater.stringFromDate(cell.timePicker.date)
        let index = cell.devicePicker.selectedRowInComponent(0)
        
        cell.timeBtn.setTitle(time, forState: .Normal)
        
        let device = DeviceArray.IRarray[index]
        if let file = device["Icon"] as? PFFile {
            cell.icon.file = file
            actions[sender.tag]["icon"] = file
            cell.icon.loadInBackground()
        } else {
            cell.icon.image = nil
            cell.icon.backgroundColor = UIColor.grayColor()
        }
        
        
        actions[sender.tag]["Time"] = time
        actions[sender.tag]["DeviceId"] = DeviceArray.IRarray[index]["DeviceId"] as! String
        
        actions[sender.tag].saveInBackground()
        
        //cell.timeBtn.titleLabel?.text = dateFortmater.stringFromDate(cell.timePicker.date)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
                
    }
    
    func chooseTime(sender: UIButton) {
        
        print(sender.tag)
        
        let previousIndexPath = selectedIndexPath
        
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths: Array<NSIndexPath> = []
        
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        
        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        }
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! TimeActionTableViewCell).watchFrameChanges()
        print("add")
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let actionCell = (cell as! TimeActionTableViewCell)
        
        actionCell.ignoreFrameChanges()
        if actionCell.icon != nil {
            actionCell.icon.loadInBackground()
        } else {
            actionCell.icon.image = nil
            actionCell.icon.backgroundColor = UIColor.grayColor()
        }
        print("remove")
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return TimeActionTableViewCell.expandedHeight
        } else {
            return TimeActionTableViewCell.defaultHeight
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addAction" {
            if let destinationViewController = segue.destinationViewController as? AddActionViewController {
                let cell = sender as? TimeActionTableViewCell
                let indexPath = tableView.indexPathForCell(cell!)
                
                destinationViewController.deviceID = actions[(indexPath?.row)!]["DeviceId"] as? String
            }
        }
    }
    
    @IBAction func doneAction(segue: UIStoryboardSegue) {
        
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

extension ActionTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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

