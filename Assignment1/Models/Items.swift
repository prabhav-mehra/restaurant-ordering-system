//
//  Items.swift
//  Assignment1
//
//  Created by Prabhav Mehra on 16/12/20.
//  Copyright © 2020 Prabhav Mehra. All rights reserved.
//

import UIKit



class Items {
    // Mark properties
    var name: String
    var desc: String
    var price: String
    var category: String
   
    //MARK Initialization
    init?(name: String, desc: String, price: String,category: String){
        
        
        if name.isEmpty {
            return nil
        }
        
        //Initialize stored properties
        self.name = name
        self.desc = desc
        self.price = price
        self.category = category
      
    }
    
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let desc = aDecoder.decodeObject(forKey: "desc") as! String
        let price = aDecoder.decodeObject(forKey: "price") as! String
        let category = aDecoder.decodeObject(forKey: "category") as! String
       
        self.init( name: name, desc: desc, price: price,category:category)!
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(name, forKey: "name")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(price, forKey: "category")
      
    }
    
    
}
