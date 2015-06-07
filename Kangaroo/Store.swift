//
//  Store.swift
//  Kangaroo
//
//  Created by Jack Cook on 6/6/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import GoogleMaps
import SwiftyJSON

struct Store {
    
    var place: GMSPlace?
    var imageUrl: String?
    var products: [Product]?
    var promoted: [Int]?
    
    init(json: JSON, place: GMSPlace) {
        println(json)
        self.place = place
        
        if let imageUrl = json["imageUrl"].string {
            self.imageUrl = imageUrl
        }
        
        if let products = json["products"].array {
            self.products = [Product]()
            
            for product in products {
                let newProduct = Product(json: product)
                self.products?.append(newProduct)
            }
        }
        
        println(json)
        
        if let promoted = json["promoted"].arrayObject as? [Int] {
            self.promoted = promoted
        }
    }
}
