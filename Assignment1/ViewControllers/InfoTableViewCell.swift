//
//  InfoTableViewCell.swift
//  Assignment1
//
//  Created by Prabhav Mehra on 24/12/20.
//  Copyright © 2020 Prabhav Mehra. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    var hour: String? {
        didSet {
            hourLabel.text = hour
        }
    }
    var day: String? {
        didSet {
            dayLabel.text = day
        }
    }
    
    var dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.text = "Monday - Sunday"
        return label
    }()
    
    lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.text = "11:00AM - 8:00PM"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(dayLabel)
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dayLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 35),
            dayLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -35),
            dayLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        addSubview(hourLabel)
        NSLayoutConstraint.activate([
            hourLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 0),
            hourLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 35),
            hourLabel.widthAnchor.constraint(equalToConstant: 200),
            hourLabel.heightAnchor.constraint(equalToConstant: 60)
            ])
    }
}

