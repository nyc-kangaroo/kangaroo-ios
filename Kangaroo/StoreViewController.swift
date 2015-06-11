//
//  StoreViewController.swift
//  Kangaroo
//
//  Created by Jack Cook on 6/6/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import GoogleMaps
import Foundation
import MBProgressHUD
import UIKit

class StoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var navigationBar: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cornerButton: UIButton!
    
    var store: Store!
    var promotedProducts: [Product]!
    
    var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = store.place!.name
        
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
        
        self.promotedProducts = [Product]()
        
        if let store = store,
            products = store.products,
            promoted = store.promoted {
            for product in products where promoted.contains(product.upc!) {
                self.promotedProducts.append(product)
            }
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func addItemToCart(notification: NSNotification) {
        self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.hud.mode = .Text
        self.hud.labelText = "Added to Cart"
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "hideHUD", userInfo: nil, repeats: false)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
        guard let product = notification.object as? Product else {
            return
        }
        
        ShoppingCart.sharedInstance().addProduct(product)
    }
    
    func hideHUD() {
        self.hud.hide(true)
    }
    
    func processBarcode(notification: NSNotification) {
        guard let barcode = notification.object as? String, products = self.store.products else {
            return
        }
        
        for product in products where product.upc == barcode {
            ShoppingCart.sharedInstance().addProduct(product)
            self.performSegueWithIdentifier("cartSegue", sender: nil)
            break
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
        return self.promotedProducts.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let device = UIScreen.mainScreen().bounds
        return device.width * (3/5)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("PromotedCell", forIndexPath: indexPath) as? PromotedCell else {
            print("Error retrieving UITableViewCell type")
            return UITableViewCell()
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? CartViewController {
            vc.store = store
        } else {
            print("Error: Unknown segue identifier: \(segue.identifier)")
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
