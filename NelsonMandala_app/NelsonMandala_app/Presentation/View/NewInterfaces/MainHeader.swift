//
//  MainHeader.swift
//  NelsonMandala_app
//
//  Created by Rhullian Damião on 30/10/2017.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

@IBDesignable
class MainHeader: UIView {

    var gradientLayer:CAGradientLayer!
    
    override func layoutSubviews() {
        self.createGradientLayer()
    }
    
    //Funcao que gera o background layer
    func createGradientLayer(){
        self.gradientLayer = CAGradientLayer()
        
        self.gradientLayer.frame = self.bounds
        self.gradientLayer.colors = [#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor,#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1).cgColor]
        
        layer.addSublayer(self.gradientLayer)
    }

}
