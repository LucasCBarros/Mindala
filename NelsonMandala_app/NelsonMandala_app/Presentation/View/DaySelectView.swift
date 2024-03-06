//
//  DaySelectView.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 19/10/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

protocol daySelectViewProtocol {
    func didChangeDaySelection(selectedDays: [DayOfWeekEnum])
}

@IBDesignable
class DaySelectView: UIView {

    var selectedDays: [DayOfWeekEnum] = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday]
    
    @IBInspectable var fillColor: UIColor = UIColor.white
    @IBInspectable var emptyColor: UIColor = UIColor.lightGray
    @IBInspectable var fillTextColor: UIColor = UIColor.black
    @IBInspectable var emptyTextColor: UIColor = UIColor.white
    @IBInspectable var spacing: Int = 10
    @IBInspectable var interactible: Bool = true
    
    fileprivate var btnArray: [(UIView, DayOfWeekEnum)] = []
    
    var delegate: daySelectViewProtocol?
    
    override func layoutSubviews() {
        
        let iconSize = (self.frame.width - 8 * CGFloat(spacing)) / 7
        
        for i in 1...7 {
            let newView = UIView(frame: CGRect(x: self.bounds.minX + CGFloat((i) * spacing) + (CGFloat(i - 1) * iconSize), y: self.bounds.midY - iconSize/2, width: iconSize, height: iconSize))
            self.addSubview(newView)
            newView.layer.cornerRadius = newView.frame.width / 2
            
            let newLabel = UILabel(frame: CGRect(x: newView.bounds.minX, y: newView.bounds.minY, width: newView.frame.width, height: newView.frame.height))
            newView.addSubview(newLabel)
            newLabel.textAlignment = .center
            
            newLabel.text = DatesHelperMechanism.weekDayFirstLetterFromNumber(number: i)
            
            btnArray.append((newView, DayOfWeekEnum(rawValue: i)!))
            
            if interactible {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DaySelectView.touchDay(_: )))
                tapGesture.name = String(i)
                
                newView.addGestureRecognizer(tapGesture)
            }
        }
        
        updateSelectionVisual()
    }
    
     @objc func touchDay(_ day: UITapGestureRecognizer){
        
        let n = Int(day.name!)!
        
        let formatedDay = DayOfWeekEnum(rawValue: n)!
        if(selectedDays.contains(formatedDay)){
            selectedDays.remove(at: (selectedDays.index(of: formatedDay)!))
        }
        else {
            selectedDays.append(formatedDay)
        }
        updateSelectionVisual()
        
        if let delegate = self.delegate {
            delegate.didChangeDaySelection(selectedDays: self.selectedDays)
        }
        
    }
    
    func updateSelectionVisual(){
        for b in btnArray {
            if(selectedDays.contains(b.1)) {
                b.0.backgroundColor = fillColor
                
                for sub in b.0.subviews {
                    if let lbl = sub as? UILabel {
                        lbl.textColor = fillTextColor
                    }
                }
            }
            else {
                b.0.backgroundColor = emptyColor
                
                for sub in b.0.subviews {
                    if let lbl = sub as? UILabel {
                        lbl.textColor = emptyTextColor
                    }
                }
            }
        }
    }
    
    
}


