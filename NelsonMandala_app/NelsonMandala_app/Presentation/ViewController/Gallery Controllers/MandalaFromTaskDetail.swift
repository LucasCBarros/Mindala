//
//  MandalaFromTaskDetail.swift
//  NelsonMandala_app
//
//  Created by Ricardo Ferreira on 29/11/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit
import Haneke

class MandalaFromTaskDetail: UIViewController {

    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var mandalaImg: UIImageView!
    @IBOutlet weak var titleItem: UINavigationItem!
    var mandalaUrl: String!
    var mandalaTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageURL = URL.init(string: mandalaUrl)
        mandalaImg.hnk_setImage(from: imageURL)
        titleItem.title = mandalaTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    @IBAction func sharePress(_ sender: Any) {
        let actityVC = UIActivityViewController(activityItems: [self.mandalaImg.image], applicationActivities: nil)
        actityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(actityVC, animated: true, completion: nil)
    }
    
    

}
