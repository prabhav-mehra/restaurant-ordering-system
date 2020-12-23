//
//  InfoViewController.swift
//  Assignment1
//
//  Created by Prabhav Mehra on 24/12/20.
//  Copyright © 2020 Prabhav Mehra. All rights reserved.
//

import UIKit
//import GoogleMaps
//import GooglePlaces

class InfoViewController: UIViewController {
    
   
    
  
    var zoomLevel: Float = 15.0
    var mapView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        setupViews()
//        locationManager.startUpdatingLocation()
        setupGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupGesture(){
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture))
        edgePan.edges = .left
        self.view.addGestureRecognizer(edgePan)
    }
    @objc func handleGesture(){
        dismiss(animated: true, completion: nil)
    }
   
    func setupViews() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            ])
        
        
    }
}

extension InfoViewController:  UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell") as! InfoTableViewCell
        cell.day = "Sundauy"
        cell.hour = "10:00AM - 5:00PM    Breakfast 10:00AM - 5:00PM    Lunch   10:00AM - 5:00PM    Dinner"
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "InfoTableViewHeaderCell") as! InfoTableViewHeader
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//extension InfoViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location: CLLocation = locations.last!
//        print("Location: \(location)")
//
//        let _ = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
//                                              longitude: location.coordinate.longitude,
//                                              zoom: zoomLevel)
//
//    }
//
//    // Handle authorization for the location manager.
//
//}
