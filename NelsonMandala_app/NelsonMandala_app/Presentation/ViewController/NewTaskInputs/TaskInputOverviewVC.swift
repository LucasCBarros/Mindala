//
//  TaskInputOverviewVC.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 08/11/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

class TaskInputOverviewVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var deadLineLabel: UILabel!
    @IBOutlet weak var workingHoursLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var daySelectView: DaySelectView!
    @IBOutlet var labelsToPaint: [UILabel]!
    @IBOutlet weak var whiteCardView: UIView!
    
    var delegate: InuptInfoExchangeProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //iconImageView.renderShadow(shadowColor: UIColor.black, shadowOpacity: 0.5, shadowOffset: CGSize.init(width: 0, height: 30.0), shadowRadius: 5)
        whiteCardView.renderShadow(shadowColor: UIColor.black, shadowOpacity: 0.3, shadowOffset: CGSize.init(width: 0, height: 0.5), shadowRadius: 0.5)
        whiteCardView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let delegate = self.delegate {
            
            let myTask = delegate.requestTask()
            
            titleLabel.text = myTask.name
            iconImageView.image = IconSelectionMechanism.imageFromInt(index: Int(truncating: myTask.icon!))
            
            //datas
            startDateLabel.text = DatesHelperMechanism.GetStringDateFromTimestamp(timestamp: myTask.initTimeStamp! as! Double)
            deadLineLabel.text = DatesHelperMechanism.GetStringDateFromTimestamp(timestamp: myTask.deadLineTimeStamp! as! Double)
            
            daySelectView.selectedDays = myTask.progressDays!
            self.view.backgroundColor = myTask.colorAux
            
            for l in labelsToPaint {
                l.textColor = myTask.colorAux
                daySelectView.fillColor = myTask.colorAux!
                daySelectView.updateSelectionVisual()
            }
            let myTaskHelper = TaskCreationHelper(task: myTask)
            let reminders = myTaskHelper.createStandardReminderDates()
            if let delegate = self.delegate {
                delegate.pushNotificationList(reminders: reminders)
            }
            if(reminders.count==1){
                workingHoursLabel.text = "\(reminders.count) \("workingHoursLabel".localized)"
//                workingHoursLabel.text = "\(reminders.count) Dias de trabalho"
            } else {
                workingHoursLabel.text = "\(reminders.count) \("workingHoursLabel".localized)"
            }
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    @IBAction func saveAndExit() {
        if let delegate = self.delegate {
            delegate.saveAndExit()
        }
    }

}
