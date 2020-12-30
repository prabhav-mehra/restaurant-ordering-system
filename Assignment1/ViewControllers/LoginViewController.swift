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
    let db = Firestore.firestore()
    var name =  " "
    let user = Auth.auth().currentUser
    

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
               
              
                self.getItems { ([Items]) in
                    print([Items].self)
                }
                self.getName{ (name) in
                    if(name == "resturant"){
                        print(name)
                       
                        self.view.window?.rootViewController = resturantViewController
                        self.view.window?.makeKeyAndVisible()
                    }
                    else{
                        self.view.window?.rootViewController = homeViewController
                        self.view.window?.makeKeyAndVisible()
                    }
                   
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
                        let uid = myData["uid"]
                        if user!.uid == (uid as! String) {
                            let option = myData["option"] as? String ?? "No Name Found"
                            Completion(option)
                            self.name = option
                        }
                        
                    }
                }
            }
        }
    
    func getItems(Completion: @escaping(([Items]) -> ())) {
        var toDoItems = [Items]()
        db.collection("items").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let myData =  document.data()
                    let name = myData["name"]
                    let desc = myData["desc"]
                    let price = myData["price"]
                    let uid = myData["uid"]

                    let category = myData["category"]
                    if((name as! String) == self.name) {
                        guard let item =  Items(name: name as! String, desc: desc as! String, price: price as! String, category: category as! String)
                            else {
                                fatalError("Unable to instantiate Item")
                        }
                        print("here")
                        toDoItems.append(item)

//                        self.loadedItems.append(item)
                    }
                }
            }

        }
        Completion(toDoItems)
        print(toDoItems)
   
    }
    
    
    

            

    
}
