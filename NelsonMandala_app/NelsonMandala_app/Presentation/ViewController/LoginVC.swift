 //
//  LoginVC.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 13/11/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit
import Firebase

@IBDesignable
class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextFiel: UITextField!
    @IBOutlet weak var segmentControllerView: SegmentView!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet var constraintToBreak: NSLayoutConstraint!
    @IBOutlet weak var nameSeparator: UIView!
    
    fileprivate var isOnLogin = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentControllerView.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        nameTextFiel.delegate = self
        
        nameTextFiel.font = UIFont.niTextFieldFont
        passwordTextField.font = UIFont.niTextFieldFont
        emailTextField.font = UIFont.niTextFieldFont
        
        actionButton.titleLabel?.font = UIFont.niButtonFont

        updateLayouts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Esta "Função" retorna o padrão de cor desejado
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func login() {
        
        guard let email = emailTextField.text, let pswd = passwordTextField.text else {
            print("Fazer alert para dizer que campos obrigatórios estão vazios")
            return
        }
        
        //FAZER AUTENTICAÇAO NO FIREBASE
        self.fbLogin(UserEmail: email, UserPassword: pswd ) { (alert) in
//            if alert != nil {
//                self.present(alert!, animated: true, completion: nil)
//                return
//            } else{
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "mainSegue", sender: nil)
                }
//            }
            
        }
        
    }
    
    @objc func createAccount() {
        guard let name = nameTextFiel.text, let email = emailTextField.text, let pswd = passwordTextField.text else {
            print("Fazer alert para dizer que campos obrigatórios estão vazios")
            return
        }
        
        //FAZER REGISTRO NO FIREBASE
        fbCreateUser(UserName: name, UserPassword: pswd, UserEmail: email){ (alert) in
            if alert != nil {
                self.present(alert!, animated: true, completion: nil)
                return
            }
            
            OperationQueue.main.addOperation {
                self.performSegue(withIdentifier: "mainSegue", sender: nil)
            }
        }
    }
    
    @IBAction func forgotPassword() {
        //Nao sei o que fazer aqui!
    }
    
    fileprivate func updateLayouts(){
        
        if(isOnLogin){
            constraintToBreak.isActive = false
            nameTextFiel.isHidden = true
            nameSeparator.isHidden = true
            actionButton.setTitle("Login", for: .normal)
            forgotPasswordButton.isHidden = false
            self.actionButton.removeTarget(self, action: #selector(createAccount), for: .touchUpInside)
            self.actionButton.addTarget(self, action: #selector(login), for: .touchUpInside)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
        else{
            constraintToBreak.isActive = true
            nameTextFiel.isHidden = false
            nameSeparator.isHidden = false
            actionButton.setTitle("Criar conta", for: .normal)
            forgotPasswordButton.isHidden = true
            self.actionButton.removeTarget(self, action: #selector(login), for: .touchUpInside)
            self.actionButton.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainSegue" {
            let destination = segue.destination as! MainController
            destination.taskArray = []
//            destination.displayTasksArray = []
            destination.tasksTableView.reloadData()
            guard let id = Auth.auth().currentUser?.uid else {
                destination.uid = "123"
                return
            }
            destination.uid = Auth.auth().currentUser?.uid
            destination.refUserTask = Database.database().reference().child("user-task").child(destination.uid!)
            destination.fbObserveTasks()
            
        }
    }

}

//MARK: Extension do Textfield
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// Funcao que checa se o Textfield do NOME está vazio
    ///
    /// - Returns: True(Sim) / False(Não)
    func nameTxtFieldIsEmpty()->Bool{
        return nameTextFiel.text! == ""
    }
    
    /// Funcao que checa se o Textfield da SENHA está vazio
    ///
    /// - Returns: True(Sim) / False(Não)
    func passwordTxtFieldIsEmpty()->Bool{
        return passwordTextField.text! == ""
    }
    
    /// Funcao que checa se o Textfield do EMAIL está vazio
    ///
    /// - Returns: True(Sim) / False(Não)
    func emailTxtFieldIsEmpty()->Bool{
        return emailTextField.text! == ""
    }
    
}

//MARK: Extension do segmented Control
extension LoginVC: SegmentViewProtocol {
    
    //Recebe a mudança no segment controller
    func OnSegmentSelectionChange(selectedSegment: Int) {
        if(selectedSegment == 0){
            isOnLogin = true
        }
        else {
            isOnLogin = false
        }
        updateLayouts()
    }

}

//MARK: Extension do Firebase
extension LoginVC{
    
    /// Funcao que cria um usuário completo com base nos parâmetros passados.
    /// Passos:
    ///    1-Cria o usuário com email e senha para o AUTHENTICATION
    ///    2-Cria o usuário com seu email e nome do DATABASE
    ///
    /// - Parameters:
    ///   - name: User(String)
    ///   - pass: User(String)
    ///   - email: User(String)
    func fbCreateUser(UserName name:String, UserPassword pass:String, UserEmail email:String, completion: @escaping (UIAlertController?) -> Void) {
        if nameTxtFieldIsEmpty() || passwordTxtFieldIsEmpty() || emailTxtFieldIsEmpty(){
            print("CAMPOS OBRIGATÓRIOS ESTÃO VAZIOS - CADASTRO")
            return
        }
        
        //AUTHENTICATION
        Auth.auth().createUser(withEmail: email, password: pass) { (User, error) in
            //Error de AUTHENTICATION, caso haja.
            if let err = error {
                let errorString = self.translatesGivenError(error: String(describing:err))
                let errorNotification = UIAlertController(title: "Erro no Cadastro", message: errorString, preferredStyle: .alert)
                let errorAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                errorNotification.addAction(errorAction)
                
                OperationQueue.main.addOperation {
                    completion(errorNotification)
                }
                return
            }
            
            //DATABASE
            guard let uid = User?.uid else{
                print("uid nao criado")
                return
            }
            
            let ref = Database.database().reference().child("users").child(uid)
            ref.updateChildValues(["name":name,"email":email], withCompletionBlock: { (error, ref) in
                if error != nil{
                    let errorNotification = UIAlertController(title: "Erro no Cadastro", message: String(describing: error!), preferredStyle: .alert)
                    let errorAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    errorNotification.addAction(errorAction)
                    
                    
                    OperationQueue.main.addOperation {
                        completion(errorNotification)
                    }
                    return
                }
            })
            
            OperationQueue.main.addOperation {
                
                completion(nil)
            }
        }
    }
    

    /// Funcao que realiza o LOGIN dado os parâmetros passados
    ///
    /// - Parameters:
    ///   - email: User(String)
    ///   - pass: User(String)
    func fbLogin(UserEmail email:String, UserPassword pass:String, completion: @escaping (UIAlertController?) -> Void){
        if passwordTxtFieldIsEmpty() || emailTxtFieldIsEmpty(){
            print("CAMPOS OBRIGATÓRIOS ESTÃO VAZIOS - LOGIN")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: pass) { (User, error) in
            if error != nil{
                let errorString = self.translatesGivenError(error: String(describing:error))
                
                let errorNotification = UIAlertController(title: "Login Inválido", message: errorString, preferredStyle: .alert)
                let errorAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                errorNotification.addAction(errorAction)
                
                OperationQueue.main.addOperation {
                    completion(errorNotification)
                }
                return
            }
            
            OperationQueue.main.addOperation {
                print("\n\nOPAA\n\n")
                completion(nil)
            }
        }
        
    }
    
    func translatesGivenError(error err:String) -> String {
        if err.contains("17026"){
            return fbErrors[17026]!
        }
        
        if err.contains("17008"){
            return fbErrors[17008]!
        }
        
        if err.contains("17007"){
            return fbErrors[17007]!
        }
        
        if err.contains("17011"){
            return fbErrors[17011]!
        }
        
        return fbErrors[17009]!
    }
    
    /// Funcao que simplesmente realiza o Logout da Sessão
    func fbLogout(){
        do{
            try Auth.auth().signOut()
            //performSegue(withIdentifier: "mainSegue", sender: nil)
        }catch{
            print("Deu erro no logout")
        }
    }
}
