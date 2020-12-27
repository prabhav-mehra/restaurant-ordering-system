//
//  DetailViewController.swift
//  UberEATS
//
//  Created by Sean Zhang on 7/26/18.
//  Copyright © 2018 Sean Zhang. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class DetailViewController: UIViewController {
    
    var interactor:Interactor? = nil
    
    var infoViewController: InfoViewController = {
        let vc = InfoViewController()
        return vc
    }()
    
    
    
    lazy var sectionTitleIndexCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = SectionTitleIndexCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionTitleIndexEmptyCell")
        cv.register(SectionTitleIndexCollectionViewCell.self, forCellWithReuseIdentifier: "SectionTitleIndexCell")
        cv.isHidden = true
        return cv
    }()
    
    var height: CGFloat?
    var delegate: CoverImageDelegate?
    var delegate2: HeaderViewDelegate?
    var yContraint: NSLayoutConstraint?
    var lContraint: NSLayoutConstraint?
    var rContraint: NSLayoutConstraint?
    var meals = Meal.loadDemoMeals()
//    var mealSections: [String] = Meal.loadMealSections()
    var mealSections = [String]()
  
    let db = Firestore.firestore()
    let testvC = HomeViewController()
    
    init(mealSections: [String]) {
        self.mealSections = mealSections
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(#imageLiteral(resourceName: "back-white").withRenderingMode(.alwaysOriginal), for: UIControl.State.normal)
        button.setImage(#imageLiteral(resourceName: "back-black").withRenderingMode(.alwaysOriginal), for: UIControl.State.highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissViewController), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var headerView: HeaderView = {
        let view = HeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCell")
        cv.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: "InfoCell")
        cv.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "MenuCell")
        cv.register(DetailHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DetailHeader")
        cv.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        cv.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmptyCell")
        cv.contentInsetAdjustmentBehavior = .never
        cv.backgroundColor = .white
        return cv
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let fav = [String]()
//        mealSections = testvC.myArrayFunc(inputArray: fav)
//        print(mealSections)
        
//        db.collection("items").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    let myData =  document.data()
//                    let name = myData["name"]
//                    let desc = myData["desc"]
//                    let price = myData["price"]
//                    let uid = myData["uid"]
//                    let category = myData["category"]
//                    if((uid as! String) == uid as! String) {
//                        guard let item =  Items(name: name as! String, desc: desc as! String, price: price as! String, category: category as! String)
//                            else {
//                                fatalError("Unable to instantiate Item")
//                        }
//                        self.mealSections.append(item.category)
//
//                    }
//                }
//            }
//        }
        print(self.mealSections)
      
        setupViews()
        setupGesture()
       
    }
    
    func setupGesture(){
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        edgePan.edges = .left
        self.view.addGestureRecognizer(edgePan)
    }
    
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        self.delegate2 = headerView
        view.addSubview(headerView)
        yContraint = headerView.centerYAnchor.constraint(equalTo: collectionView.topAnchor, constant: 298.6)
        lContraint = headerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30)
        rContraint = headerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        NSLayoutConstraint.activate([
            yContraint!,
            lContraint!,
            rContraint!,
            headerView.heightAnchor.constraint(equalToConstant: 130)
            ])
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -1),
            backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30)
            ])
        view.addSubview(sectionTitleIndexCollectionView)
        NSLayoutConstraint.activate([
            sectionTitleIndexCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            sectionTitleIndexCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            sectionTitleIndexCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            sectionTitleIndexCollectionView.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (collectionView == self.sectionTitleIndexCollectionView) {
            return 1
        } else {
            return (self.mealSections.count + 1) // added one section for MenuCell and InfoCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.sectionTitleIndexCollectionView) {
            return self.mealSections.count
        } else {
            if (section == 0) {
                return 2
            } else {
                let rows = Meal.loadMealsForSection(sectionName: self.mealSections[section-1], meals: meals)
                return rows.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == self.sectionTitleIndexCollectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionTitleIndexCell", for: indexPath) as! SectionTitleIndexCollectionViewCell
            cell.sectionTitle = self.mealSections[indexPath.row]
            return cell
        } else {
            if (indexPath.section == 0) && (indexPath.row == 0) {
                let infoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCell", for: indexPath) as! InfoCollectionViewCell
                    infoCell.infoButtonCallback = {() -> () in
                        self.present(self.infoViewController, animated: true, completion: nil)
                }
                return infoCell
            } else if (indexPath.section == 0) && (indexPath.row == 1) {
                let menuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCollectionViewCell
                return menuCell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as! DetailCollectionViewCell
                let rows = Meal.loadMealsForSection(sectionName: self.mealSections[(indexPath.section-1)], meals: meals)
                cell.meal = rows[indexPath.row]
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == self.sectionTitleIndexCollectionView) {
            let text = self.mealSections[indexPath.row]
            let length = text.count
            return CGSize(width: (length*10), height: 40)
        } else {
            if (indexPath.section == 0) && (indexPath.row < 2) {
                return indexPath.row == 0 ?  CGSize(width: view.frame.width, height: 120) : CGSize(width: view.frame.width, height: 50)
            }
            return CGSize(width: view.frame.width, height: 90)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == self.sectionTitleIndexCollectionView) {
            // note: do nothing
        } else {
            updateHeaderImage(scrollView)
            updateHeaderView(scrollView)
            updateHeaderViewLabel(scrollView)
        }
    }
    
    fileprivate func updateHeaderImage(_ scrollView: UIScrollView) {
        let pos = scrollView.contentOffset.y
        print(pos)
        if (pos < 0){
            delegate?.updateImageHeight(height: (298.6-pos)) /* screenWidth*0.79625 = 298.6 */
            delegate?.updateImageTopAnchorConstraint(constant: (pos))
        }
    }
    
    fileprivate func updateHeaderView(_ scrollView: UIScrollView){
        let pos = scrollView.contentOffset.y
        let pec = 1 - (pos)/194
        if pos == 0 {
            yContraint?.constant = 298.6
        }
        if (pos > 0) && (pos < 234){
            yContraint?.constant = 298.6 - pos
            lContraint?.constant = 30 * pec
            rContraint?.constant = -(30 * pec)
        }
        if pos < 0 {
            yContraint?.constant = 298.6 - pos
        }
        if pos > 234 {
            yContraint?.constant = (130/2)
            backButton.setImage(#imageLiteral(resourceName: "back-black").withRenderingMode(.alwaysOriginal), for: .normal)
            sectionTitleIndexCollectionView.isHidden = false
            scrollView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        } else {
            sectionTitleIndexCollectionView.isHidden = true
            backButton.setImage(#imageLiteral(resourceName: "back-white").withRenderingMode(.alwaysOriginal), for: .normal)
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    fileprivate func updateHeaderViewLabel(_ scrollView: UIScrollView) {
        let pos = scrollView.contentOffset.y
        if (pos > -44) && (pos < 164) {
            delegate2?.updateHeaderViewLabelOpacity(constant: pos)
            delegate2?.updateHeaderViewLabelSize(constant: pos)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (collectionView == self.sectionTitleIndexCollectionView) {
            let emptyCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionTitleIndexEmptyCell", for: indexPath)
            emptyCell.frame.size.height = 0
            emptyCell.frame.size.width = 0
            return emptyCell
        } else {
            if (kind == UICollectionView.elementKindSectionHeader) && (indexPath.section == 0) && (indexPath.row == 0) {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DetailHeader", for: indexPath) as! DetailHeaderCollectionViewCell
                self.delegate = header
                return header
            } else if (kind == UICollectionView.elementKindSectionHeader) && (indexPath.section != 0) {
                let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderView
                sectionHeader.title = self.mealSections[indexPath.section-1]
                return sectionHeader
            } else {
                let emptyCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmptyCell", for: indexPath)
                emptyCell.frame.size.height = 0
                emptyCell.frame.size.width = 0
                return emptyCell
            }
        }

    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (collectionView == self.sectionTitleIndexCollectionView) {
            return CGSize(width: 0, height: 0)
        } else {
            return section == 0 ? CGSize(width: view.frame.width, height: view.frame.width*0.79625) : CGSize(width: view.frame.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == self.sectionTitleIndexCollectionView) {
            let row = indexPath.row
            let indx = IndexPath(item: 0, section: row+1)
            self.collectionView.selectItem(at: indx, animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
        } else {
            let mealItemViewController = MealItemViewController()
            present(mealItemViewController, animated: true, completion: nil)
        }
    }
}
protocol CoverImageDelegate {
    func updateImageHeight(height:CGFloat)
    func updateImageTopAnchorConstraint(constant: CGFloat)
}

protocol HeaderViewDelegate {
    func updateHeaderViewLabelOpacity(constant: CGFloat)
    func updateHeaderViewLabelSize(constant: CGFloat)
}

extension DetailViewController /* Section deals with dismiss animator */ {
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleGesture(_ sender: UIPanGestureRecognizer) {

        let percentThreshold:CGFloat = 0.3
        
        // convert x-position to downward pull progress (percentage)
        let translation = sender.translation(in: view)
        let horizontalMovement = translation.x / view.bounds.width
        let rightMovement = fmaxf(Float(horizontalMovement), 0.0)
        let rightMovementPercent = fminf(rightMovement, 1.0)
        let progress = CGFloat(rightMovementPercent)
        
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
    
    func showHelperCircle(){
        let center = CGPoint(x: 10, y: view.bounds.width * 0.5)
        let small = CGSize(width: 30, height: 30)
        let circle = UIView(frame: CGRect(origin: center, size: small))
        circle.layer.cornerRadius = circle.frame.width/2
        circle.backgroundColor = UIColor.white
        circle.layer.shadowOpacity = 0.8
        circle.layer.shadowOffset = CGSize()
        view.addSubview(circle)
        UIView.animate(
            withDuration: 0.5,
            delay: 0.25,
            options: [],
            animations: {
                circle.frame.origin.x += 200
                circle.layer.opacity = 0
        },
            completion: { _ in
                circle.removeFromSuperview()
        }
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showHelperCircle()
    }
}

