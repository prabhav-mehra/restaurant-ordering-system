//
//  HomeViewController.swift
//  Assignment1
//
//  Created by Prabhav Mehra on 24/07/20.
//  Copyright © 2020 Prabhav Mehra. All rights reserved.
//

import AVFoundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage

class HomeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
   
    var floatingButton: UIButton?
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var itemArray = [String]()
    var qrCode = String()
    let db = Firestore.firestore()
    var menuItems = [Meal]()
    var codeFound = Bool()
    
    private enum ConstantsButton {
        static let trailingValue: CGFloat = 15.0
        static let leadingValue: CGFloat = 15.0
        static let buttonHeight: CGFloat = 75.0
        static let buttonWidth: CGFloat = 75.0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: Selector(("OnAppBecameActive")), name: UIApplication.didBecomeActiveNotification, object: nil)

//           refreshView()
        
        
        
        createFloatingButton()
        
        captureSession = AVCaptureSession()
        
      

        // Do any additional setup after loading the view.
    }
    func refreshView()
    {
        db.collection("items").getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let myData =  document.data()
                            let name = myData["name"]
                            let desc = myData["desc"]
                            let price = myData["price"]
                            let uid = myData["uid"]
                            let category = myData["category"]
                            if((uid as! String) == self.qrCode) {
                                if !self.itemArray.contains(category as! String){
                                    guard let item =  Items(name: name as! String, desc: desc as! String, price: price as! String, category: category as! String)
                                        else {
                                            fatalError("Unable to instantiate Item")
                                    }
                                   print(item.category)
                                   itemArray.append(item.category)
                                }
    
                            }
                        }
                    }
                }
        
                    db.collection("items").getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                let myData =  document.data()
                                let name = myData["name"]
                                let desc = myData["desc"]
                                let price = myData["price"]
                                let uid = myData["uid"]
                                let category = myData["category"]
                                if((uid as! String) == self.qrCode) {
                                    let priceFloat = (price as! NSString).floatValue
        
                                        let item =  Meal(name: name as! String, description: desc as! String, type: category as! String, price: priceFloat)
        
                                    self.menuItems.append(item)
        
        
                                }
                            }
                        }
                    }

    }
    
    private func createFloatingButton() {
        floatingButton = UIButton(type: .custom)
        floatingButton?.backgroundColor = .clear
        floatingButton?.translatesAutoresizingMaskIntoConstraints = false
        constrainFloatingButtonToWindow()
        floatingButton?.setImage(UIImage(named: "floatButton"), for: .normal)
        floatingButton?.addTarget(self, action: #selector(doThisWhenButtonIsTapped(_:)), for: .touchUpInside)
    }
    
    private func constrainFloatingButtonToWindow() {
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.shared.keyWindow,
                let floatingButton = self.floatingButton else { return }
            keyWindow.addSubview(floatingButton)
            keyWindow.trailingAnchor.constraint(equalTo: floatingButton.trailingAnchor,
                                                constant: ConstantsButton.trailingValue).isActive = true
            keyWindow.bottomAnchor.constraint(equalTo: floatingButton.bottomAnchor,
                                              constant: ConstantsButton.leadingValue).isActive = true
            floatingButton.widthAnchor.constraint(equalToConstant:
                ConstantsButton.buttonWidth).isActive = true
            floatingButton.heightAnchor.constraint(equalToConstant:
                ConstantsButton.buttonHeight).isActive = true
        }
    }

    
    func failed() {
            let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            captureSession = nil
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            captureSession.stopRunning()

            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.codeFound = true
                found(code: stringValue)
                
            
            }
           

//            dismiss(animated: true)

        }

        func found(code: String) {
            print(code)
            qrCode = code
            if self.codeFound == true{
                let alert = UIAlertController(title: title, message: "Foud", preferredStyle: UIAlertController.Style.alert)
                   alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    self.refreshView()
                    self.show(DetailViewController(mealSections: self.itemArray, meals: self.menuItems), sender: self)
                   }))
                   alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                   self.present(alert, animated: true, completion: nil)
            }
            
            refreshView()

//            print(self.itemArray)
            

           
//            self.show(DetailViewController(mealSections: itemArray, meals: self.menuItems), sender: self)
            self.captureSession?.stopRunning()
//            previewLayer?.isHidden = true
            previewLayer.removeFromSuperlayer()
//            self.dismiss(animated: false, completion: nil)
            print(qrCode)
            
           
            
            
        }

//
    func myArrayFunc(inputArray:Array<String>) -> Array<String> {
               
               
        return self.itemArray
    }

        override var prefersStatusBarHidden: Bool {
            return true
        }

        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
        }
    
    @IBAction func doThisWhenButtonIsTapped(_ sender: Any) {
       view.backgroundColor = UIColor.black
       captureSession = AVCaptureSession()
    
       guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
       let videoInput: AVCaptureDeviceInput

       do {
           videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
       } catch {
           return
       }

       if (captureSession.canAddInput(videoInput)) {
           captureSession.addInput(videoInput)
       } else {
           failed()
           return
       }

       let metadataOutput = AVCaptureMetadataOutput()

       if (captureSession.canAddOutput(metadataOutput)) {
           captureSession.addOutput(metadataOutput)

           metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
           metadataOutput.metadataObjectTypes = [.qr]
       } else {
           failed()
           return
       }

       previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
       previewLayer.frame = view.layer.bounds
       previewLayer.videoGravity = .resizeAspectFill
       view.layer.addSublayer(previewLayer)

       captureSession.startRunning()
   }
//    private var imageURL = URL(string: "")
//    
//    func loadImageFromFirebase(filePath: String, name: String) {
//        let user = Auth.auth().currentUser
//             let storageRef = Storage.storage().reference(withPath: filePath).child("\(user!.uid)").child("\(name).png")
//              storageRef.downloadURL { (url, error) in
//                     if error != nil {
//                         print((error?.localizedDescription)!)
//                         return
//              }
//                    self.imageURL = url!
//                print(self.imageURL!)
//                Storage.storage().reference(withPath: filePath).child("\(user!.uid)").child("\(name).png").getData(maxSize: 1 * 1024 * 1024) { data, error in
//                    if let error = error {
//                      // Uh-oh, an error occurred!
//                    } else {
//                      // Data for "images/island.jpg" is returned
//                        let image = UIImage(data: data!)
//                    }
//                }
//             
//        }
//    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
