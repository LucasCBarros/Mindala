//
//  MainGalleryVC.swift
//  NelsonMandala_app
//
//  Created by Mauricio Lorenzetti on 28/11/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import Foundation
import UIKit

class MainGalleryVC: UIViewController {
    
    @IBOutlet weak var infoButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let galleryCellIdentifier = "galleryCell"
    let headerViewIdentifier = "headerView"
    let taskCellSegueIdentifier = "taskCellSegue"
    var taskArray = [Task]()
    var activeTaskArray = [Task]()
    var inactiveTaskArray = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activeTaskArray = taskArray.filter{($0.deadLineTimeStamp?.doubleValue)! > Date().timeIntervalSince1970}
        inactiveTaskArray = taskArray.filter{ t in
            !activeTaskArray.contains{ aT in
                t.key == aT.key
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == taskCellSegueIdentifier, let vc = segue.destination as? MandalaFromTaskVC {
            if let index = sender as? IndexPath {
                //print("ROW: \(index.row)   SECTION: \(index.section)")
                if(index.section == 0) {
                    vc.selectedTask = activeTaskArray[index.row]
                }
                else if(index.section == 1) {
                    vc.selectedTask = inactiveTaskArray[index.row]
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension MainGalleryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
            return activeTaskArray.count
        }
        return inactiveTaskArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: galleryCellIdentifier, for: indexPath) as! GalleryCell
        
        if (indexPath.section == 0) {
            
            if (activeTaskArray[indexPath.row].mandalaArray?.count == 0){
                cell.createGalleryCell(taskName: activeTaskArray[indexPath.row].name!, taskDetails: (activeTaskArray[indexPath.row].mandalaArray?.count)!, icon: IconSelectionMechanism.imageFromInt(index: Int(truncating: activeTaskArray[indexPath.row].icon!)), preview: nil, bgColor: activeTaskArray[indexPath.row].colorAux!)
            }
            else{
                cell.createGalleryCell(taskName: activeTaskArray[indexPath.row].name!, taskDetails: (activeTaskArray[indexPath.row].mandalaArray?.count)!, icon: IconSelectionMechanism.imageFromInt(index: Int(truncating: activeTaskArray[indexPath.row].icon!)), preview: URL.init(string: activeTaskArray[indexPath.row].mandalaArray![0].imageKey!), bgColor: activeTaskArray[indexPath.row].colorAux!)
            }
        } else if (indexPath.section == 1) {
            if (inactiveTaskArray[indexPath.row].mandalaArray?.count == 0){
                cell.createGalleryCell(taskName: inactiveTaskArray[indexPath.row].name!, taskDetails: (inactiveTaskArray[indexPath.row].mandalaArray?.count)!, icon:  IconSelectionMechanism.imageFromInt(index: Int(truncating: inactiveTaskArray[indexPath.row].icon!)), preview: nil, bgColor: inactiveTaskArray[indexPath.row].colorAux!)
            }
            else{
                cell.createGalleryCell(taskName: inactiveTaskArray[indexPath.row].name!, taskDetails: (inactiveTaskArray[indexPath.row].mandalaArray?.count)!, icon:  IconSelectionMechanism.imageFromInt(index: Int(truncating: inactiveTaskArray[indexPath.row].icon!)), preview: URL.init(string: inactiveTaskArray[indexPath.row].mandalaArray![0].imageKey!), bgColor: inactiveTaskArray[indexPath.row].colorAux!)
            }

        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerViewIdentifier, for: indexPath) as! GalleryHeaderView
            
            if (indexPath.section == 0){
                headerView.titleLabel.text = "MainGalleryVC".localized
            } else {
                headerView.titleLabel.text = "MainGalleryVC2".localized
            }
            
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: taskCellSegueIdentifier, sender: indexPath)
    }
}

extension MainGalleryVC: UICollectionViewDelegateFlowLayout {
    
    var padding:CGFloat {
        get { return CGFloat(14.0) }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size:CGSize!
        
        var cellWidth:CGFloat
        var cellHeight = view.bounds.size.height/7
        //if (indexPath.row == 0 && indexPath.section == 0) {
        //    cellWidth = (view.bounds.size.width-2*padding)
        //    cellHeight *= 2
        //} else {
        cellWidth = (view.bounds.size.width-3*padding)/2
        //}
        size = CGSize(width: cellWidth, height: cellHeight)
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 50)
    }
}










