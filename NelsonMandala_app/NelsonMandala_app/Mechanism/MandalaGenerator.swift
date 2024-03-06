//
//  MandalaGenerator.swift
//  NelsonMandala_app
//
//  Created by Mauricio Lorenzetti on 12/12/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

class MandalaGenerator:NSObject {
    
    func drawMandala(layers: Int, imageFrame: UIImageView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: imageFrame.bounds)
        //UIGraphicsImageRenderer(size: CGSize(width: imageFrame.frame.width, height: imageFrame.frame.height))
        
        let img = renderer.image { ctx in
            let context = ctx.cgContext
            let margin: CGFloat = 10.0
            let layerWidth:CGFloat = (imageFrame.bounds.width - margin * 2.0)/CGFloat(layers*2)
            
            context.translateBy(x: imageFrame.bounds.width/2.0, y: imageFrame.bounds.height/2.0)
            
            for layerCount in 0..<layers {
                
                let deviation:CGFloat = 0.0
                var possiblePatterns:[CALayerPattern] = []
                for _ in 0..<layers {
                    possiblePatterns.append(PetalsLayer())
                }
                
                let layer:CALayerPattern = possiblePatterns[layerCount]
                layer.startingRadius = layerWidth * CGFloat(layerCount) + deviation
                layer.endingRadius =  layerWidth *  CGFloat(layerCount+1) + deviation
                layer.backgroundColor = UIColor.clear.cgColor
                layer.delegate = self
                layer.draw(in: context)
                
                let circleLayer = InnerCircleLayer()
                circleLayer.startingRadius = layerWidth * CGFloat(layerCount) + deviation
                circleLayer.endingRadius = layerWidth * CGFloat(layerCount + 1) + deviation
                circleLayer.backgroundColor = UIColor.clear.cgColor
                circleLayer.delegate = self
                circleLayer.draw(in: context)
                
                let outterCircleLayer = OutterCircleLayer()
                outterCircleLayer.startingRadius = layerWidth * CGFloat(layerCount) + deviation
                outterCircleLayer.endingRadius = layerWidth * CGFloat(layerCount + 1) + deviation
                outterCircleLayer.backgroundColor = UIColor.clear.cgColor
                outterCircleLayer.delegate = self
                //outterCircleLayer.draw(in: context)
            }
            
            context.setStrokeColor(UIColor.black.cgColor)
            context.strokePath()
        }
        
        return img
    }
    
    func random(_ range:Range<Int>) -> Int {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
    
    func randomEven(_ range:Range<Int>) -> Int {
        var r:Int;
        repeat {
            r = random(range)
        } while (r % 2 != 0)
        return r
    }
    
    func headsOrTails() -> Bool {
        return random(0..<2) % 2 == 0
    }
    
}

extension MandalaGenerator: CALayerDelegate {
    
    func draw(_ layer: CALayer, in ctx: CGContext) {
        
        let exposedLayer:CALayerPattern = layer as! CALayerPattern
        let startRad:CGFloat = exposedLayer.startingRadius!
        let endRad:CGFloat = exposedLayer.endingRadius!
        
        if exposedLayer is InnerCircleLayer {
            let insideCircle = UIBezierPath(arcCenter: .zero, radius: startRad, startAngle: 0.0, endAngle: CGFloat(Double.pi*2), clockwise: false)
            ctx.addPath(insideCircle.cgPath)
            ctx.strokePath()
            print("inner")
            
        } else if exposedLayer is OutterCircleLayer {
            let outsideCircle = UIBezierPath(arcCenter: .zero, radius: endRad, startAngle: 0.0, endAngle: CGFloat(Double.pi*2), clockwise: false)
            ctx.addPath(outsideCircle.cgPath)
            ctx.strokePath()
            print("outter")
            
        } else if exposedLayer is PetalsLayer {
            let context = ctx
            
            //drawing
            let layerWidth = endRad - startRad
            let currentSlice = Int((endRad/layerWidth).rounded(.up))
            
            context.saveGState()
            
            //clipping path
            if (currentSlice != 1) {
                context.move(to: .zero)
                let innerClippingCircle = UIBezierPath(arcCenter: .zero, radius: startRad, startAngle: 0.0, endAngle: CGFloat(Double.pi*2), clockwise: false)
                let outterClippingCircle = UIBezierPath(arcCenter: .zero, radius: endRad, startAngle: 0.0, endAngle: CGFloat(Double.pi*2), clockwise: false)
                context.addPath(innerClippingCircle.cgPath)
                context.addPath(outterClippingCircle.cgPath)
                context.clip(using: .evenOdd)
                print("clipou")
            }
            
            //petal drawing
            //let possibleSlices:[CGFloat] = [8.0]
            //let slices:CGFloat = CGFloat(possibleSlices[random(0..<possibleSlices.count)] * CGFloat(currentSlice))
            let slices:CGFloat = CGFloat(random(currentSlice*4..<currentSlice*16))
            let circumference = CGFloat(2.0 * CGFloat(Double.pi) * startRad)
            let petalControlY:CGFloat = CGFloat(random(15..<60))
            //CGFloat(random(0..<2) % 2 == 0 ? 2.0*(circumference/slices) : 4.0*(circumference/slices))
            
            let petalStart = startRad-layerWidth
            let phase:Bool = headsOrTails()
            for _ in 0..<Int(slices) {
                context.rotate(by: CGFloat(2*Double.pi/Double(slices)))
                if (currentSlice == 1) {
                    context.move(to: .zero)
                    context.addQuadCurve(to: CGPoint(x: endRad, y: 0), control: CGPoint(x:(startRad+endRad)/2.0, y: +petalControlY))
                    context.addQuadCurve(to: .zero, control: CGPoint(x:(startRad+endRad)/2.0, y: -petalControlY))
                } else {
                    if (phase) {
                        context.move(to: CGPoint(x: petalStart, y: 0))
                        context.addQuadCurve(to: CGPoint(x: endRad, y: 0), control: CGPoint(x:startRad, y: petalControlY))
                        context.addQuadCurve(to: CGPoint(x: petalStart, y: 0), control: CGPoint(x:startRad, y: -petalControlY))
                    } else {
                        context.rotate(by: CGFloat(2*Double.pi/Double(slices*2.0)))
                        context.move(to: CGPoint(x: petalStart, y: 0))
                        context.addQuadCurve(to: CGPoint(x: endRad, y: 0), control: CGPoint(x:startRad, y: petalControlY))
                        context.addQuadCurve(to: CGPoint(x: petalStart, y: 0), control: CGPoint(x:startRad, y: -petalControlY))
                        context.rotate(by: CGFloat(-2*Double.pi/Double(slices*2.0)))
                    }
                }
            }
            
            //draw
            context.setStrokeColor(UIColor.black.cgColor)
            context.strokePath()
            
            context.restoreGState()
            
            let factor = CGFloat(random(2..<8))
            let deviation = CGFloat(random(Int(circumference/(slices*6))..<Int(layerWidth)))
            for _ in 0..<Int(slices) {
                context.rotate(by: CGFloat(2*Double.pi/Double(slices)))
                let circle = UIBezierPath(arcCenter: CGPoint(x: startRad+deviation, y: 0), radius: circumference/(slices*factor), startAngle: 0.0, endAngle: CGFloat(2.0*Double.pi), clockwise: false)
                context.addPath(circle.cgPath)
            }
            context.setStrokeColor(UIColor.black.cgColor)
            context.strokePath()
            
            print("petal")
        }
    }
}

class InnerCircleLayer: CALayerPattern {}

class OutterCircleLayer: CALayerPattern {}

class PetalsLayer: CALayerPattern {}

class CALayerPattern: CALayer {
    
    var startingRadius:CGFloat?
    var endingRadius:CGFloat?
    
    override init(){
        super.init()
    }
    
    init(startingRadius:CGFloat, endingRadius:CGFloat){
        super.init()
        self.startingRadius = startingRadius
        self.endingRadius = endingRadius
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func desenha(){
        // ...
        self.desenhaEspecifico()
        // ...
    }
    
    func desenhaEspecifico () {
        
    }
}
