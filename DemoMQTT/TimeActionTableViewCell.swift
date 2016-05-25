//
//  TimeActionTableViewCell.swift
//  DemoMQTT
//
//  Created by mac on 5/25/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit

class TimeActionTableViewCell: UITableViewCell {

    var isObserver = false
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    class var expandedHeight: CGFloat {
        get { return 200}
    }
    
    class var defaultHeight: CGFloat {
        get { return 44}
    }
    
    func checkHeight() {
        timePicker.hidden = (frame.size.height < TimeActionTableViewCell.expandedHeight)
    }
    
    func watchFrameChanges() {
        if !isObserver {
            addObserver(self, forKeyPath: "frame", options: [.New, .Initial], context: nil)
            isObserver = true
        }
        
    }
    
    func ignoreFrameChanges() {
        if isObserver {
            removeObserver(self, forKeyPath: "frame")
            isObserver = false
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
