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
    var promoted: [String]?
    
    init(json: JSON, place: GMSPlace) {
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
        
        if let promoted = json["promoted"].arrayObject as? [String] {
            self.promoted = promoted
        }
    }
}
