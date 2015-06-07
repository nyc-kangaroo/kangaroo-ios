//
//  PromotedCell.swift
//  Kangaroo
//
//  Created by Jack Cook on 6/6/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Foundation
import UIKit

class PromotedCell: UITableViewCell {
    
    @IBOutlet var topLeftView: UIView!
    @IBOutlet var bottomLeftView: UIView!
    @IBOutlet var topRightView: UIView!
    @IBOutlet var bottomRightView: UIButton!
    
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    override func awakeFromNib() {
        self.bottomRightView.backgroundColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
        
        Mozart.load("http://puu.sh/ifoA4/3215817322.png").into(productImage)
    }
    
    func configureWithProduct(product: Product) {
        
    }
}
