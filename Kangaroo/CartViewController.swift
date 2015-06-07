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
    var store: Store!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var checkoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = self.store.place!.name
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.backgroundColor = UIColor.darkKangarooColor()
        
        self.tableView.tableFooterView = UIView.new()
        
        self.checkoutButton.backgroundColor = UIColor(red: 33/255, green: 34/255, blue: 35/255, alpha: 1)
        
        self.updatePrice(nil)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "deleteProduct:", name: "KGDeleteProduct", object: nil)
        notificationCenter.addObserver(self, selector: "updatePrice:", name: "KGPriceUpdated", object: nil)
    }
    
    func deleteProduct(notification: NSNotification) {
        if let index = notification.object as? Int {
            ShoppingCart.sharedInstance().removeProductAtIndex(index)
            self.tableView.reloadData()
        } else {
            println("Error retrieving item index")
        }
    }
    
    func updatePrice(notification: NSNotification?) {
        var price = 0.0
        var items = 0
        
        for product in ShoppingCart.sharedInstance().getProducts() {
            price += Double(product.price! * Float(product.quantity))
            items += product.quantity
        }
        
        price = round(price * 100) / 100
        
        self.priceLabel.text = "$\(price)"
        
        let totalAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        let attributedTotal = NSMutableAttributedString(string: "Total", attributes: totalAttributes)
        
        let quantityAttributes = [NSForegroundColorAttributeName: UIColor(red: 103/255, green: 108/255, blue: 114/255, alpha: 1)]
        let attributedQuantity = NSAttributedString(string: " – \(items) items", attributes: quantityAttributes)
        
        attributedTotal.appendAttributedString(attributedQuantity)
        self.totalLabel.attributedText = attributedTotal
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
        
        var objects = [PKPaymentSummaryItem]()
        
        var total: Float = 0.0
        
        for product in ShoppingCart.sharedInstance().getProducts() {
            let price = round(product.price! * Float(product.quantity) * 100) / 100
            let decimal = NSDecimalNumber(float: price)
            
            total += price
            
            let summaryItem = PKPaymentSummaryItem(label: product.name!, amount: decimal)
            objects.append(summaryItem)
        }
        
        let totalItem = PKPaymentSummaryItem(label: "Kangaroo", amount: NSDecimalNumber(float: total))
        objects.append(totalItem)
        
        request.paymentSummaryItems = objects
        request.supportedNetworks = [PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex]
        
        self.payController = PKPaymentAuthorizationViewController(paymentRequest: request)
        self.payController!.delegate = self
        self.presentViewController(self.payController!, animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController!, didAuthorizePayment payment: PKPayment!, completion: ((PKPaymentAuthorizationStatus) -> Void)!) {
        let url = "http://45.33.83.229:3001/checkout/\(self.store.place!.name)/\(ShoppingCart.sharedInstance().getProducts()[0].quantity)"
        let encodedUrlString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let encodedUrl = NSURL(string: encodedUrlString)!
        
        let request = NSMutableURLRequest(URL: encodedUrl)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            for product in ShoppingCart.sharedInstance().getProducts() {
                ShoppingCart.sharedInstance().removeProductAtIndex(0)
            }
            
            completion(PKPaymentAuthorizationStatus.Success)
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController!) {
        self.payController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingCart.sharedInstance().getProducts().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let product = ShoppingCart.sharedInstance().getProducts()[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell", forIndexPath: indexPath) as! ProductCell
        cell.configureWithProduct(product)
        cell.index = indexPath.row
        
        return cell
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
