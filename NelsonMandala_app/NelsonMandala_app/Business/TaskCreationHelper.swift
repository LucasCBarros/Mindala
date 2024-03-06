//
//  TaskCreationHelper.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 17/10/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import Foundation

//Classe para ajudar a criar as datas de lembretes de uma task
class TaskCreationHelper {
    var task: Task
    init(task: Task) {
        self.task = task
    }
    
    //Cria as datas de lembrete padrão para a tarefa, retornando um vetor de timestamps
    func createStandardReminderDates() -> [Double]{
        var ret: [Double] = []
        var suitableDates: [Date] = []
        
        var initDate = Date(timeIntervalSince1970: TimeInterval(truncating: task.initTimeStamp!))
        var endDate = Date(timeIntervalSince1970: TimeInterval(truncating: task.deadLineTimeStamp!))
        
        //Setta o init date para o horário 0000
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: initDate)
        components.hour = 00
        components.minute = 00
        initDate = calendar.date(from: components)!
        
        //Setta o deadline date para o horário 0000
        let calendarDeadline = Calendar.current
        var componentsDeadline = calendarDeadline.dateComponents([.year, .month, .day, .hour, .minute, .second], from: endDate)
        componentsDeadline.hour = 23
        componentsDeadline.minute = 59
        endDate = calendarDeadline.date(from: componentsDeadline)!


        var testingDate = initDate
        
        while testingDate.timeIntervalSince1970 <= endDate.timeIntervalSince1970 {
            let dayOfWeek = Calendar.current.component(.weekday, from: testingDate)
            if(weekDayIsOnArray(weekDay: dayOfWeek)){
                suitableDates.append(testingDate)
            }
            
            //add 1 day to the date
            testingDate = NSCalendar.current.date(byAdding: .day, value: 1, to: testingDate, wrappingComponents: false)!
        }
        
        for date in suitableDates {
            ret.append(date.timeIntervalSince1970)
        }
        task.reminders = ret as [NSNumber]
        
        FirebasePersistence.updateTask()
        
        return ret
    }
    
}

//Extensão com funcoes helper pra criar as datas
extension TaskCreationHelper{
    
    
    fileprivate func weekDayIsOnArray(weekDay: Int) -> Bool{
        var validDays: [Int] = []
        for d in task.progressDays! {
            validDays.append(d.rawValue)
        }
        return validDays.contains(weekDay)
    }
    
    
    fileprivate func getNameFromEnum(dayOfWeek: Int) -> String{
        let value = DayOfWeekEnum(rawValue: dayOfWeek)!
        
        switch value {
        case DayOfWeekEnum.Monday:
            return "Monday"
        case DayOfWeekEnum.Friday:
            return "Friday"
        case DayOfWeekEnum.Wednesday:
            return "Wednesday"
        case DayOfWeekEnum.Tuesday:
            return "Tuesday"
        case DayOfWeekEnum.Thursday:
            return "Thursday"
        case DayOfWeekEnum.Saturday:
            return "Saturday"
        default:
            return "Sunday"
        }
    }
    
}

