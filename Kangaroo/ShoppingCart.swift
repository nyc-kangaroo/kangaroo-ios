//
//  ShoppingCart.swift
//  Kangaroo
//
//  Created by Jack Cook on 6/7/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

class ShoppingCart {

    class func sharedInstance() -> ShoppingCart {
        struct Static {
            static let instance = ShoppingCart()
        }
        
        return Static.instance
    }
    
    internal var products = [Product]()
    
    func addProduct(product: Product) {
        var i = 0
        for p in self.products {
            if p.upc == product.upc {
                self.products[i].quantity += 1
                return
            }
            
            i += 1
        }
        
        product.quantity = 1
        
        self.products.append(product)
    }
    
    func getProducts() -> [Product] {
        return self.products
    }
    
    func removeProductAtIndex(index: Int) {
        self.products.removeAtIndex(index)
    }
}
