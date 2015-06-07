//
//  LoadingViewController.swift
//  Kangaroo
//
//  Created by Jack Cook on 6/6/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import GoogleMaps
import Foundation
import UIKit

class LoadingViewController: UIViewController {
    
    var stores: [GMSPlace]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.startUpdatingLocation()
        
        GMSPlacesClient.sharedClient().currentPlaceWithCallback { (possiblePlaces, error) -> Void in
            if let error = error {
                println("Error retrieving places: \(error.localizedDescription)")
                return
            }
            
            self.stores = [GMSPlace]()
            
            if let possiblePlaces = possiblePlaces {
                for possiblePlace in possiblePlaces.likelihoods {
                    if let possiblePlace = possiblePlace as? GMSPlaceLikelihood {
                        let place = possiblePlace.place
                        
                        if contains(place.types as! [String], "grocery_or_supermarket") {
                            self.stores?.append(place)
                        }
                    }
                }
            }
            
            self.performSegueWithIdentifier("storeSelectSegue", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? StoreSelectViewController {
            vc.stores = self.stores
        } else {
            println("Error: Unknown segue - \(segue.identifier)")
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
