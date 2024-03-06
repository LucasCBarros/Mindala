//
//  SectionTimePickerViewController.swift
//  NelsonMandala_app
//
//  Created by Lucas Barros on 14/11/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit
import HGCircularSlider

class SectionTimePickerViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var circularSlider: CircularSlider!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var rememberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var doingTask: Task?
    
    // Valores do picker
    let time = [1,2,3,4,5,10,15,20,25,30,45,60,90,120]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Muda cor das labels com cor da task
        if let taskName = doingTask?.name, let taskColor = doingTask?.colorAux {
            taskTitleLabel.text = taskName
            taskTitleLabel.textColor = taskColor
            rememberLabel.textColor = taskColor
            returnButton.setTitleColor(taskColor, for: .normal)
            timeLabel.textColor = taskColor
            startButton.setTitleColor(taskColor, for: .normal)
            circularSlider.trackFillColor = taskColor
            let thumbColor = UIColor(red: taskColor.components.red*0.8, green: taskColor.components.green*0.8, blue: taskColor.components.blue*0.8, alpha: taskColor.components.alpha)
            circularSlider.endThumbTintColor = thumbColor
        }
        
        //Circular slider
        circularSlider.endPointValue = 0.25
        circularSlider.addTarget(self, action: #selector(updateDisplay), for: .valueChanged)
        updateDisplay()
    }
    
    @objc func updateDisplay() {
        let interval = Int(circularSlider.endPointValue * 121.0)
        timeLabel.text = "\(String(format: "%02d", interval / 60)):\(String(format: "%02d", interval % 60))"
    }
    
    // Chama a segue para a view que irá fazer a mandala
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startMandala",
            let mandalaViewController = segue.destination as? MandalaMakerViewController {
            mandalaViewController.delegate = self
            // Passa o valor selecionado pelo picker para ser o valor do timer
            //ADICIONAR * 60 NO FINAL DESSA CONTA !!!!
            mandalaViewController.totalTime = TimeInterval(circularSlider.endPointValue * 121.0 * 60)
            mandalaViewController.doingTask = self.doingTask
        }
        
    }
    @IBAction func dismissTask(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// Extensao de picker padrao
extension SectionTimePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return time.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: time[row])
    }
}

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
}

extension UIColor {
    
    func add(overlay: UIColor) -> UIColor {
        var bgR: CGFloat = 0
        var bgG: CGFloat = 0
        var bgB: CGFloat = 0
        var bgA: CGFloat = 0
        
        var fgR: CGFloat = 0
        var fgG: CGFloat = 0
        var fgB: CGFloat = 0
        var fgA: CGFloat = 0
        
        self.getRed(&bgR, green: &bgG, blue: &bgB, alpha: &bgA)
        overlay.getRed(&fgR, green: &fgG, blue: &fgB, alpha: &fgA)
        
        let r = fgA * fgR + (1 - fgA) * bgR
        let g = fgA * fgG + (1 - fgA) * bgG
        let b = fgA * fgB + (1 - fgA) * bgB
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    static func +(lhs: UIColor, rhs: UIColor) -> UIColor {
        return lhs.add(overlay: rhs)
    }
}

