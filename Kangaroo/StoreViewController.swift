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

class StoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var navigationBar: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cornerButton: UIButton!
    
    var store: Store?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
       
        self.navigationBar.layer.shadowRadius = 2
        self.navigationBar.layer.shadowOffset = CGSizeMake(0, 2)
        self.navigationBar.layer.shadowColor = UIColor.blackColor().CGColor
        self.navigationBar.layer.shadowOpacity = 0.9
        
        self.cornerButton.backgroundColor = UIColor.mainKangarooColor()
        self.cornerButton.layer.cornerRadius = 28
        
        self.cornerButton.layer.shadowRadius = 4
        self.cornerButton.layer.shadowOffset = CGSizeMake(0, 4)
        self.cornerButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.cornerButton.layer.shadowOpacity = 0.9
    }
    
    @IBAction func searchButton(sender: AnyObject) {
        
    }
    
    @IBAction func barcodeButton(sender: AnyObject) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let store = store {
//            if let promoted = store.promoted {
//                return promoted.count
//            }
//        }
        
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let device = UIScreen.mainScreen().bounds
        return device.width * (3/5)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("PromotedCell", forIndexPath: indexPath) as? PromotedCell {
            return cell
        } else {
            println("Error retrieving UITableViewCell type")
            return UITableViewCell()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
