//
//  DatesHelperMechanism.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 20/10/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import Foundation

class DatesHelperMechanism{
    
    class func GetStringDateFromTimestamp(timestamp: Double) -> String{
        
        /*let date = Date(timeIntervalSince1970: timestamp)
        let day: Int = Calendar.current.component(.day, from: date)
        let month: Int = Calendar.current.component(.month, from: date)
        let year: Int = Calendar.current.component(.year, from: date)

        
        return String(day) + "/" + String(month) + "/" + String(year) */
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
    
    class func GetHourAndMinFromSeconds(seconds: Double) -> String {
        
        var sec = Int(seconds)
        
        let hour = sec / 3600
        sec -= hour * 3600
        let minutes = sec/60
        
        if(hour == 0) {
            if(minutes > 1) {
                return "\(minutes) \("DateHelperMechanisms".localized)"
            }
            else{
                return"\(minutes) \("DateHelperMechanism".localized)"
            }
        }
        else if(hour == 1) {
            if(minutes != 0) {
                return "1 \("DateHelperMechanismsHora".localized) \(minutes) \("DateHelperMechanisms".localized)"
            }
            else{
                return "1 \("DateHelperMechanismsHoraApenas".localized)"
            }
        }
        else{
            if(minutes != 0){
                return "\(hour) \("DateHelperMechanismsHoras".localized) \("DateHelperMechanisms".localized)"
            }
            else {
                return "\(hour) \("DateHelperMechanismsHorasApenas".localized)"
            }
        }
        
    }
    
    class func monthNameFromNumber(number: Int) -> String {
        
        let myDateFormatter = DateFormatter()
        myDateFormatter.locale = Locale.current
        return(myDateFormatter.monthSymbols[number - 1])
    }
    
    class func weekDayNameFromNumber(number: Int) -> String {
        
        let myDateFormatter = DateFormatter()
        myDateFormatter.locale = Locale.current
        return(myDateFormatter.weekdaySymbols[number - 1])

    }
    
    class func weekDayFirstLetterFromNumber(number: Int) -> String {
        
        let myDateFormatter = DateFormatter()
        myDateFormatter.locale = Locale.current
        return(myDateFormatter.veryShortWeekdaySymbols[number - 1])
        
    }
    
}
