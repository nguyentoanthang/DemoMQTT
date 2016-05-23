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
                
            } else {
                image.file = currentScene["Image"] as? PFFile
                image.loadInBackground({ (image: UIImage?, error: NSError?) in
                    self.currentScene.image = image
                })
                nameScene.text = currentScene["Name"] as? String
            }
        }
    }
    
    var icon: UIImage? {
        didSet {
            image.image = icon
        }
    }
    
    var name: String? {
        didSet {
            nameScene.text = name
        }
    }
    
}
