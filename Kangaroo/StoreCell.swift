//
//  StoreCell.swift
//  Kangaroo
//
//  Created by Jack Cook on 6/6/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import GoogleMaps
import Foundation
import UIKit

class StoreCell: UITableViewCell {
    
    @IBOutlet var logo: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var type: UILabel!
    @IBOutlet var distance: UILabel!
    
    override func awakeFromNib() {
    }
    
    func configureWithStore(store: Store, logo: UIImage) {
        self.logo.image = logo
        self.name.text = store.place?.name
        self.icon.image = UIImage(named: "Grocery")
        self.type.text = "grocery"
        
        if let locationManager = kangarooLocationManager {
            if let place = store.place {
                let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                let distance = locationManager.location.distanceFromLocation(location)
                let rounded = round(round(distance * 100) / 100 / 1609.34 * 100) / 100
                
                self.distance.text = "\(rounded) mi"
            }
        }
        
        println("\(store.place?.name): \(store.place?.placeID)")
    }
}
