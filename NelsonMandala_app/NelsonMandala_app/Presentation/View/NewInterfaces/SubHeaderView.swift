//
//  SubHeaderView.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 31/10/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit

protocol subHeaderProtocol{
    
    func closeSubHeader()
}

//REFAZER A LOGICA SEM A SUBTASK

/*
class SubHeaderView: UIView {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var scrollableView: UIView!
    
    var subTaskList: [SubTask] = []
    
    var delegate: subHeaderProtocol?
    
    var currentIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(SubHeaderView.swipeLeft(_: )))
        swipeGestureLeft.direction = .left
        scrollableView.addGestureRecognizer(swipeGestureLeft)
        
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(SubHeaderView.swipeRight(_:)))
        swipeGestureRight.direction = .right
        scrollableView.addGestureRecognizer(swipeGestureRight)
        
        self.alpha = 0
        
    }
    
    func UpdateInfo(){
        if(subTaskList.count > 0){
            titleLabel.text = subTaskList[currentIndex].name
            //fazer as outras infos aqui
        }
        else{
            titleLabel.text = "No tasks for this day"
        }
    }
    
    
    @IBAction func closeDayTaskView(_ sender: UIButton) {
        if let delegate = self.delegate{
            delegate.closeSubHeader()
        }
    }
    
    @objc func swipeLeft(_ gesture: UISwipeGestureRecognizer) {
        if(gesture.direction == .left){
            currentIndex += 1
            if(currentIndex > subTaskList.count - 1){
                currentIndex = 0
            }
            UpdateInfo()
        }
    }
    
    @objc func swipeRight(_ gesture: UISwipeGestureRecognizer) {
        if(gesture.direction == .right){
            currentIndex -= 1
            if(currentIndex < 0){
                currentIndex = subTaskList.count - 1
            }
            UpdateInfo()
        }
    }

}
 */
