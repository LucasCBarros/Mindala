//
//  TasksListVC.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 25/10/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

class TasksListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var subHeaderView: SubHeaderView!
    @IBOutlet weak var weekCalendarView: weekCalendarView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    fileprivate let taskCellIdentifier = "taskCell"
    fileprivate let taskDetailSegueIdentifier = "taskDetailIdentifier"
    fileprivate var taskList: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        weekCalendarView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        /*//PARA TESTE!!!
        var myTask = Task(name: "Estudar química", progressDays: [DayOfWeekEnum.Thursday, DayOfWeekEnum.Friday], deadLineTimeStamp: NSCalendar.current.date(byAdding: .day, value: 30, to: Date())!.timeIntervalSince1970, initTimeStamp: Date().timeIntervalSince1970, subTasks: nil)
        
        let taskHelper = TaskCreationHelper(task: myTask)
        myTask.subTasks = taskHelper.createStandardSubTasks()
        
        var anotherTask = Task(name: "Freela do Jorge", progressDays: [DayOfWeekEnum.Saturday, DayOfWeekEnum.Sunday], deadLineTimeStamp: NSCalendar.current.date(byAdding: .day, value: 60, to: Date())!.timeIntervalSince1970, initTimeStamp: Date().timeIntervalSince1970, subTasks: nil)
        
        let anotherTaskHelper = TaskCreationHelper(task: anotherTask)
        anotherTask.subTasks = anotherTaskHelper.createStandardSubTasks()
        
        taskList.append(myTask)
        taskList.append(anotherTask)
        //FIM DO TESTE!
        */
        //pegar as tasks do querido user
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}

extension TasksListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: taskDetailSegueIdentifier, sender: taskList[indexPath.row])
    }
    
}

extension TasksListVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCellIdentifier) as! TaskTableViewCell
        
        let task = taskList[indexPath.row]
        
        cell.nameLabel.text = task.name
        var hourCount: Double = 0
        
        cell.timeLabel.text = DatesHelperMechanism.GetHourAndMinFromSeconds(seconds: hourCount)
        
        return cell
    }
}

extension TasksListVC: WeekCalendarHeaderProtocol{
    func touchOnDay(timestamp: String) {
        let doubleTimestamp = Double(timestamp)
        //buscar em um business todos as subs no dia dessa timestamp
        
        //DADOS MOCADOS
        
        //DADOS MOCADOS
        /*
        //Criar o espaco necessario pra colocar essa view
        //subHeaderViewInstance = SubHeaderView(frame: CGRect(x: self.view.frame.minX, y: self.view.frame.minY + 200, width: self.view.frame.width, height: 100))
        self.view.addSubview(subHeaderView)
        subHeaderView.frame = CGRect(x: self.view.frame.minX, y: weekCalendarView.frame.minY + weekCalendarView.frame.height, width: self.view.frame.width, height: 120)
        
        tableViewTopConstraint.constant = 120
        
        subHeaderView.subTaskList = subTaskArray
        subHeaderView.currentIndex = 0
        subHeaderView.UpdateInfo()
        subHeaderView.delegate = self
        */
        
        /*print(subTaskArray[0].name)
        subHeaderViewInstance!.subTaskList = subTaskArray
        subHeaderViewInstance!.currentIndex = 0
        subHeaderViewInstance!.UpdateInfo()
        subHeaderViewInstance!.delegate = self*/
    }
}

extension TasksListVC: subHeaderProtocol{
    func closeSubHeader() {
        //tableViewTopConstraint.constant = 10
        //subHeaderView.removeFromSuperview()
    }
}
