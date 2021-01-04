//
//  CartViewController.swift
//  Assignment1
//
//  Created by Prabhav Mehra on 02/01/21.
//  Copyright © 2021 Prabhav Mehra. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    private let unameTxtField:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .white
        txtField.placeholder = "Username"
        txtField.borderStyle = .roundedRect
        return txtField
    }()
    private let pwordTxtField:UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Username"
        txtField.borderStyle = .roundedRect
        return txtField
    }()
    let btnLogin:UIButton = {
        let btn = UIButton(type:.system)
        btn.backgroundColor = .blue
        btn.setTitle("Login", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private let loginContentView:UIView = {
      let view = UIView()
        view.backgroundColor = .gray
    view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.white.withAlphaComponent(1)
//        view.isOpaque = false
//            view.backgroundColor = .clear
//        view.addSubview(backButton)
//        NSLayoutConstraint.activate([
//            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -1),
//            backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
//            backButton.widthAnchor.constraint(equalToConstant: 30),
//            backButton.heightAnchor.constraint(equalToConstant: 30)
//            ])
       
        
   
        // Do any additional setup after loading the view.
    }
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    

    @objc func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
