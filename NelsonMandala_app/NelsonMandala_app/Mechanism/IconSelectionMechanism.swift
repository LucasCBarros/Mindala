//
//  IconSelectionMechanism.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 21/11/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import Foundation
import UIKit

class IconSelectionMechanism {
    
    class func imageFromInt(index: Int) ->UIImage {
        switch index {
        case 1:
            return UIImage(named: "GameIcon")!
        case 2:
            return UIImage(named: "MusicIcon")!
        case 3:
            return UIImage(named: "StudyIcon")!
        case 4:
            return UIImage(named: "ConstructionIcon")!
        case 5:
            return UIImage(named: "FootballIcon")!
        case 6:
            return UIImage(named: "MandalaIcon")!
        case 7:
            return UIImage(named: "MarketIcon")!
        case 8:
            return UIImage(named: "MoviesIcon")!
        default:
            return UIImage(named: "PandaIcon")!
        }
    }
    
    //class func int
    
}
