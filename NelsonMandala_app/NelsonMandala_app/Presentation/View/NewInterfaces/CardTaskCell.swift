//
//  CardTaskCell.swift
//  NelsonMandala_app
//
//  Created by Rhullian Damião on 01/11/2017.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

@IBDesignable
class CardTaskCell: UIView {
    override func layoutSubviews() {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }

}
