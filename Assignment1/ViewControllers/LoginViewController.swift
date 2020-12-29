//
//  LoginViewController.swift
//  Assignment1
//
//  Created by Prabhav Mehra on 24/07/20.
//  Copyright © 2020 Prabhav Mehra. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    var ref: DatabaseReference!
    var db: Firestore!
    

    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        ErrorLabel.alpha = 0
        
        Utilities.styleTextField(EmailText)
        Utilities.styleTextField(PasswordText)
        Utilities.styleFilledButton(LoginButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @available(iOS 13.0, *)
    @IBAction func LoginButtonTapped(_ sender: Any) {
        let email = EmailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = PasswordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password){
            (result,error) in
            
            if error != nil {
                self.ErrorLabel.text = error!.localizedDescription
                self.ErrorLabel.alpha = 1
            }
            else{
                
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
                 let resturantViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.resturantViewController) as? ResturantHomeViewController
                
//                self.view.window?.rootViewController = homeViewController
//                self.view.window?.makeKeyAndVisible()
                self.getName{ (name) in
                    if(name == "resturant"){
                        self.view.window?.rootViewController = resturantViewController
                        self.view.window?.makeKeyAndVisible()
                    }
                    else{
                        self.view.window?.rootViewController = homeViewController
                        self.view.window?.makeKeyAndVisible()
                    }
                    print(name)
                }

            }
        }
       
    }
    
  
        
      
        
    
        func getName(Completion: @escaping((String) -> ())) {
            let user = Auth.auth().currentUser
            
            let collectionRefernce:CollectionReference!
            let db = Firestore.firestore()
            collectionRefernce = db.collection("users")
            collectionRefernce.getDocuments { (querySnapshot, error) in
                if error != nil {
                    print("Error is \(error!.localizedDescription)")
                } else {
                    guard let snapshot = querySnapshot else { return }
                    for document in snapshot.documents {
                        let myData = document.data()
                        let uid = myData["uid"] as? String ?? "No Name Found"
                        if user!.uid == uid {
                            let option = myData["option"] as? String ?? "No Name Found"
                            Completion(option)
                        }
                        
                    }
                }
            }
        }
            

    
}
