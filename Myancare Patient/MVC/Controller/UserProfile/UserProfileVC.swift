//
//  UserProfileVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/6/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class UserProfileVC: UIViewController {
    
    let cellID = "cellID"
    var userData = PatientModel()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        return cv
    }()
    
    lazy var editInterestBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Edit my interest", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(editBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func editBtnClick(){
        self.navigationController?.pushViewController(UserInterestVC(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let user = UserDefaults.standard.getUserData() as? [String:Any]{
            userData.updateModel(usingDictionary: user)
            collectionView.reloadData()
        }
    }
    
    var collectionViewTopAnchor:NSLayoutConstraint?
    
    func setupViews(){
        self.title = "User Profile"
        view.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellID)
        
        view.addSubview(collectionView)
//        view.addSubview(editInterestBtn)
        
        let v = view.safeAreaLayoutGuide
        collectionViewTopAnchor = collectionView.anchorWithReturnAnchors(v.topAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 0)[0]
//        editInterestBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 50) //default size 50
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(profileEditBtnClick))
    }
    
    @objc func profileEditBtnClick(){
        let editVC = UserProfileEditVC()
        editVC.userData = self.userData
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func moveViewToTopWithConstant(_ constant:CGFloat){
        collectionViewTopAnchor?.constant = constant
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension UserProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ProfileCell
        cell.userProfileVC = self
        cell.profileImage.image = UIImage.init(named: "no-image")
        cell.nameTextField.text = userData.name!
        cell.phoneUserIDTextField.text = "\(userData.country_code!)\(userData.mobile!)"
        cell.dobTextField.text = userData.dob!
        cell.emailTextField.text = userData.email!
        if userData.gender == "male" {
            cell.maleBtn.backgroundColor = UIColor.MyanCareColor.orange
            cell.femaleBtn.backgroundColor = UIColor.white
        } else {
            cell.femaleBtn.backgroundColor = UIColor.MyanCareColor.orange
            cell.maleBtn.backgroundColor = UIColor.white
        }
        
        cell.heightTextField.text = "\(userData.height!.replacingOccurrences(of: ".", with: "'"))"
        cell.weightTextField.text = "\(userData.weight!)"
        cell.bloodtypeTextField.text = "\(userData.bloodType!)"
        UIImage.loadImage(userData.image_url!) { (image) in
            cell.profileImage.image = image   
        }
        
        cell.phoneUserIDTextField.isEnabled = false
        cell.nameTextField.isEnabled = false
        cell.dobTextField.isEnabled = false
        cell.emailTextField.isEnabled = false
        cell.maleBtn.isEnabled = false
        cell.femaleBtn.isEnabled = false
        cell.heightTextField.isEnabled = false
        cell.weightTextField.isEnabled = false
        cell.bloodtypeTextField.isEnabled = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 650)
    }
}



