//
//  ViewController.swift
//  Assignment1
//
//  Created by Prabhav Mehra on 24/07/20.
//  Copyright © 2020 Prabhav Mehra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()

    }
    
    func setUpElements() {
    
        Utilities.styleFilledButton(SignUpButton)
        Utilities.styleHollowButton(LoginButton)
    }

}

