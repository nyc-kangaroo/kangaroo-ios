//
//  Product.swift
//  Kangaroo
//
//  Created by Jack Cook on 6/6/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import SwiftyJSON

class Product {
    
    var upc: Int?
    var name: String?
    var imageUrl: String?
    var price: Float?
    var quantity = 0
    
    init(json: JSON) {
        if let upc = json["UPC"].int {
            self.upc = upc
        }
        
        if let name = json["name"].string {
            self.name = name
        }
        
        if let imageUrl = json["imageUrl"].string {
            self.imageUrl = imageUrl
        }
        
        if let price = json["price"].float {
            self.price = price
        }
    }
}
