//
//  StoreSelectViewController.swift
//  Kangaroo
//
//  Created by Jack Cook on 6/6/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import GoogleMaps
import Foundation
import UIKit

class StoreSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var stores: [Store]?
    var storeToSend: Store?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stores?.sortInPlace({ (s1, s2) -> Bool in
            let l1 = CLLocation(latitude: s1.place!.coordinate.latitude, longitude: s1.place!.coordinate.longitude)
            let l2 = CLLocation(latitude: s2.place!.coordinate.latitude, longitude: s2.place!.coordinate.longitude)
            
            let d1 = round(l1.distanceFromLocation(kangarooLocationManager!.location!) / 0.9144)
            let d2 = round(l2.distanceFromLocation(kangarooLocationManager!.location!) / 0.9144)
            
            return d1 < d2
        })
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = UIColor.darkKangarooColor()
        self.tableView.tableFooterView = UIView.new()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let stores = stores else {
            return 0
        }
        
        return stores.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoreCell", forIndexPath: indexPath) as! StoreCell
        
        if let stores = stores {
            cell.configureWithStore(stores[indexPath.row], logo: UIImage(named: "Grocery-Large")!)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.storeToSend = self.stores![indexPath.row]
        self.performSegueWithIdentifier("storeSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? StoreViewController {
            vc.store = self.storeToSend
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
