//
//  SignUpViewController.swift
//  Assignment1
//
//  Created by Prabhav Mehra on 24/07/20.
//  Copyright © 2020 Prabhav Mehra. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import DLRadioButton

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var resturantContactText: UITextField!
    
    @IBOutlet weak var resturantAddressText: UITextField!
    
    @IBOutlet weak var resturantNameText: UITextField!
    
    @IBOutlet weak var FirstNameText: UITextField!
   
    @IBOutlet weak var LastNameText: UITextField!
   
    @IBOutlet weak var EmailText: UITextField!
   
    @IBOutlet weak var PasswordText: UITextField!
   
    @IBOutlet weak var resturantRadio: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet weak var userRadio: UIButton!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    var radioResult = " "
    override func viewDidLoad() {
        super.viewDidLoad()
        resturantRadio.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .leftToRight ? .forceLeftToRight : .forceRightToLeft
        userRadio.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .leftToRight ? .forceLeftToRight : .forceRightToLeft
        
//        resturantRadio.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
//        userRadio.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
       
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func optionButtonSlelected(_ sender: UIButton) {
        
        if sender.tag == 1{
            resturantRadio.isSelected = true
            userRadio.isSelected = false
            radioResult = "resturant"
        
        }
        
        else if sender.tag == 2{
           
            userRadio.isSelected = true
            resturantRadio.isSelected = false
            radioResult = "user"
           
           
            
        }
        else{
               radioResult = "none"
               ErrorLabel.text = "Please select one option"
        }
        
       
        
        
    }
    
    
    func setUpElements() {
        ErrorLabel.alpha = 0
        
        Utilities.styleTextField(FirstNameText)
        Utilities.styleTextField(LastNameText)
        Utilities.styleTextField(EmailText)
        Utilities.styleTextField(PasswordText)
        Utilities.styleFilledButton(SignUpButton)
        Utilities.styleTextField(resturantNameText)
        Utilities.styleTextField(resturantContactText)
        Utilities.styleTextField(resturantAddressText)
        resturantNameText.isHidden = true
        resturantContactText.isHidden = true
        resturantAddressText.isHidden = true
    }
    
    func validateFields() -> String? {
        if FirstNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
         LastNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
         EmailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
        }
        let cleanedPassword = PasswordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false{
            return "Please Make sure your password contains at least 8 characters, contains a special character and atleast one number."
        }
        
        if  resturantRadio.isSelected == true {
            if resturantNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                resturantContactText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                resturantAddressText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                
                return "Please fill in all fields"
            }
        }
       
        
        return nil
    }
    
    @IBAction func SignUpTapped(_ sender: Any) {
        //Validate Fields and Create user.
        
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }
        
        else {
            let firstName = FirstNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = LastNameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = EmailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pass = PasswordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let resturantName = resturantNameText.text!
            let resturantAddress = resturantAddressText.text!
            let resturantContact = resturantContactText.text!
        
            Auth.auth().createUser(withEmail: email, password: pass) { [self] (result, err) in
                
                
                if err != nil {
                    print(err!)
                    
                    self.showError("Error Creating User!")
                }
                
                else {
                    
                    let db = Firestore.firestore()
                    if self.userRadio.isSelected == true{
                        
                        db.collection("users").addDocument(data: ["firstname":firstName,"lastname":lastName,"uid":result!.user.uid,"email":email,"option":self.radioResult]) { (error) in

                            if error != nil {
                                self.showError("Error saving user data!")
                            }

                        }
                    }
                    else {
                        db.collection("users").addDocument(data: ["firstname":firstName,"lastname":lastName,"uid":result!.user.uid,"email":email,"option":self.radioResult,"image":"","resturantName":resturantName,"resturantContact":resturantContact,"resturantAddress":resturantAddress]) { (error) in

                            if error != nil {
                                self.showError("Error saving user data!")
                            }

                        }
                        
                    }

                    self.transitionToHome()
                }
            }
            
        }
    }
    
    func showError (_ message:String){
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
    }
    
    func transitionToHome() {

        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.ViewController) as? ViewController
        
//        let resturantViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.resturantViewController) as? ResturantHomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
//        if(self.radioResult == "resturant"){
//            view.window?.rootViewController = resturantViewController
//            view.window?.makeKeyAndVisible()
//        }
//        
//        else{
//            view.window?.rootViewController = homeViewController
//            view.window?.makeKeyAndVisible()
//        }

     

    }
    
    func transitionToLogin() {
        
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func resturantRadioTapped(_ sender: Any) {
   
        resturantNameText.isHidden = false
        resturantContactText.isHidden = false
        resturantAddressText.isHidden = false
    }
    
    
    @IBAction func customerRadioTapped(_ sender: Any) {
        resturantNameText.isHidden = true
        resturantContactText.isHidden = true
        resturantAddressText.isHidden = true
        
    }
    
}
