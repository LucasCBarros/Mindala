//
//  Task.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 17/10/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Task:NSObject {
    @objc var name: String?
    @objc var deadLineTimeStamp: NSNumber?
    @objc var initTimeStamp: NSNumber?
    @objc var icon: NSNumber?
    @objc var currentWorkedSeconds: NSNumber?
    @objc var color:String? {
        didSet{
            let colorArray = color!.split(separator: " ")
            self.colorAux = self.convertArrayToUIColor(ColorArray: colorArray)
        }
    }
    @objc var reminderDates:NSArray? {
        didSet{
            self.reminders = reminderDates as! [NSNumber]
            print(self.reminders)
        }
    }
    
    var key: String? {
        didSet{
            fbObserveMandalas()
        }
    }
    
    //Variáveis para setagem para o banco
    var reminders: [NSNumber]?
    var colorAux: UIColor?
    var progressDays: [DayOfWeekEnum]?
    var mandalaArray: [Mandala]?
    
    func convertArrayToUIColor(ColorArray array:[String.SubSequence]) ->UIColor {
        let r = CGFloat(Double(array[1])!)
        let g = CGFloat(Double(array[2])!)
        let b = CGFloat(Double(array[3])!)
        let a = CGFloat(Double(array[4])!)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func fbObserveMandalas(){
        if(self.mandalaArray == nil) {
            self.mandalaArray = []
        }
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("task-mandala").child(self.key!).observe(.childAdded, with: { (taskMandalaSnap) in
//                print("Owner(\(self.key): Key do meu snap " + taskMandalaSnap.key)
                let mandalaRef = Database.database().reference().child("mandala").child(taskMandalaSnap.key)
                mandalaRef.observe(.value, with: { (mandalaSnap) in
                    if let dictionary = mandalaSnap.value as? [String: Any] {
                        let newMandala = Mandala()
                        newMandala.setValuesForKeys(dictionary)
                        newMandala.key = mandalaSnap.key
                        self.mandalaArray?.append(newMandala)
//                        print("Nova mandala chave: \(newMandala.key) - tempo: \(newMandala.workingTime) - imageURL: \(newMandala.imageKey)")
                    }
                })
            })
        }
    }
}
