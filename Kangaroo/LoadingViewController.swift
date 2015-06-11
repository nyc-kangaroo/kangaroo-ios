//
//  LoadingViewController.swift
//  Kangaroo
//
//  Created by Jack Cook on 6/6/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import GoogleMaps
import Foundation
import SwiftyJSON
import UIKit

class LoadingViewController: UIViewController, CLLocationManagerDelegate {
    
    var stores: [Store]?
    
    var retrievedLocation = false
    
    var potentialRequests = 1
    var finishedRequests = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kangarooLocationManager = CLLocationManager()
        kangarooLocationManager?.delegate = self
        kangarooLocationManager?.startUpdatingLocation()
        
        GMSPlacesClient.sharedClient().currentPlaceWithCallback { (possiblePlaces, error) -> Void in
            if let error = error {
                print("Error retrieving places: \(error.localizedDescription)")
                return
            }
            
            self.stores = [Store]()
            var places = [GMSPlace]()
            
            if let possiblePlaces = possiblePlaces {
                for possiblePlace in possiblePlaces.likelihoods {
                    if let possiblePlace = possiblePlace as? GMSPlaceLikelihood {
                        let place = possiblePlace.place
                        if (place.types as! [String]).contains("grocery_or_supermarket") {
                            places.append(place)
                            self.potentialRequests += 1
                            self.getPlaceInfo(place)
                        }
                    }
                }
            }
        }
    }
    
    func getPlaceInfo(place: GMSPlace) {
        let url = NSURL(string: "http://45.33.83.229:3001/store/\(place.placeID)")!
        let request = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
            let json = JSON(data: data!)
            let store = Store(json: json, place: place)
            self.stores?.append(store)
            
            self.finishedRequest()
        })
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        self.finishedRequest()
        kangarooLocationManager?.stopUpdatingLocation()
        kangarooLocationManager?.delegate = nil
    }
    
    func finishedRequest() {
        self.finishedRequests += 1
        
        if self.potentialRequests == self.finishedRequests {
            if let stores = stores {
                if stores.count > 1 {
                    self.performSegueWithIdentifier("storeSelectSegue", sender: nil)
                } else {
                    self.performSegueWithIdentifier("storeSegue", sender: nil)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? StoreSelectViewController {
            vc.stores = self.stores
        } else if let vc = segue.destinationViewController as? StoreViewController {
            vc.store = self.stores?.first
        } else {
            print("Error: Unknown segue - \(segue.identifier)")
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
