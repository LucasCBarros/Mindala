//
//  GalleryCell.swift
//  NelsonMandala_app
//
//  Created by Mauricio Lorenzetti on 28/11/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit
import Haneke

class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDetails: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var cardView: UIView!
    
    let overlayOpacity = CGFloat(0.65)
    
    func createGalleryCell(taskName: String, taskDetails: Int, icon: UIImage?, preview: URL?, bgColor: UIColor) {
        self.backgroundColor = .clear
        self.taskName.text = taskName
        self.taskDetails.text = "\(taskDetails) Mandalas"
        background.backgroundColor = bgColor
        self.shadowView.backgroundColor = UIColor.black.withAlphaComponent(overlayOpacity)
        
        guard let icon = icon else {
            print("invalid icon image")
            return
        }
        self.icon.image = icon
        
        guard let preview = preview else {
            print("invalid preview image")
            return
        }
        self.previewImage.hnk_setImage(from: preview)
    }
}
