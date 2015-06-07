//
//  ProductCell.swift
//  Kangaroo
//
//  Created by Jack Cook on 6/7/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    
    var index: Int?
    var product: Product!
    
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    
    override func awakeFromNib() {
    }
    
    func configureWithProduct(product: Product) {
        self.product = product
        
        if let imageUrl = product.imageUrl {
            Mozart.load(imageUrl).into(productImage)
        }
        
        if let name = product.name {
            self.nameLabel.text = name
        }
        
        if let price = product.price {
            self.priceLabel.text = "\(price)"
        }
        
        self.quantityLabel.text = "\(product.quantity)"
    }
    
    @IBAction func decreaseQuantity(sender: AnyObject) {
        if self.product.quantity != 0 {
            self.product.quantity -= 1
            self.quantityLabel.text = "\(self.product.quantity)"
            
            let price = self.product.price! * Float(self.product.quantity)
            self.priceLabel.text = "$\(price)"
        }
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName("KGPriceUpdated", object: nil)
    }
    
    @IBAction func increaseQuantity(sender: AnyObject) {
        self.product.quantity += 1
        self.quantityLabel.text = "\(self.product.quantity)"
        
        let price = self.product.price! * Float(self.product.quantity)
        self.priceLabel.text = "$\(price)"
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName("KGPriceUpdated", object: nil)
    }
    
    @IBAction func trashButton(sender: AnyObject) {
        if let index = self.index {
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.postNotificationName("KGDeleteProduct", object: index)
        }
    }
}
