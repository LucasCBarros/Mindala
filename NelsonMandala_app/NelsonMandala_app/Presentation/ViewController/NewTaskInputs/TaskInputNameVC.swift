//
//  taskInputNameVC.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 01/11/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit
import ScaledVisibleCellsCollectionView

class TaskInputNameVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var collectionColors: UICollectionView!
    @IBOutlet weak var collectionIcons: UICollectionView!
    
    fileprivate let cellIdentifier: String = "colorCell"
    fileprivate let iconCellIdentifier: String = "iconCollectionViewCell"
    fileprivate var currentSelectedIconIndex: Int = 0
    
    //var selectedColor: UIColor? = nil
    //var choosenName: String? = nil
    var delegate: InuptInfoExchangeProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapOnViewGesture = UITapGestureRecognizer(target: self, action: #selector(TaskInputNameVC.donePressed))
        tapOnViewGesture.delegate = self
        //self.view.addGestureRecognizer(tapOnViewGesture)
        
        let toolBar = UIToolbar(frame: CGRect(x: 20, y: self.view.frame.size.height/6, width: self.view.frame.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.black
        
        
        
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(TaskInputNameVC.doneToolPressed))

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([flexSpace, okBarBtn], animated: true)
        
        collectionColors.dataSource = self
        collectionColors.delegate = self
        nameTextField.delegate = self
        
        collectionIcons.dataSource = self
        collectionIcons.delegate = self
        
        nameTextField.inputAccessoryView = toolBar
        
        self.collectionIcons.setScaledDesginParam(scaledPattern: .HorizontalCenter, maxScale: 1, minScale: 1, maxAlpha: 1.0, minAlpha: 1)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func colorFromIndexPath(row: Int) -> UIColor{
        switch row {
        case 0:
            return UIColor.niVioletPink
        case 1:
            return UIColor.niMagenta
        case 2:
            return UIColor.niBubblegum
        case 3:
            return UIColor.niPeriwinkle
        case 4:
            return UIColor.niCoral
        default:
            return UIColor.niSalmon
        }
    }
    
    
    @objc func donePressed(_ gesture: UITapGestureRecognizer) {
        if (nameTextField.isFirstResponder) {
            nameTextField.resignFirstResponder()
            print("funcionou")
        }
    }
    
    @objc func doneToolPressed(sender: UIBarButtonItem){
        if(nameTextField.isFirstResponder){
            nameTextField.resignFirstResponder()
            print("teste")
        }
    }
    
}


extension TaskInputNameVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionColors {
            if let delegate = self.delegate {
                delegate.pushColor(color: colorFromIndexPath(row: indexPath.row))
            }
            
            for c in collectionView.visibleCells{
                c.layer.borderWidth = 0
            }
            
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.borderWidth = 2.0
            cell?.layer.borderColor = UIColor.white.cgColor
        }
        else {
            if let delegate = self.delegate {
                delegate.pushIcon(iconIndex: indexPath.row)
            }
            currentSelectedIconIndex = indexPath.row
            for c in collectionView.visibleCells {
                c.layer.borderWidth = 0
            }
            
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.borderColor = UIColor.white.cgColor
            cell?.layer.borderWidth = 2.0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.hashValue == self.collectionIcons.hashValue) {
            self.collectionIcons.scaledVisibleCells()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionIcons{
            return CGSize(width: 113, height: 113)
        }else{
            return CGSize(width: 50, height: 50)
        }
    }
    
}

extension TaskInputNameVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionColors {
            return 6
        }
        else {
            return 9
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionColors {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            
            if(indexPath.row == 0) {
                myCell.layer.borderWidth = 2.0
                myCell.layer.borderColor = UIColor.white.cgColor
            }
            
            myCell.backgroundColor = colorFromIndexPath(row: indexPath.row)
            myCell.layer.cornerRadius = myCell.bounds.width / 8
            myCell.renderShadow(shadowColor: UIColor.black, shadowOpacity: 1, shadowOffset: CGSize(width: 0, height: 30.0), shadowRadius: 10)
            
            return myCell
        }
        else {
//Collection linda
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: iconCellIdentifier, for: indexPath) as! IconCollectionViewCell
            
            myCell.backgroundImage.image = IconSelectionMechanism.imageFromInt(index: indexPath.row)
            
            if(indexPath.row != currentSelectedIconIndex) {
                myCell.layer.borderWidth = 0
            }
            else{
                myCell.layer.borderWidth = 2.0
                myCell.layer.borderColor = UIColor.white.cgColor
            }
            
            self.collectionIcons.scaledVisibleCells()
            
            return myCell
        }
    }
}

extension TaskInputNameVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //choosenName = nameTextField.text
        if let delegate = self.delegate {
            if nameTextField.text == nil || nameTextField.text == "" {
                delegate.pushName(name: "Task")
            }
            else {
                delegate.pushName(name: nameTextField.text!)
            }
        }
    }
}

extension TaskInputNameVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view {
            if view.isDescendant(of: collectionColors) {
                return false
            }
        }
        return true
    }

}
