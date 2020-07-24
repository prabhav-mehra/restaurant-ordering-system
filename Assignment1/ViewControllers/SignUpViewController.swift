//
//  SignUpViewController.swift
//  Assignment1
//
//  Created by Prabhav Mehra on 24/07/20.
//  Copyright © 2020 Prabhav Mehra. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var FirstNameText: UITextField!
   
    @IBOutlet weak var LastNameText: UITextField!
   
    @IBOutlet weak var EmailText: UITextField!
   
    @IBOutlet weak var PasswordText: UITextField!
   
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func SignUpTapped(_ sender: Any) {
    }
    
}
