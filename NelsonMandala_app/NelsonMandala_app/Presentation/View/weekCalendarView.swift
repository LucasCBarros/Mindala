//
//  weekCalendarView.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 30/10/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

protocol WeekCalendarHeaderProtocol {
    func touchOnDay(timestamp: String)
}


@IBDesignable
class weekCalendarView: UIView {

    @IBInspectable var spacing: Int = 12
    @IBInspectable var spacingMonthToDays: Int = 8
    
    var delegate: WeekCalendarHeaderProtocol?
    
    fileprivate var numberLabels: [UILabel] = []
    
    override func layoutSubviews() {
        super.awakeFromNib()
        
        
        let monthLabel = UILabel(frame: CGRect(x: self.bounds.minX + self.bounds.width / 4, y: self.bounds.minY, width: self.bounds.width / 2, height: self.bounds.height / 2))
        self.addSubview(monthLabel)
                
        //label properties
        monthLabel.textAlignment = .center
        monthLabel.baselineAdjustment = .alignCenters
        monthLabel.textColor = UIColor(red: 218/255.0, green: 0/255.0, blue: 201/255.0, alpha: 1.0)
        monthLabel.font = UIFont(name: "Avenir-Book", size: 24)
        monthLabel.numberOfLines = 1
        monthLabel.adjustsFontSizeToFitWidth = true
        monthLabel.minimumScaleFactor = 0.1
        
        monthLabel.text = DatesHelperMechanism.monthNameFromNumber(number: Calendar.current.component(.month, from: Date()))
        
        
        for i in 1...7 {
            let newView = UIView(frame:  CGRect(x: self.bounds.minX + CGFloat((i) * spacing) + (CGFloat(i - 1) * 31), y: self.bounds.midY + CGFloat(spacingMonthToDays), width: 31, height: 31))
            self.addSubview(newView)
            
            let newLabel = UILabel(frame: CGRect(x: newView.bounds.minX, y: newView.bounds.minY, width: newView.frame.width, height: newView.frame.height))
            newView.addSubview(newLabel)
            
            //label properties
            newLabel.textAlignment = .center
            newLabel.baselineAdjustment = .alignCenters
            newLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            
            //isso nao da pra usar certinho, tem que pegar o tamanho do primeiro e aplicar pros outros
            /*newLabel.font = UIFont(name: fontTypeFace, size: 200)
            newLabel.numberOfLines = 1
            newLabel.adjustsFontSizeToFitWidth = true
            newLabel.minimumScaleFactor = 0.1*/
            
            let dayToAnalyse = NSCalendar.current.date(byAdding: .day, value: (i-4) , to: Date())!
            let day = Calendar.current.component(.day, from: dayToAnalyse)

            
            newLabel.text = String(day)
            newLabel.font = UIFont(name: "Avenir-Light", size: 27)
            if(i - 4 == 0){
                newLabel.font = UIFont.boldSystemFont(ofSize: 27)
            }
            else if(abs(i - 4) == 2){
                newLabel.alpha = 0.6
            }
            else if(abs(i - 4) == 3){
                newLabel.alpha = 0.3
            }
            
            numberLabels.append(newLabel)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(weekCalendarView.touchDay(_: )))
            tapGesture.name = String(dayToAnalyse.timeIntervalSince1970)
            
            newView.addGestureRecognizer(tapGesture)
        }
        
    }
    
    //AÇAO PARA QUANDO TOCA EM UM DOS DIAS DO CALENDARIO
    @objc func touchDay(_ day: UITapGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.touchOnDay(timestamp: day.name!)
        }
        
        //update visual
    }
    
}

