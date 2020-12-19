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

class HomeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
   
    var floatingButton: UIButton?
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    private enum ConstantsButton {
        static let trailingValue: CGFloat = 15.0
        static let leadingValue: CGFloat = 15.0
        static let buttonHeight: CGFloat = 75.0
        static let buttonWidth: CGFloat = 75.0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createFloatingButton()
        
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
        

        // Do any additional setup after loading the view.
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
    
    @IBAction private func doThisWhenButtonIsTapped(_ sender: Any) {

        print("Tapped")
        
    }
    
    func failed() {
            let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            captureSession = nil
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

            if (captureSession?.isRunning == true) {
                captureSession.stopRunning()
            }
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            captureSession.stopRunning()

            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                found(code: stringValue)
            }

            dismiss(animated: true)
        }

        func found(code: String) {
            print(code)
        }

        override var prefersStatusBarHidden: Bool {
            return true
        }

        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .portrait
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
