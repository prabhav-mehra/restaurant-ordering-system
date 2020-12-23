//
//  File.swift
//  Assignment1
//
//  Created by Prabhav Mehra on 24/12/20.
//  Copyright © 2020 Prabhav Mehra. All rights reserved.
//

import UIKit

class SectionTitleIndexCollectionView: UICollectionView {
    
    var sectionTitles: [String] = {
        let mls = Meal.loadMealSections()
        return mls
    }()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SectionTitleIndexCollectionViewCell: UICollectionViewCell {
    
    var sectionTitle: String? {
        didSet {
            titleLabel.text = sectionTitle ?? "N/A"
        }
    }
    
    var titleLabelWidthConstraint: NSLayoutConstraint?
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(titleLabel)
        titleLabelWidthConstraint = titleLabel.widthAnchor.constraint(equalTo: widthAnchor)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor),
            titleLabelWidthConstraint!
            ])
    }
}

