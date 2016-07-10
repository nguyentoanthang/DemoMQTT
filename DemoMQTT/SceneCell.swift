//
//  SceneCell.swift
//  DemoMQTT
//
//  Created by mac on 4/26/16.
//  Copyright © 2016 mac.thang. All rights reserved.
//

import UIKit
import ParseUI

class SceneCell: UICollectionViewCell {

    @IBOutlet weak var nameScene: UILabel!
    
    @IBOutlet weak var image: PFImageView!
    
    var currentScene: Scene! {
        didSet {
            if currentScene["Image"] as? PFFile == nil {
                image.image = nil
            } else {
                image.file = currentScene["Image"] as? PFFile
                image.loadInBackground()
                
            }
            nameScene.text = currentScene["Name"] as? String
        }
    }
    
    var icon: UIImage? {
        didSet {
            image.image = icon
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
    }
    
}
