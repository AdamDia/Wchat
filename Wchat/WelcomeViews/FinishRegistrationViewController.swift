//
//  FinishRegistrationViewController.swift
//  my first app
//
//  Created by Adam Essam on 7/28/19.
//  Copyright © 2019 Adam Essam. All rights reserved.
//

import UIKit
import ProgressHUD
class FinishRegistrationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var suernameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    //m7tagen hena n7ot kam variable 34an nn2l el email w el password men awel page ltany page + el info ely fel profile yb2a keda el Reg tmam
    
    var email: String!
    var password: String! //here not an optional lazem y7ot pass tb3n nfs el kalam fel email
    var avatarImage: UIImage? // ? here optional mmken y7ot sora aw l2a
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(email! , password! )
    }
    
    //MARK: IBActions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismissKeyboard()
        ProgressHUD.show("Registering...!")
        if nameTextField.text != "" && suernameTextField.text != "" && countryTextField.text != "" && cityTextField.text != "" && phoneTextField.text != "" {
            
            FUser.registerUserWith(email: email, password: password, firstName: nameTextField.text!, lastName: suernameTextField.text!)
            { (error) in
                if error != nil {
                  ProgressHUD.dismiss()
                  ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                self.registerUser()
                
            }
            
            
            
        } else {
            
            ProgressHUD.showError("All field are required!")
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        //here we want to dismiss and go back to welcome view
        cleanTextFields()
        dismissKeyboard()
         self.dismiss(animated: true, completion: nil)
        
    }
    
    
    //MARK:helpers
    
    func registerUser() {
        
        let fullName = nameTextField.text! + " " + suernameTextField.text!
        // create a temp dictionary which will contain all the info we want to add to our user
        //e7na fo2 3mlna fuser feh email w pass w fname w lname fa 3yzen n3mlo update bel field ely mwgoda fel Reg kman
        //Dictionary lazem key w value so the key here is kfirstname and the value will be the nameTextField
        var tempDictionary : Dictionary = [kFIRSTNAME : nameTextField.text!, kLASTNAME : suernameTextField.text!, kFULLNAME : fullName, kCOUNTRY : countryTextField.text!, kCITY : cityTextField.text!, kPHONE : phoneTextField.text!] as [String : Any]
        
        if avatarImage == nil {
            // lo el user m5tr4 swra h3mlo sora mkowna men awel 7rf men el firstname + awel 7rf men el lastname
            imageFromInitials(firstName: nameTextField.text!, lastName: suernameTextField.text!) { (avatarInitials) in
                //we are gonna use this image to create data file 34an n2dr n3mlha save 3ala firebase store 34an e7na mn2dr4 n3ml save UIimages mynf34 8er data objects
                //el func deh bt7wel el UiImages into data object bta5od quality ben 0.1 up to 1
                let avatarIMG = avatarInitials.jpegData(compressionQuality: 0.7)
                //w b3den hena bn7wlo L string 34an n2dr n3mlo save 3ala el firestore
                let avatar = avatarIMG!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                
                tempDictionary[kAVATAR] = avatar
                
                //finishRegistration
                //self 34an e7na inside the call back block
                self.finishRegistraion(withValues: tempDictionary)
            }
            
        } else {
            let avatarData = avatarImage?.jpegData(compressionQuality: 0.7)
            let avatar = avatarData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            tempDictionary[kAVATAR] = avatar
            
            //finishRegistration
            self.finishRegistraion(withValues: tempDictionary)
        }
    }
    
    func finishRegistraion(withValues: [String : Any])  {
        updateCurrentUserInFirestore(withValues: withValues) { (error) in
            if error != nil {
                //cuz this is running in the background thread 34an n2a accsess el error est5dmna dispatch 34an ngebo 3ala el main thread
                DispatchQueue.main.async {
                    ProgressHUD.showError(error!.localizedDescription)
                }
                return
            }
            ProgressHUD.dismiss()
            //goToApp
            self.goToApp()
        }
    }
    
    func goToApp() {
        cleanTextFields()
        dismissKeyboard()
        
        //hena hnpost a notification that our user is logged in
        //FUser.currentId bt3ml pass ll id bta3 el user ely logged in
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID : FUser.currentId()])
        
        //hena 3mlna down casting 34an dah viewController hyro7 l tabBar Controller
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        
        self.present(mainView, animated: true, completion: nil)
    }
    // to dismiss our keyboard
    func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    // clear all field after submit an action on the btns
    func cleanTextFields() {
        nameTextField.text = ""
        suernameTextField.text = ""
        countryTextField.text = ""
        cityTextField.text = ""
        phoneTextField.text = ""
    }
    
}
