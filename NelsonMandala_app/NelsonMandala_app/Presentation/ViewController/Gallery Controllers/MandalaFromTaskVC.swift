//
//  MandalaFromTaskVC.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 29/11/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//


import Foundation
import UIKit
import Haneke

class MandalaFromTaskVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    let reuseIdentifier = "galleryTaskCell"
    let segueIdentifier = "mandalaDetails"
    
    var selectedTask: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        
        navigationTitle.title = selectedTask?.name
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func infoPressed() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            if let mandala = sender as? Mandala {
                //PASS FORWARD THE MANDALA FOR THE NEXT VIEW CONTROLLER
                if let vc = segue.destination as? MandalaFromTaskDetail {
                    vc.mandalaUrl = mandala.imageKey
                    vc.mandalaTitle = DatesHelperMechanism.GetStringDateFromTimestamp(timestamp: (mandala.completionDate?.doubleValue)!)
                }
                
            }
        }
    }
}

extension MandalaFromTaskVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let tasks = selectedTask {
            print(tasks.mandalaArray?.count)
            if let mandalas = tasks.mandalaArray
            {
                return mandalas.count
            }
            else {
                return 0
            }
        }
        else
        {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IconCollectionViewCell
       
        let imageURL = URL.init(string: selectedTask!.mandalaArray![indexPath.row].imageKey!)
        cell.backgroundImage.hnk_setImage(from: imageURL)
        
        return cell
    }

}

extension MandalaFromTaskVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifier, sender: selectedTask!.mandalaArray![indexPath.row])
    }
    
}

extension MandalaFromTaskVC: UICollectionViewDelegateFlowLayout {
    
    var padding:CGFloat {
        get { return CGFloat(7.0) }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size:CGSize!
        
        let cellSize = ((view.bounds.size.width-3*padding)/2)
        size = CGSize(width: cellSize, height: cellSize)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
}



