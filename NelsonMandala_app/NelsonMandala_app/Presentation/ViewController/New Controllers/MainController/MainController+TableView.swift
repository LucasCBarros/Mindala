//
//  MainController+TableView.swift
//  NelsonMandala_app
//
//  Created by Rhullian Damião on 01/11/2017.
//  Copyright © 2017 lucasSantos. All rights reserved.
//


import UIKit

extension MainController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        
        cell.nameLabel.text = displayTasksArray[indexPath.row].name
        cell.timeLabel.text = DatesHelperMechanism.GetHourAndMinFromSeconds(seconds: (displayTasksArray[indexPath.row].currentWorkedSeconds!.doubleValue))
        cell.cardView.backgroundColor = displayTasksArray[indexPath.row].colorAux
        cell.taskIcon.image = IconSelectionMechanism.imageFromInt(index: displayTasksArray[indexPath.row].icon as! Int)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayTasksArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: sectionTimerPickerViewSegueIdentifier, sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            //os index do task array e do display nem sempre sao relacionados, tem que acertar no display e depois 
            let task = self.displayTasksArray[indexPath.row]
            let key = task.key!
            let index = self.taskArray.index(of: task)
            self.taskArray.remove(at: index!)
            self.displayTasksArray.remove(at: indexPath.row)

            self.fbDeleteTaskNode(taskKey: key)
            
            tableView.reloadData()
        }
    }
}
