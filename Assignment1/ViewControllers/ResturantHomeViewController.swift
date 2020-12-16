//
//  ResturantHomeViewController.swift
//  Assignment1
//
//  Created by Prabhav Mehra on 12/12/20.
//  Copyright © 2020 Prabhav Mehra. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class ResturantHomeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {
  
    
   
    let db = Firestore.firestore()
   
    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var itemNameText: UITextField!
   
    @IBOutlet weak var descText: UITextView!
   
    @IBOutlet weak var priceText: UITextField!
    
    @IBOutlet weak var itemTableView: UITableView!
    
    @IBOutlet weak var addImageButton: UIButton!
   
    @IBOutlet weak var itemCell: UITableViewCell!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var addItem: UIButton!
    
    @IBOutlet weak var multiLineLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var storedItems = [Items]()
    
    var toDoItems = [Items]()
    var addedItems = [Items]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
    
        textView!.layer.borderWidth = 1
        textView!.layer.borderColor = UIColor.black.cgColor
        
        self.itemTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
       
        // This view controller itself will provide the delegate methods and row data for the table view.
        itemTableView.delegate = self
        itemTableView.dataSource = self
        itemTableView.estimatedRowHeight = 44.0
        itemTableView.rowHeight = UITableView.automaticDimension

        // Do any additional setup after loading the view.
    }
    
    
    private func setData() {
        let data: [String: Any] = [:]
        // [START set_data]
        db.collection("cities").document("new-city-id").setData(data)
        // [END set_data]
    }
    

    @IBAction func saveToDatabase(_ sender: Any) {
    
        
        
        for index in 0..<toDoItems.count {
            let element = toDoItems[index]


            guard let city = Items(name: element.name, desc: element.desc, price: element.price)
            else {
                fatalError("Unable to instantiate Item")
            }
            if !storedItems.contains(where: { name in name.name == city.name }) && !storedItems.contains(where: { desc in desc.desc == city.desc } ) {
                print("doesnt")
                print(city.name)


                db.collection("items").addDocument(data: ["name":city.name,"desc":city.desc,"price":city.price]){ (error) in

                        if error != nil {
                            print("Error saving user data!")
                        }
                    }
                storedItems.append(city)
            }
            else{
                let alert = UIAlertController(title: "Alert", message: "No New Items added", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }

        }
        
  
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        itemTableView.reloadData()
    }
    
    

    
    
    
    @IBAction func addToCell(_ sender: Any) {
        print(addedItems.count)
        print(toDoItems.count)
        if(!( itemNameText.text!.isEmpty ||  descText.text!.isEmpty || priceText.text!.isEmpty )){
            guard let item = Items(name: itemNameText.text!, desc: descText.text!,price:priceText.text!)
                else {
                    fatalError("Unable to instantiate Item")
            }
            
            if !toDoItems.contains(where: { name in name.name == item.name }) && !toDoItems.contains(where: { desc in desc.desc == item.desc } ) {
                print(" doesnt exsists")
                toDoItems.append(item)
          
            }
            
            itemTableView.reloadData()
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "Item already exsists", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
     
        

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.itemTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
     
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = .byWordWrapping
        let item = toDoItems[indexPath.row]
        addedItems.append(item)
        cell.textLabel?.text = item.name + "\n" + item.desc + "\n" + item.price 

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            self.toDoItems.remove(at: indexPath.row)
            self.itemTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    @IBAction func addImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image,animated: true){
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imageView.image = image
        }
        else{
            
        }
        self.dismiss(animated: true, completion: nil)
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
