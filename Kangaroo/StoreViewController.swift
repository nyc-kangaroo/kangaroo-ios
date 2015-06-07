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
    
    var store: Store!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.backgroundColor = UIColor.darkKangarooColor()
       
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
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "addItemToCart:", name: "KGAddProduct", object: nil)
        notificationCenter.addObserver(self, selector: "processBarcode:", name: "KGFoundBarcode", object: nil)
    }
    
    func addItemToCart(notification: NSNotification) {
        if let product = notification.object as? Product {
            ShoppingCart.sharedInstance().addProduct(product)
            println(ShoppingCart.sharedInstance().getProducts().count)
        }
    }
    
    func processBarcode(notification: NSNotification) {
        if let barcode = notification.object as? String {
            if let products = self.store.products {
                for product in products {
                    if product.upc == barcode.toInt()! {
                        
                    }
                }
            }
        }
    }
    
    @IBAction func barcodeButton(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bvc = storyboard.instantiateViewControllerWithIdentifier("BarcodeViewController") as! BarcodeViewController
        
        self.presentViewController(bvc, animated: true, completion: nil)
    }
    
    @IBAction func cartButton(sender: AnyObject) {
        self.performSegueWithIdentifier("cartSegue", sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let store = store {
            if let promoted = store.promoted {
                return promoted.count
            }
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let device = UIScreen.mainScreen().bounds
        return device.width * (3/5)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("PromotedCell", forIndexPath: indexPath) as? PromotedCell {
            
            if let store = store {
                cell.product = store.products![indexPath.row]
            }
            
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
