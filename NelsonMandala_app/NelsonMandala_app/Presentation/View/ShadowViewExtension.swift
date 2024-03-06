//
//  ShadowViewExtension.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 14/11/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

extension UIView {
    
    func renderShadow(shadowColor: UIColor, shadowOpacity: Float, shadowOffset: CGSize, shadowRadius: Float) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = CGFloat(shadowRadius)
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
    }
    
}
