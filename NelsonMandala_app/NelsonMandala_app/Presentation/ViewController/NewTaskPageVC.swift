//
//  NewTaskPageVC.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 26/10/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit
import Firebase

class NewTaskPageVC: UIPageViewController {

    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "vcName"),
                self.newVc(viewController: "vcDates"),
                self.newVc(viewController: "vcSummary")]
    }()
    
    var pageControl = UIPageControl()
    var backButton = UIButton()
//    var nextButton = UIButton()
    
    fileprivate var thisTask = Task()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        setupThisTask()
        
        //setup first page
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        //setup inicial page control
        //TODO: CONSTRAINT COM O BOTTON
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
        
        //// Botao todo
//        nextButton = UIButton(frame: CGRect(x: 312, y: 31, width: 46, height: 30))
//        self.nextButton.setTitle("Next" , for: .normal)
//        self.nextButton.addTarget(self, action: #selector(self.goToNextPage), for: .touchUpInside)
//        self.view.addSubview(self.nextButton)
        
        //TODO: Constraint do Botão de back
        backButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.minX + 16, y: UIScreen.main.bounds.minY + 38, width: 15, height: 25))
        self.backButton.setImage(#imageLiteral(resourceName: "arrowIcon"), for: .normal)
        self.backButton.addTarget(self, action: #selector(self.discardAndExit), for: .touchUpInside)
        self.view.addSubview(self.backButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupThisTask(){
        self.thisTask.name = "Task"
        self.thisTask.initTimeStamp = Date().timeIntervalSince1970 as NSNumber
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        components.hour = 23
        components.minute = 59
        self.thisTask.deadLineTimeStamp = calendar.date(from: components)!.timeIntervalSince1970 as NSNumber
        
        
        
        
        self.thisTask.icon = 0
        self.thisTask.reminders = []
        self.thisTask.colorAux = UIColor.niVioletPink
        self.thisTask.progressDays = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday]
        self.thisTask.currentWorkedSeconds = 0 as NSNumber
    }
    
    func newVc(viewController: String) -> UIViewController {
        let vc = UIStoryboard(name: "InputNewTask", bundle: nil).instantiateViewController(withIdentifier: viewController)
        if let overviewVC = vc as? TaskInputOverviewVC {
            overviewVC.delegate = self
        }
        if let dateVC = vc as? taskInputDateVC {
            dateVC.delegate = self
        }
        if let nameVC = vc as? TaskInputNameVC {
            nameVC.delegate = self
        }
        return vc
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

///// Codigo para botao next
//extension UIPageViewController {
//
//    @objc func goToNextPage(){
//
//        guard let currentViewController = self.viewControllers?.first else { return }
//
//        guard let nextViewController = dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return }
//
//        setViewControllers([nextViewController], direction: .forward, animated: false, completion: nil)
//
//    }
//
//
//    func goToPreviousPage(){
//
//        guard let currentViewController = self.viewControllers?.first else { return }
//
//        guard let previousViewController = dataSource?.pageViewController( self, viewControllerBefore: currentViewController ) else { return }
//
//        setViewControllers([previousViewController], direction: .reverse, animated: false, completion: nil)
//
//    }
//
//}

extension NewTaskPageVC: UIPageViewControllerDelegate {
   
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
}

extension NewTaskPageVC: UIPageViewControllerDataSource {
   
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //updateInfoOnTask()
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            //return orderedViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
             return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //updateInfoOnTask()
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            //return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        
        return orderedViewControllers[nextIndex]
    }
    
    /*fileprivate func updateInfoOnTask(){
        
        for vc in self.orderedViewControllers {
            if let nameVC = vc as? TaskInputNameVC {
                thisTask.name = nameVC.choosenName ?? ""
                thisTask.color = nameVC.selectedColor ?? UIColor.pinkColor
            }
            if let dateVC = vc as? taskInputDateVC {
                thisTask.deadLineTimeStamp = dateVC.deadlineDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
                thisTask.initTimeStamp = dateVC.startDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
                thisTask.progressDays = dateVC.selectedDays
                print(thisTask.progressDays)
            }
        }
    }*/
}

extension NewTaskPageVC: InuptInfoExchangeProtocol {
    
    func pushName(name: String) {
        thisTask.name = name
    }
    
    func pushStartDate(timestamp: Double) {
        thisTask.initTimeStamp = timestamp as NSNumber
    }
    
    func pushDeadline(timestamp: Double) {
        //padroniza as deadlines para 23:59 do dia em questao
        
        
        var date = Date.init(timeIntervalSince1970: timestamp)
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 23
        components.minute = 59
        date = calendar.date(from: components)!
        
        thisTask.deadLineTimeStamp = date.timeIntervalSince1970 as NSNumber
    }
    
    func pushWorkingDays(workingDays: [DayOfWeekEnum]) {
        thisTask.progressDays = workingDays
    }
    
    func pushColor(color: UIColor) {
        thisTask.colorAux = color
    }
    
    func pushIcon(iconIndex: Int) {
        thisTask.icon = iconIndex as NSNumber
    }
    
    func pushNotificationList(reminders: [Double]) {
        
        thisTask.reminders = reminders as [NSNumber]
    }
    
    func requestTask() -> Task {
        return thisTask
    }
    
    func saveAndExit() {
        print("salvou no firebase")
        //salva thisTask do jeito que tá no firebase
        //NESSE BLOCO DE COMPLETION DA PRA ATIVAR UMA ANIMACAO MANEIRA DE DADOS SALVOS NO VIEW CONTROLLER PRINCIPAL
        
        if let key = fbAddNewTask(){
            fbConnectUserTask(TaskKey: key)
        }
    }
    
    @objc func discardAndExit() {
        //Não salva nada aqui! só sai mesmo
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension NewTaskPageVC {
    
    /// Seta a task na tabela de TASKS e retorna a key da task
    ///
    /// - Returns: TaskKey(String)
    func fbAddNewTask()->String? {
        let ref = Database.database().reference().child("tasks")
        let randomKey = ref.childByAutoId()
        
        randomKey.updateChildValues(["name":thisTask.name!, "initTimeStamp":thisTask.initTimeStamp!, "deadLineTimeStamp":thisTask.deadLineTimeStamp!,"reminderDates":thisTask.reminders!, "color":thisTask.colorAux!.description,  "currentWorkedSeconds":thisTask.currentWorkedSeconds!, "icon":thisTask.icon!]) { (error, ref2) in
            if error != nil {
                fatalError("Nao inseriu a task")
            }
        }
        return randomKey.key
    }
    
    
    /// Funcao que faz a relação entre o usuario e sua task
    /// Após a setagem finaliza
    /// - Parameter key: TaskKey(String)
    func fbConnectUserTask(TaskKey key:String){
        var id = "123"
        guard let uid = Auth.auth().currentUser?.uid else {
//            fatalError("VOCE NAO ESTA LOGADO!")
            print("VOCE NAO ESTA LOGADO!")
            return
        }
        
        let ref = Database.database().reference().child("user-task").child(id)
        
        ref.updateChildValues([key:"task"]) { (error, ref) in
            if error != nil {
                fatalError("NAO ESTÁ RELACIONANDO")
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}




