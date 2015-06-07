//
//  StoreViewController.swift
//  Kangaroo
//
//  Created by Jack Cook on 6/6/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import GoogleMaps
import Foundation
import UIKit

class StoreViewController: UIViewController {
    
    @IBOutlet var cornerButton: UIButton!
    
    var store: Store?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cornerButton.backgroundColor = UIColor.mainKangarooColor()
        self.cornerButton.layer.cornerRadius = 28
        
        self.cornerButton.layer.shadowRadius = 4
        self.cornerButton.layer.shadowOffset = CGSizeMake(0, 4)
        self.cornerButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.cornerButton.layer.shadowOpacity = 0.9
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
