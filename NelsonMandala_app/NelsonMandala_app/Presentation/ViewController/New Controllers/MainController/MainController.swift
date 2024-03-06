//
//  MainController.swift
//  NelsonMandala_app
//
//  Created by Rhullian Damião on 01/11/2017.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit
import Firebase

class MainController: UIViewController {

    
    @IBOutlet weak var Header: MainHeader!
    //@IBOutlet var subHeaderView: SubHeaderView!
//    @IBOutlet weak var weekCalendar: weekCalendarView!
    @IBOutlet weak var tasksTableView: UITableView!
    
    //Contraint Top da table
    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    var topConstraintSubHeader:NSLayoutConstraint?
    
    let sectionTimerPickerViewSegueIdentifier: String = "createMandala"
    let gallerySegueIdentifier: String = "marcos"
    
    //Array das tasks
    var taskArray = [Task]()
    var displayTasksArray = [Task]()
    
    //UID do user logado
    var uid:String?
    
    // Cria um objeto da classe de notificacao
    var notificationController = NotificationController()
    
    //Referencia do UserTask
    var refUserTask:DatabaseReference?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        weekCalendar.delegate = self
        //self.topConstraintSubHeader = self.subHeaderView.topAnchor.constraint(equalTo: self.Header.bottomAnchor)
        
        if userIsLoggedIn() {
            self.uid = Auth.auth().currentUser?.uid
            refUserTask = Database.database().reference().child("user-task").child(uid!)
            fbObserveTasks()
//            fbObserveTaskUpdate()
        }else {
            fbLogout()
        }
        
        /// Realizar essa autorizacao na tela de login
        // Pede permissao para dar notificacoes
        notificationController.notificationPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !userIsLoggedIn(){
            self.fbLogout()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /// Retorna o valor dizendo o status da sessão
    ///
    /// - Returns: True(Sim) / False(Nao)
    func userIsLoggedIn()->Bool{
        //fazer autenticacao firebase
        return Auth.auth().currentUser != nil
    }
    
    @IBAction func handleLogOut(_ sender: UIButton) {
        self.fbLogout()
    }
    
    
    /// Funcao responsavel por trazer de volta para essa interface
    ///
    /// - Parameter sender: Segue de onde voce vem
    @IBAction func unwindToMainController(_ sender:UIStoryboardSegue?){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case sectionTimerPickerViewSegueIdentifier?:
                if let vc = segue.destination as? SectionTimePickerViewController {
                    if let index = sender as? Int
                    {
                        vc.doingTask = self.displayTasksArray[index]
                    }
                }
        case gallerySegueIdentifier?:
                if let vc = segue.destination as? MainGalleryVC {
                    vc.taskArray = self.taskArray
                }
        default:
            return
        }
    }
    
    func prepareDisplayTasksArray(){
        displayTasksArray = []
        for t in taskArray {
            print("\(t.name!) e horario: \(Date.init(timeIntervalSince1970: t.deadLineTimeStamp!.doubleValue))")
            let deadline = t.deadLineTimeStamp!.doubleValue
            if deadline > Date().timeIntervalSince1970 {
                displayTasksArray.append(t)
            }
        }
    }
    

}


extension MainController {
    /// Funcao que simplesmente realiza o Logout da Sessão
    func fbLogout(){
        do {
            try  Auth.auth().signOut()
                let loginVC = UIStoryboard(name: "LoginInterface", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginVC
            let dataRef = Database.database().reference()
            dataRef.removeAllObservers()
            OperationQueue.main.addOperation {
                self.present(loginVC, animated: true, completion: nil)
            }
            
        } catch let error{
            print(error)
        }
    }
    
    func fbObserveTasks(){
        if uid != nil{
        
            refUserTask!.observe(.childAdded, with: { (snap1) in
                
                let taskId = snap1.key
                
                let refTask = Database.database().reference().child("tasks").child(taskId)
                
                refTask.observe(.value, with: { (snap2) in
                    
                    if let dictionary = snap2.value as? [String:Any]{
                        let task = Task()
                        
                        task.setValuesForKeys(dictionary)
                        task.key = snap2.key
                        OperationQueue.main.addOperation {
                            self.taskArray.append(task)
                            self.prepareDisplayTasksArray()
                            self.tasksTableView.reloadData()
                            
                            self.notificationController.taskArray = self.taskArray
                            self.notificationController.createNotification()
                            refTask.removeAllObservers()
                            self.fbObserveTaskUpdate()
                        }
                    }
                }, withCancel: { (error2) in
                    print("NÃO CONSEGUI PEGAR A TASK")
                })
                
                
            }) { (error) in
                print("NÃO CONSEGUI PEGAR A USER-TASK")
            }
            
            
        }
    }
    
    func fbObserveTaskUpdate(){
        if uid != nil {
            Database.database().reference().child("tasks").observe(.childChanged, with: { (snap) in
                
                if let dic = snap.value as? [String:Any] {
                    let task = Task()
                    
                    task.setValuesForKeys(dic)
                    task.key = snap.key
                    
                    for i in 0..<self.taskArray.count {
                        if self.taskArray[i].key == task.key {
                            OperationQueue.main.addOperation {
                                self.taskArray[i].currentWorkedSeconds = task.currentWorkedSeconds
                                self.prepareDisplayTasksArray()
                                self.tasksTableView.reloadData()
                            }
                            
                        }
                    }
                }
                
                
            })
        }
    }
    
    //funciona, se mandar o parametro Key da task, ele apaga o nó inteiro do FB
    //Cuidado, não da pra voltar atrás depois de usar
    func fbDeleteTaskNode(taskKey: String) {
        if uid != nil {
            
            let dbRef = Database.database().reference()
            let taskRef = dbRef.child("tasks").child(taskKey)
            taskRef.removeValue()
        }
    }
    
//    //essa func exclui duplicadas no vertor task array
//    func cleanTaskArray() {
//        for i in 0..<taskArray.count - 1 {
//            for j in i+1..<taskArray.count{
//                if(taskArray[i].key == taskArray[j].key) {
//                    taskArray.remove(at: j)
//                }
//            }
//        }
//        prepareDisplayTasksArray()
//    }
    
}

















