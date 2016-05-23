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
    
    var img: PFFile? {
        didSet {
            if img == nil {
                
            } else {
                image.file = img
                image.loadInBackground()
            }
        }
    }
    
}
