//
//  CartViewController.swift
//  Kangaroo
//
//  Created by Jack Cook on 6/7/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Foundation
import PassKit
import UIKit

class CartViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var payController: PKPaymentAuthorizationViewController?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var checkoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.backgroundColor = UIColor.darkKangarooColor()
        
        self.tableView.tableFooterView = UIView.new()
        
        self.checkoutButton.backgroundColor = UIColor(red: 33/255, green: 34/255, blue: 35/255, alpha: 1)
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func checkoutButton(sender: AnyObject) {
        let request = PKPaymentRequest()
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.merchantCapabilities = PKMerchantCapability.Capability3DS
        request.merchantIdentifier = "merchant.nyc.jackcook.Kangaroo"
        
        let objects = [PKPaymentSummaryItem(label: "Subtotal", amount: 12.73)]
        
        request.paymentSummaryItems = objects
        request.supportedNetworks = [PKPaymentNetworkVisa]
        
        self.payController = PKPaymentAuthorizationViewController(paymentRequest: request)
        self.payController!.delegate = self
        self.presentViewController(self.payController!, animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController!, didAuthorizePayment payment: PKPayment!, completion: ((PKPaymentAuthorizationStatus) -> Void)!) {
        completion(PKPaymentAuthorizationStatus.Success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController!) {
        self.payController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell", forIndexPath: indexPath) as? ProductCell {
            return cell
        } else {
            println("Error with table view cell identifier")
            return UITableViewCell()
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
