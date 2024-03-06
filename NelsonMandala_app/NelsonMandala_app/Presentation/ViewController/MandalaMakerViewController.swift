//
//  MandalaMakerViewController.swift
//  NelsonMandala_app
//
//  Created by Lucas Barros on 14/11/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit
import AudioToolbox
import Firebase

class MandalaMakerViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var mandalaImage: UIImageView!
    @IBOutlet weak var mandalaBlockView: MandalaView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var doingTask: Task?
    weak var delegate: SectionTimePickerViewController?
    
    // Local Variables
    let frameDuration = 0.01
    var currentTime = 0.0
    var totalTime = 0.0
    var timer:Timer?
    var isRunning = true
    let mandalaIndexKey = "mandalaIndexKey"
    var mandalaIndex:Int = 0
   // var mandalas:[UIImage] = [#imageLiteral(resourceName: "mandala001"),#imageLiteral(resourceName: "mandala003"),#imageLiteral(resourceName: "mandala005"),#imageLiteral(resourceName: "mandala006"),#imageLiteral(resourceName: "mandala007"),#imageLiteral(resourceName: "mandala010"),#imageLiteral(resourceName: "mandala011"),#imageLiteral(resourceName: "mandala013"),#imageLiteral(resourceName: "mandala014"),#imageLiteral(resourceName: "mandala015"),#imageLiteral(resourceName: "mandala016"),#imageLiteral(resourceName: "mandala017"),#imageLiteral(resourceName: "mandala018"),#imageLiteral(resourceName: "mandala019"),#imageLiteral(resourceName: "mandala020"),#imageLiteral(resourceName: "mandala021"),#imageLiteral(resourceName: "mandala022"),#imageLiteral(resourceName: "mandala023"),#imageLiteral(resourceName: "mandala024")]

    fileprivate var isProximitySensorAvailable: Bool = true
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mandalaBlockView.mandalaBlockBackground()
        mandalaBlockView.mandalaBlockTexture()
    }
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OperationQueue.main.addOperation {
            self.view.layoutIfNeeded()
        }
        // Muda elementos mesma cor da Task
        returnButton.setTitleColor(doingTask?.colorAux, for: .normal)
        
//        // Retorna ao inicio do vetor de mandalas
//        mandalaIndex = UserDefaults.standard.integer(forKey: mandalaIndexKey)
//        mandalaIndex += 1
//        if (mandalaIndex >= mandalas.count) {
//            mandalaIndex = 0
//        }
        mandalaIndex = 0
        // Escolhe uma mandala do array
        //mandalaImage.image = mandalas[mandalaIndex]
        //UserDefaults.standard.set(mandalaIndex, forKey: mandalaIndexKey)
        
        let image = MandalaGenerator().drawMandala(layers: 8+Int((totalTime/(30.0*60.0))), imageFrame: mandalaImage)
        //let superCropper = ImageTransparentCropper()
        //let newImage = superCropper.CropImage(imageToCrop: image)
        mandalaImage.image = image
        mandalaImage.contentMode = .scaleAspectFill
        
        mandalaBlockView.mandalaImageRef = mandalaImage
        
        // Ativa sensor de proximidade
        if (!UIDevice.current.isProximityMonitoringEnabled) {
            UIDevice.current.isProximityMonitoringEnabled = true
            if(!UIDevice.current.isProximityMonitoringEnabled) {
                self.isProximitySensorAvailable = false
            }
        }
        
        // Ativa o timer
        timer = Timer.scheduledTimer(timeInterval: frameDuration, target: self, selector: (#selector(MandalaMakerViewController.updateTimer)), userInfo: nil, repeats: true)
        isRunning = true
        
//        mandalaBlockView.calculateProportion(currentTime: currentTime, totalTime: totalTime)
//        shareButton.isHidden = true
        doneButton.isHidden = true
        warningLabel.isHidden = false
        timeLabel.isHidden = true
    }
    
    @IBAction func finishMandala(_ sender: Any) {
        timer?.invalidate()
        UIDevice.current.isProximityMonitoringEnabled = false
        //gambiarra monstra só pra nao dar pra voltar a fazer a mandala depois de terminado
        self.isProximitySensorAvailable = true
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissMandala(_ sender: Any) {
        let alert = UIAlertController(title: "Confirmação", message: "Você realmente quer parar seu progresso?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { _ in
            self.finishMandala("")
        }))
        alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func updateTimer(){
        if ((UIDevice.current.orientation == .faceDown && !self.isProximitySensorAvailable) || (UIDevice.current.proximityState && self.isProximitySensorAvailable)) {
            warningLabel.isHidden = true
            if currentTime <= totalTime {
                // Atualiza o tamanho da view escondendo a mandala
                print(currentTime)
                mandalaBlockView.calculateProportion(currentTime: currentTime, totalTime: totalTime)
                currentTime += frameDuration
                timeLabel.isHidden = true
            } else {
                // Finalizou a mandala
                timeOver()
            }
        }
        else {
            timeLabel.isHidden = false
            timeLabel.text = "\(DatesHelperMechanism.GetHourAndMinFromSeconds(seconds: totalTime-currentTime)) \("labelWarning".localized)"
        }
    }
    
    func timeOver(){
        isRunning = false
        //shareButton.isHidden = false
        doneButton.isHidden = false
        timer?.invalidate()
        
        //FB
        doingTask!.currentWorkedSeconds! = NSNumber(value: currentTime + Double(truncating: doingTask!.currentWorkedSeconds!))
        updateWorkingHoursOnFB()
    }
    
    @objc func vibrationAlert(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    //    @IBAction func pauseButtonPressed(_ sender: UIButton) {
    //        if isRunning {
    //            pauseDrawing()
    //        } else {
    //            unpauseDrawing()
    //        }
    //    }
    
    func pauseDrawing() {
        isRunning = false
        timer?.invalidate()
        
        // Starts the vibration alert timer
        vibrationAlert()
    }
    
    func unpauseDrawing() {
        isRunning = true
        if currentTime > totalTime {
            self.dismiss(animated: false, completion: nil)
        }
        
        timer = Timer.scheduledTimer(timeInterval: frameDuration, target: self, selector: (#selector(MandalaMakerViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @IBAction func sharePress(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [self.mandalaImage.image], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//COISA DE FIREBASE
extension MandalaMakerViewController {
    
    /// Seta a task na tabela de TASKS e retorna a key da task
    ///
    /// - Returns: TaskKey(String)
    func updateWorkingHoursOnFB() {
        let ref = Database.database().reference().child("tasks").child(self.doingTask!.key!)
        
        ref.updateChildValues(["currentWorkedSeconds":self.doingTask!.currentWorkedSeconds!]) { (error, ref2) in
            if error != nil {
                fatalError("Nao inseriu a task")
            }
            self.createMandalaOnFB()
        }
        
    }
    
    func createMandalaOnFB() {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Storage.storage().reference().child(uid).child(String(Date().timeIntervalSince1970) + ".png")
            if let representation = mandalaImage.image!.pngData() {
                ref.putData(representation, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        fatalError("Nao inseriu a imagem")
                    }
                    //Criação da Mandala na DB
                    if let mandalaURL = metadata?.downloadURL()?.absoluteString {
                        let randomKey = Database.database().reference().child("mandala").childByAutoId()
                        let completionDate = Date().timeIntervalSince1970 as NSNumber
                        randomKey.updateChildValues(["completionDate":completionDate, "workingTime":self.currentTime, "imageKey":mandalaURL], withCompletionBlock: { (error, dbRef) in
                            if error != nil {
                                fatalError("Nao inseriu as informacoes da mandala")
                            }
                            
                            //Criação da relação entre mandala-task
                            let taskMandaRef = Database.database().reference().child("task-mandala").child(self.doingTask!.key!)
                            taskMandaRef.updateChildValues([randomKey.key:"mandala"], withCompletionBlock: { (error, ref) in
                                if error != nil {
                                    fatalError("NAO INSERIU FEZ A RELAÇÃO")
                                }
                            })
                            
                        })
                    }
                })
            }
        }
    }
    
}
