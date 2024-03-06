//
//  MainController+WeekView.swift
//  NelsonMandala_app
//
//  Created by Rhullian Damião on 01/11/2017.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

extension MainController: WeekCalendarHeaderProtocol{
    func touchOnDay(timestamp: String) {
        let doubleTimestamp = Double(timestamp)
        //buscar em um business todos as subs no dia dessa timestamp
        
        
        
        //self.view.addSubview(subHeaderView)
        //openSubHeader()
        //addConstraintsToSubHeader()
        
//        subHeaderView.delegate = self
//        subHeaderView.subTaskList = subTaskArray
//        subHeaderView.currentIndex = 0
//        subHeaderView.UpdateInfo()
        
        
    }
}

//extension MainController: subHeaderProtocol{
    //Fecha a view com as tasks dos dia
//    func closeSubHeader() {
//        tableTopConstraint.constant = 0
//        self.topConstraintSubHeader?.isActive = false
//        UIView.animate(withDuration: 0.3) {
//            self.subHeaderView.removeFromSuperview()
//            self.view.layoutIfNeeded()
//            self.subHeaderView.alpha = 0
//
//        }
//
//    }
//
//    //Abre a view com as tasks do dia
//    func openSubHeader(){
//        self.tableTopConstraint.constant = self.subHeaderView.frame.height + 10
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//            self.subHeaderView.alpha = 1
//        }
//    }
//
//    //Seta as constraints da view de tasks do dia
//    func addConstraintsToSubHeader(){
//        self.subHeaderView.translatesAutoresizingMaskIntoConstraints = false
//        self.topConstraintSubHeader?.isActive = true
//        //self.subHeaderView.centerXAnchor.constraint(equalTo: self.Header.centerXAnchor).isActive = true
//    }
//}
