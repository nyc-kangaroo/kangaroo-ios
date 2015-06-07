//
//  KangarooAlertView.swift
//  Kangaroo
//
//  Created by Jack Cook on 6/7/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import UIKit

class KangarooAlertView: UIView {
    
    init(viewController: UIViewController) {
        super.init(frame: viewController.view.bounds)
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.45)
        
        let alertFrame = CGRectMake(60, 200, viewController.view.bounds.width - 120, viewController.view.bounds.height - 400)
        let alert = UIView(frame: alertFrame)
        alert.clipsToBounds = false
        alert.layer.masksToBounds = false
        alert.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        alert.layer.shadowRadius = 10
        alert.layer.shadowOffset = CGSizeMake(6, 8)
        alert.layer.shadowColor = UIColor.blackColor().CGColor
        alert.layer.shadowOpacity = 1
        
        self.addSubview(alert)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
