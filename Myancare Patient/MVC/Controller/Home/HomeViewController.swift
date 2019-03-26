//
//  HomeViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Localize_Swift
import Alamofire

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let collectionViewCellID_Menu = "collectionViewCellID_Menu"
    let collectionViewCellID_Category = "collectionViewCellID_Category"
    let collectionViewCellID_Online = "collectionViewCellID_Online"
//    var doctorArr = [DoctorModel]()
//    var recommandDoctorArr = [DoctorModel]()
    var notiCount = 0
    
    func updateDeviceToken(){
        if let deviceToken = UserDefaults.standard.getPushyToken(){
            let url = EndPoints.updateDeviceToken(deviceToken).path
            Alamofire.request(url, method: HTTPMethod.put, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                print("Update device token result = \(response.result)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionview
        self.collectionView?.backgroundColor = .white
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        //register cell
        self.collectionView?.register(MenuCell.self, forCellWithReuseIdentifier: collectionViewCellID_Menu)
        self.collectionView?.register(MenuCategoryCell.self, forCellWithReuseIdentifier: collectionViewCellID_Category)
        self.collectionView?.register(MenuOnlineCell.self, forCellWithReuseIdentifier: collectionViewCellID_Online)
        
        updateDeviceToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupViews()
        
        ///MARK : CHANGE LATER
        UserDefaults.standard.setToken(value: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjViYjg3MmZlNjhhOTExMmIwNDYyMjdkMCIsInJvbGUiOiJQYXRpZW50IiwiaWF0IjoxNTUzNTkyNzI2fQ.MEmQGBBsLFZfLrnqLiCWMa-O2CacRGjME1PCd6f4fAY")
        
        if let token = UserDefaults.standard.getToken(){
            print("Login token : \(token)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.title = "Welcome".localized()
        setupNavBarItems()
    }
    
    func setupNavBarItems(){
        let questionButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ask_question_filled"), style: .plain, target: self, action: #selector(messagesButtonPressed))
        let notiButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-appointment_reminders"), style: .plain, target: self, action: #selector(self.notiButtonPressed))
//        let spacebutton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItems = [questionButton, notiButton]
    }
    
    // MARK: - Navigation Message Button Action
    @objc func messagesButtonPressed () {
        UtilityClass.changeRootViewController(with: StartScreenViewController())
    }
    
    // MARK: - Navigation Message Button Action
    @objc func notiButtonPressed () {
        self.navigationController?.pushViewController(NotificationListVC(), animated: true)
    }
    
    func setupViews(){
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Welcome".localized()
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.font: UIFont.mmFontZawgyi(ofSize: 32)]
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = .white
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.mmFontZawgyi(ofSize: 14)]
    }
    
    func pushToVC(vc: UIViewController){
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        switch indexPath.row {
        case 0:
            let menuCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID_Menu, for: indexPath) as! MenuCell
            menuCell.homeViewController = self
            cell = menuCell
            break
        case 1:
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID_Category, for: indexPath) as! MenuCategoryCell
            categoryCell.homeViewController = self
            cell = categoryCell
            break
        case 2:
            let onlinecell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID_Online, for: indexPath) as! MenuOnlineCell
            onlinecell.labe1.text = "Online".localized()
            onlinecell.homeViewController = self
            onlinecell.docType = DoctorType.recommand
            cell = onlinecell
            break
        case 3:
            let mydocCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID_Online, for: indexPath) as! MenuOnlineCell
            mydocCell.labe1.text = "Favourite".localized()
            mydocCell.homeViewController = self
            mydocCell.docType = DoctorType.favourite
            cell = mydocCell
            break
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 180.0
        if indexPath.row > 1 {
            height = 165.0
        }
        return CGSize(width: (self.collectionView?.frame.width)! - 20, height: height)
    }
    
}


