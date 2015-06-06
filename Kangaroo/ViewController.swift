//
//  ViewController.swift
//  Kangaroo
//
//  Created by Jack Cook on 6/6/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import CoreLocation
import GoogleMaps
import MTBBarcodeScanner
import UIKit

class ViewController: UIViewController {

    @IBOutlet var label: UILabel!
    
    var scanner: MTBBarcodeScanner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scanner = MTBBarcodeScanner(previewView: self.view)
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        GMSPlacesClient.sharedClient().currentPlaceWithCallback { (placeLikelihoods, error) -> Void in
            if let error = error {
                println("Current Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoods = placeLikelihoods {
                for likelihood in placeLikelihoods.likelihoods {
                    if let likelihood = likelihood as? GMSPlaceLikelihood {
                        let place = likelihood.place
                        
                        if contains(place.types as! [String], "grocery_or_supermarket") {
                            println("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func startScanning(sender: AnyObject) {
//        MTBBarcodeScanner.requestCameraPermissionWithSuccess { (success) -> Void in
//            if success {
//                self.scanner.startScanningWithResultBlock({ (codes) -> Void in
//                    self.scanner.stopScanning()
//                    
//                    let code = (codes.first as! AVMetadataMachineReadableCodeObject).stringValue
//                    self.lookupProduct(code)
//                })
//            } else {
//                println("failure")
//            }
//        }
        
        GMSPlacesClient.sharedClient().currentPlaceWithCallback { (placeLikelihoodList, error) -> Void in
            if let error = error {
                println(error.localizedDescription)
            }
            
            if let placeLikelihoodlist = placeLikelihoodList {
                let place = placeLikelihoodlist.likelihoods.first?.place
                if let place = place {
                    println(place.name)
                }
            }
        }
    }
    
    func lookupProduct(code: String) {
        println(code)
        let url = NSURL(string: "http://www.searchupc.com/handlers/upcsearch.ashx?request_type=3&access_token=6B6F27AC-A4CE-444C-8A79-E5C1E71CF977&upc=\(code)")!
        let request = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            let stuff = NSString(data: data, encoding: NSUTF8StringEncoding)!
            self.label.text = "\(stuff)"
        }
    }
}
