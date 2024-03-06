//
//  NotificationController.swift
//  NelsonMandala_app
//
//  Created by Lucas Barros on 17/11/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationController {
    
    //Array das tasks
    var taskArray = [Task]()
    var taskIndex = 0
    var taskCounter = 0
    
    // Funcao que trata possiveis problemas como numero de tarefas
    func createNotification(){
        if(taskCounter<taskArray.count){
            createNotificationLoop()
        }
    }
    
    // Funcao com loop para abrir todas sessoes de cada tarefa
    //NOSSO SUPOSTO CRASH FOI AQUI
    func createNotificationLoop(){
        var counter = 1
        for i in (0+taskCounter)..<(taskArray.count) {
            taskCounter=taskCounter+1
            if let reminders = taskArray[i].reminders
            {
                for j in 0..<(reminders.count) {
                    print(">>>>>>>> \(taskArray[i].reminders!)")
                    addNotificationToCentral( taskCount: i, reminderCount: j)
                    counter=counter+1
                }
            }

            
            
        }
        
        
        
    }
    
    // Funcao que adciona notificacoes na central
    func addNotificationToCentral(taskCount:Int, reminderCount:Int){
        
        // Parametros para notificar
        let notification = UNMutableNotificationContent()
        notification.title = taskArray[taskCount].name! // Titulo da tarefa
        notification.body = "Evite procastinar, complete suas tarefas!" // Mensagem da notificacao
        let notificationIdentifier = "Timer"+String(taskCount)+String(reminderCount)
        
        // Pega a data de uma section da tarefa
        var notificationDate = NSDate(timeIntervalSince1970: taskArray[taskCount].reminders![reminderCount].doubleValue) as Date? // Converte data recebida para  NSDate e depois converte para Date
        
        // Muda padrao de horario de notificacao
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate!)
        components.hour = 14
        components.minute = 40
        notificationDate = calendar.date(from: components)!
        
        let notificationTime = (notificationDate?.timeIntervalSince1970)! - Date().timeIntervalSince1970
        
        // Se maior que zero cria a notificacao
        if (notificationTime>0){
            // Time till notifications are called
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notificationTime, repeats: false)
            // Requests the notification
            let request = UNNotificationRequest (identifier: notificationIdentifier, content: notification, trigger: trigger)
            //Creates the notification
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    //Funcao que pede autorizacao para notificar
    func notificationPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
    }
}
