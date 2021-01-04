//
//  MealItemQuantityCell.swift
//  Assignment1
//
//  Created by Prabhav Mehra on 24/12/20.
//  Copyright © 2020 Prabhav Mehra. All rights reserved.
//

import Foundation
import UIKit

class MealItemQuantityCell: UITableViewCell {

    var increaseButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "button-plus"), for: UIControl.State.normal)
        return button
    }()
    
    var decreaseButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "button-minus"), for: UIControl.State.normal)
        return button
    }()
    
    var quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        label.text = "1"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
       
        addSubview(quantityLabel)
        NSLayoutConstraint.activate([
            quantityLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            quantityLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            quantityLabel.widthAnchor.constraint(equalToConstant: 40),
            quantityLabel.heightAnchor.constraint(equalToConstant: 40)
            ])
        addSubview(increaseButton)
           NSLayoutConstraint.activate([
            increaseButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            increaseButton.leftAnchor.constraint(equalTo: quantityLabel.rightAnchor, constant: 0),
            increaseButton.widthAnchor.constraint(equalToConstant: 40),
            increaseButton.heightAnchor.constraint(equalToConstant: 40)
               ])
//        addSubview(increaseButton)
//        NSLayoutConstraint.activate([
//            increaseButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
//            increaseButton.leftAnchor.constraint(equalTo: quantityLabel.rightAnchor, constant: 0),
//            increaseButton.widthAnchor.constraint(equalToConstant: 40),
//            increaseButton.heightAnchor.constraint(equalToConstant: 40)
//            ])
//        addSubview(decreaseButton)
//        NSLayoutConstraint.activate([
//            decreaseButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
//            decreaseButton.rightAnchor.constraint(equalTo: quantityLabel.leftAnchor, constant: 0),
//            decreaseButton.widthAnchor.constraint(equalToConstant: 40),
//            decreaseButton.heightAnchor.constraint(equalToConstant: 40)
//            ])
        increaseButton.addTarget(self, action: #selector(increaseQuan(_:)), for: .touchUpInside)
        decreaseButton.addTarget(self, action: #selector(decreaseQuan(_:)), for: .touchUpInside)
    }
    
    @IBAction func increaseQuan(_ sender: Any) {
        print("here")
        let count = quantityLabel.text
        let countInt = Int(count!)
        let str2 = String(countInt!+1)
        quantityLabel.text =  str2
    }
    @IBAction func decreaseQuan(_ sender: Any) {
        print("here")
        let count = quantityLabel.text
        let countInt = Int(count!)
        let str2 = String(countInt!-1)
        quantityLabel.text =  str2
    }
}

