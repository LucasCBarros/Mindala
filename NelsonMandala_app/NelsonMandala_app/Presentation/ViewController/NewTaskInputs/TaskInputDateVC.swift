//
//  taskInputDateVC.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 26/10/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

//PEGAR A DATA ATUAL NO INICIO DO VIEW CONTROLLER
//MOSTRAR O TECLADO COM A DATA QUE TA SELECIONADA NO TEXTFIELD

import UIKit

class taskInputDateVC: UIViewController {

    @IBOutlet weak var dayPicker: DaySelectView!
    @IBOutlet weak var startDateTxtField: UITextField!
    @IBOutlet weak var deadlineTxtField: UITextField!
    
   
    var startDate: Date? = nil
    var deadlineDate: Date? = nil
    var delegate: InuptInfoExchangeProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapOnViewGesture = UITapGestureRecognizer(target: self, action: #selector(taskInputDateVC.donePressed))
        self.view.addGestureRecognizer(tapOnViewGesture)
        
        //fazendo a toolbar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.black
        
        
        let todayBtn = UIBarButtonItem(title: "Hoje", style: UIBarButtonItem.Style.plain, target: self, action: #selector(taskInputDateVC.toolbarToToday))
        
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(taskInputDateVC.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont.niCreateTaskTitle
        
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.white
        
        label.text = "Selecione uma data"
        
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([todayBtn,flexSpace,textBtn,flexSpace,okBarBtn], animated: true)
        
        startDateTxtField.placeholder = DatesHelperMechanism.GetStringDateFromTimestamp(timestamp: Date().timeIntervalSince1970)
        deadlineTxtField.placeholder = DatesHelperMechanism.GetStringDateFromTimestamp(timestamp: Date().timeIntervalSince1970)

        startDateTxtField.inputAccessoryView = toolBar
        deadlineTxtField.inputAccessoryView = toolBar
        dayPicker.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func startDateEdit(sender: UITextField){
        print("startDateEdit")
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        
        //Settando datas minimas e maximas para o picker view
        if(startDateTxtField.isFirstResponder){
            //CURRENT SELECTED DATE AS STARTING VALUE TO THE PICKER
            if let sDate = startDate {
                datePickerView.date = sDate
            }
            datePickerView.minimumDate = Date()
            let maxDate = NSCalendar.current.date(byAdding: .month, value: 3 , to: Date())!
            datePickerView.maximumDate = maxDate
        }
        else if(deadlineTxtField.isFirstResponder){
            //CURRENT SELECTED DATE AS STARTING VALUE TO THE PICKER
            if let dDate = deadlineDate {
                datePickerView.date = dDate
            }
            
            if let startDate = self.startDate{
                datePickerView.minimumDate = startDate
            }
            else{
                datePickerView.minimumDate = Date()
            }
            let maxDate = NSCalendar.current.date(byAdding: .year, value: 6 , to: Date())!
            datePickerView.maximumDate = maxDate
        }
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(taskInputDateVC.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        if(startDateTxtField.isFirstResponder){
            startDateTxtField.text = DatesHelperMechanism.GetStringDateFromTimestamp(timestamp: sender.date.timeIntervalSince1970)
            startDate = sender.date
            //send START to delegate
            if let delegate = self.delegate {
                delegate.pushStartDate(timestamp: sender.date.timeIntervalSince1970)
            }
            //verifica se a data inicial é maior que a final, e manda atualizar
            if let deadline = deadlineDate {
                if(deadline < startDate!) {
                    deadlineTxtField.text = DatesHelperMechanism.GetStringDateFromTimestamp(timestamp: startDate!.timeIntervalSince1970)
                    deadlineDate = startDate!
                    if let delegate = self.delegate {
                        delegate.pushDeadline(timestamp: startDate!.timeIntervalSince1970)
                    }
                }
            }
        }
        else if(deadlineTxtField.isFirstResponder){
            deadlineTxtField.text = DatesHelperMechanism.GetStringDateFromTimestamp(timestamp: sender.date.timeIntervalSince1970)
            deadlineDate = sender.date
            //send DEADLINE to delegate
            if let delegate = self.delegate {
                delegate.pushDeadline(timestamp: sender.date.timeIntervalSince1970)
            }
        }
    }
    
    @objc func donePressed(sender: UIBarButtonItem){
        if(startDateTxtField.isFirstResponder){
            startDateTxtField.resignFirstResponder()
        }
        else if(deadlineTxtField.isFirstResponder){
            deadlineTxtField.resignFirstResponder()
        }
    }
    
    @objc func toolbarToToday(sender: UIBarButtonItem){
        
        if(startDateTxtField.isFirstResponder){
            startDateTxtField.text = DatesHelperMechanism.GetStringDateFromTimestamp(timestamp: Date().timeIntervalSince1970)
            startDate = Date()
            startDateTxtField.resignFirstResponder()
            if let delegate = self.delegate {
                delegate.pushStartDate(timestamp: Date().timeIntervalSince1970)
            }
        }
        else if(deadlineTxtField.isFirstResponder){
            deadlineTxtField.text = DatesHelperMechanism.GetStringDateFromTimestamp(timestamp: Date().timeIntervalSince1970)
            deadlineDate = Date()
            deadlineTxtField.resignFirstResponder()
            if let delegate = self.delegate {
                delegate.pushDeadline(timestamp: Date().timeIntervalSince1970)
            }
        }
        
    }
    

}

extension taskInputDateVC: daySelectViewProtocol {
    
    func didChangeDaySelection(selectedDays: [DayOfWeekEnum]) {
        if let delegate = self.delegate {
            delegate.pushWorkingDays(workingDays: selectedDays)
        }
    }
    
}
