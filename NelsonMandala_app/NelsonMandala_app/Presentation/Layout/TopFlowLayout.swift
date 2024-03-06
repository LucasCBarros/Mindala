//
//  TopFlowLayout.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 20/10/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

class TopFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        if let attrs = super.layoutAttributesForElements(in: rect) {
            
            // first baseline should always be stored so we take the least value initial limit
            var baseline: CGFloat = CGFloat.leastNormalMagnitude
            
            var sameLineElements = [UICollectionViewLayoutAttributes]()
            
            // for each attribute
            for element in attrs {
                
                // if it's a cell
                if element.representedElementCategory == .cell {
                    
                    // get the middle Y
                    let frame = element.frame
                    let centerY = frame.midY
                    
                    // compare with others just to find
                    if abs(centerY - baseline) > 1 {
                        
                        baseline = centerY
                        
                        alignToTopForSameLineElements(sameLineElements: sameLineElements)
                        
                        sameLineElements.removeAll()
                    }
                    
                    sameLineElements.append(element)
                }
            }
            
            alignToTopForSameLineElements(sameLineElements: sameLineElements) // align one more time for the last line
            return attrs
        }
        return nil
    }
    
    private func alignToTopForSameLineElements(sameLineElements: [UICollectionViewLayoutAttributes]) {
        
        // No deed to deal with aligment for only one element
        if sameLineElements.count < 1 {
            return
        }
        
        // sort all elements by their height from the smaller to the tallest
        let sorted = sameLineElements.sorted { (obj1: UICollectionViewLayoutAttributes, obj2: UICollectionViewLayoutAttributes) -> Bool in
            
            // height for earch object
            let height1 = obj1.frame.size.height
            let height2 = obj2.frame.size.height
            
            // difference from them
            let delta = height1 - height2
            
            // < 0 obj1 is smaller
            // = 0 they have the same height
            // > 0 obj1 is taller
            return delta <= 0
        }
        
        // tallest will be the last object
        if let tallest = sorted.last {
            
            for obj in sameLineElements {
                // calculate the y offset and update the frame
                obj.frame = obj.frame.offsetBy(dx: 0, dy: tallest.frame.origin.y - obj.frame.origin.y)
                
            }
        }
    }
}
