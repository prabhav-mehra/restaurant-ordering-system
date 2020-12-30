//
//  DetailHeaderCollectionViewCell.swift
//  Assignment1
//
//  Created by Prabhav Mehra on 24/12/20.
//  Copyright © 2020 Prabhav Mehra. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage

class DetailHeaderCollectionViewCell: UICollectionViewCell, CoverImageDelegate {
    
    var coverImageHeightConstraint: NSLayoutConstraint?
    var coverImageTopAnchorConstraint: NSLayoutConstraint?
   
  
    
    private var imageURL = URL(string: "")
    var image:UIImage? = nil
    func loadImageFromFirebase(image: UIImageView) {
       
             let storageRef = Storage.storage().reference(withPath: "gs://foodordersystem-2991f.appspot.com").child("RewK84UNYad5UkzF65NRVD927Yd2").child("test.png.png")
              storageRef.downloadURL { (url, error) in
                     if error != nil {
                         print((error?.localizedDescription)!)
                         return
              }
                    self.imageURL = url!
              
                Storage.storage().reference(withPath: "gs://foodordersystem-2991f.appspot.com").child("RewK84UNYad5UkzF65NRVD927Yd2").child("test.png.png").getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                      // Uh-oh, an error occurred!
                    } else {
                      // Data for "images/island.jpg" is returned
                        image.image = UIImage(data: data!)!
                      
                        
                    }
                }
             
        }
       
    }
    
    let coverImageView: UIImageView = {
//        let iv = UIImageView(image: #imageLiteral(resourceName: "tennesse_taco_co_2") )
        let iv = UIImageView(image: nil )
   
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
       
        addSubview(coverImageView)
        coverImageHeightConstraint = coverImageView.heightAnchor.constraint(equalToConstant: frame.width*0.79625)
        coverImageTopAnchorConstraint = coverImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        loadImageFromFirebase(image: coverImageView)
        NSLayoutConstraint.activate([
            
            coverImageTopAnchorConstraint!,
            coverImageView.leftAnchor.constraint(equalTo: leftAnchor),
            coverImageView.rightAnchor.constraint(equalTo: rightAnchor),
            coverImageHeightConstraint!
            ])
      
//        print(self.image)
//        coverImageView.image = self.image
    }
    func updateImageHeight(height: CGFloat) {
        coverImageHeightConstraint?.constant = height
    }
    func updateImageTopAnchorConstraint(constant: CGFloat) {
        coverImageTopAnchorConstraint?.constant = constant
    }
}

