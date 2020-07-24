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

class SignUpViewController: UIViewController {

    @IBOutlet weak var FirstNameText: UITextField!
   
    @IBOutlet weak var LastNameText: UITextField!
   
    @IBOutlet weak var EmailText: UITextField!
   
    @IBOutlet weak var PasswordText: UITextField!
   
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        ErrorLabel.alpha = 0
        
        Utilities.styleTextField(FirstNameText)
        Utilities.styleTextField(LastNameText)
        Utilities.styleTextField(EmailText)
        Utilities.styleTextField(PasswordText)
        Utilities.styleFilledButton(SignUpButton)
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
            
            Auth.auth().createUser(withEmail: email, password: pass) { (result, err) in
                
                
                if err != nil {
                    
                    self.showError("Error Creating User!")
                }
                
                else {
                    
                    let db = Firestore.firestore()

                    db.collection("users").addDocument(data: ["firstname":firstName,"lastname":lastName,"uid":result!.user.uid]) { (error) in

                        if error != nil {
                            self.showError("Error saving user data!")
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

        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController

        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()

    }
    
}
