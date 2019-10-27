//
//  WelcomeViewController.swift
//  my first app
//
//  Created by Adam Essam on 7/26/19.
//  Copyright © 2019 Adam Essam. All rights reserved.
//

import UIKit
import ProgressHUD


class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    
    //MARK: IBActions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        dismissKeyboard()
        if emailTextField.text != "" && passwordTextField.text != "" {
            loginUser()
            
        } else {
            ProgressHUD.showError("Email or Password are missing!")
        }
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        dismissKeyboard()
        if emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != "" {
            
            if passwordTextField.text == repeatPasswordTextField.text {
                registerUser()
            } else {
                ProgressHUD.showError("the password and the repeated are not match!")
            }
            
            
            
        } else {
            ProgressHUD.showError("All fields are required!")
        }
        
    }
    
    @IBAction func backgroundTab(_ sender: Any) {
        dismissKeyboard()
    }
    
    //MARK: HelperFunctions
    
    func loginUser() {

        ProgressHUD.show("Login..")
        // ! for unrapping because Ik eno el login asln mesh hysht8l 8er lma ykon mb3ot email w password
        FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!)
        { (error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                //localizedDescription to translate the error to a human language
                return
            }
            //if no errors we need to present the app
            self.goToApp()
            
        }



    }
    
    func registerUser() {
        
        performSegue(withIdentifier: "welcomeToFinishReg", sender: self) //self 34an el view dah ana asln wa2ef 3aleh men el awel
        cleanTextFields()
        dismissKeyboard()


    }
    
    // to dismiss our keyboard
    func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    // clear all field after submit an action on the btns
    func cleanTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
    }
    
    //MARK: GoToApp
    
    func goToApp() {
        
        ProgressHUD.dismiss()
        cleanTextFields()
        dismissKeyboard()
        
        //hena hnpost a notification that our user is logged in
        //FUser.currentId bt3ml pass ll id bta3 el user ely logged in
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID : FUser.currentId()])
        
        
        //b3ml instantiate l viewController el id bta3o mainApplication
        //perform segue
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        
        self.present(mainView, animated: true, completion: nil)
        
        
    }
    
    //MARK: Navigation
    // hena hykon feh Deligate 34an an2l el info ely homa el email w el pass men el page deh llpage bta3t el profile
    // el func esmha prepare from segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "welcomeToFinishReg" {
            
            //we create an instance of the view we want to transfer the data to
            let vc = segue.destination as! FinishRegistrationViewController
                vc.email = emailTextField.text!
                vc.password = passwordTextField.text!
        }
    }
    
    
    
}
