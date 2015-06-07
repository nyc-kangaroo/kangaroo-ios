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
        self.products.append(product)
    }
    
    func getProducts() -> [Product] {
        return self.products
    }
    
    func removeProductAtIndex(index: Int) {
        self.products.removeAtIndex(index)
    }
}
