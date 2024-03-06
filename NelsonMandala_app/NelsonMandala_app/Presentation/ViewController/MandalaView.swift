//
//  mandalaView.swift
//  viewMandala
//
//  Created by Lucas Santos on 09/10/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

@IBDesignable class MandalaView : UIView {
    
    @IBInspectable var proportion = 0.0
    public var mandalaImageRef:UIImageView?
    
    public func calculateProportion(currentTime: TimeInterval, totalTime: TimeInterval){
        proportion = min(1, currentTime / totalTime)
        layer.sublayers?.removeAll()
        mandalaBlockBackground()
        mandalaBlockTexture()
    }
    
    // Cria um fundo branco do circulo que fica por cima da mandala
    func mandalaBlockBackground() {
        
        let circle = CAShapeLayer()
        circle.lineWidth = ((layer.bounds.width)/2 * CGFloat(1-proportion))-10
        circle.strokeColor = UIColor.white.cgColor
        circle.fillColor = nil
        
        let arcCenter = CGPoint(x: (mandalaImageRef?.bounds.width)!/2 , y: (mandalaImageRef?.bounds.height)!/2)
        let radius = (layer.bounds.size.width/2.0 - circle.lineWidth/2)-10
        let startAngle = CGFloat(0.0)
        let endAngle = CGFloat(2.0 * CGFloat.pi)
        let clockwise = true
        
        // Desenha o circulo
        let circlePath = UIBezierPath(arcCenter: arcCenter,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: clockwise)
        
        circle.path = circlePath.cgPath
        layer.addSublayer(circle)
    }
    
    // Cria a textura do circulo que fica por cima da mandala
    func mandalaBlockTexture() {
        
        let patternImage = UIImage(named: "Rectangle 5")
        
        let circle = CAShapeLayer()
        circle.lineWidth = (mandalaImageRef?.bounds.width)!/2 * CGFloat(1-proportion)-10
        circle.fillColor = nil
        circle.strokeColor = UIColor(patternImage: patternImage!).cgColor
        
        let arcCenter = CGPoint(x: layer.bounds.width/2 , y: layer.bounds.height/2)
        let radius = (layer.bounds.size.width/2.0 - circle.lineWidth/2)-10
        let startAngle = CGFloat(0.0)
        let endAngle = CGFloat(2.0 * CGFloat.pi)
        let clockwise = true
        
        // Desenha o circulo
        let circlePath = UIBezierPath(arcCenter: arcCenter,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: clockwise)
        
        circle.path = circlePath.cgPath
        layer.addSublayer(circle)
    }
    
    /*
     func mandalaDraw() {
     let width: CGFloat = 370
     let height: CGFloat = 370
     
     let shapeLayer = CAShapeLayer()
     shapeLayer.frame = CGRect(x: 0, y: 0, // Posicao X e Y na tela
     width: width, height: height)
     
     let path = CGMutablePath()
     
     stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 20 // numero de petalas no circulo
     ).forEach {
     angle in
     var transform  = CGAffineTransform(rotationAngle: angle)
     .concatenating(CGAffineTransform(translationX: width / 2, y: height / 2))
     
     let petal = CGPath(ellipseIn: CGRect(x: -40, y: 0, width: 70, height: 120),
     transform: &transform)
     
     path.addPath(petal)
     layer.addSublayer(shapeLayer)
     }
     
     shapeLayer.path = path
     shapeLayer.strokeColor = UIColor.red.cgColor
     shapeLayer.fillColor = UIColor.yellow.cgColor
     shapeLayer.fillRule = kCAFillRuleEvenOdd
     }*/
    
}

