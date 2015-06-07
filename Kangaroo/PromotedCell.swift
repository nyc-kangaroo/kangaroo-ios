//
//  PromotedCell.swift
//  Kangaroo
//
//  Created by Jack Cook on 6/6/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Foundation
import UIKit

class PromotedCell: UITableViewCell {
    
    @IBOutlet var topLeftView: UIView!
    @IBOutlet var bottomLeftView: UIView!
    @IBOutlet var topRightView: UIView!
    @IBOutlet var bottomRightView: UIButton!
    
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    var product: Product?
    
    override func awakeFromNib() {
        self.bottomRightView.backgroundColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
    }
    
    func configureWithProduct(product: Product) {
        self.product = product
        
        if let name = product.name {
            self.productName.text = name
        }
        
        if let imageUrl = product.imageUrl {
            Mozart.load(imageUrl).into(self.productImage)
        }
        
        if let price = product.price {
            self.priceLabel.text = "$\(price)"
        }
    }
    
    @IBAction func addButton(sender: AnyObject) {
        if let product = self.product {
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.postNotificationName("KGAddProduct", object: product)
        }
    }
}
