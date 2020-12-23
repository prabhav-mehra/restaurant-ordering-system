//
//  InfoCollectionViewCell.swift
//  Assignment1
//
//  Created by Prabhav Mehra on 24/12/20.
//  Copyright © 2020 Prabhav Mehra. All rights reserved.
//

import UIKit

class InfoCollectionViewCell: UICollectionViewCell {
    
    var infoButtonCallback: (()->())?
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Location and hours"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var infoButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("View Info", for: UIControl.State.normal)
        button.showsTouchWhenHighlighted = true
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.setTitleColor(UIColor.gray, for: UIControl.State.highlighted)
        button.addTarget(self, action: #selector(infoButtonTapped), for: UIControl.Event.touchUpInside)
        return button
        }()
    
    let infoButtonArrow: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "forward-black").withRenderingMode(.alwaysOriginal))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var topSeperator: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .lightGray
        return line
    }()
    
    @objc func infoButtonTapped() {
        infoButtonCallback?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
        backgroundColor = .white
        addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 25),
            infoLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            infoLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -100),
            infoLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        addSubview(infoButton)
        NSLayoutConstraint.activate([
            infoButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 25),
            infoButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            infoButton.widthAnchor.constraint(equalToConstant: 80),
            infoButton.heightAnchor.constraint(equalToConstant: 20)
            ])
        addSubview(infoButtonArrow)
        NSLayoutConstraint.activate([
            infoButtonArrow.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 25),
            infoButtonArrow.leftAnchor.constraint(equalTo: infoButton.rightAnchor, constant: 0),
            infoButtonArrow.widthAnchor.constraint(equalToConstant: 10),
            infoButtonArrow.heightAnchor.constraint(equalToConstant: 10)
            ])
        addSubview(topSeperator)
        NSLayoutConstraint.activate([
            topSeperator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            topSeperator.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            topSeperator.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            topSeperator.heightAnchor.constraint(equalToConstant: 0.5)
            ])
    }
}
