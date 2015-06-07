//
//  BarcodeViewController.swift
//  Kangaroo
//
//  Created by Jack Cook on 6/7/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import MTBBarcodeScanner
import UIKit

class BarcodeViewController: UIViewController {
    
    @IBOutlet var cameraLayer: UIView!
    
    var scanner: MTBBarcodeScanner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scanner = MTBBarcodeScanner(previewView: self.cameraLayer)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.startScanning()
    }
    
    func startScanning() {
        MTBBarcodeScanner.requestCameraPermissionWithSuccess { (success) -> Void in
            if success {
                self.scanner.startScanningWithResultBlock({ (codes) -> Void in
                    self.scanner.stopScanning()
                    
                    let code = (codes.first as! AVMetadataMachineReadableCodeObject).stringValue
                    
                    let notificationCenter = NSNotificationCenter.defaultCenter()
                    notificationCenter.postNotificationName("KGFoundBarcode", object: code)
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
