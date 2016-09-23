//
//  UIView+RGA.swift
//  RGA
//
//  Created by Tancrède on 9/22/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import UIKit



// Draw round corner to UIViews

extension UIView{
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
}
