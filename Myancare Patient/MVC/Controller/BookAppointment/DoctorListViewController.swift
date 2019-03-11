//
//  DoctorListViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

enum DoctorType{
    case recommand
    case favourite
    case all
    case specialize
}

class DoctorListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    var isPaging = false
    var doctorType = DoctorType.all
    var specializeID = ""
    let buttonList:[MenuButton] = [MenuButton(title: "Dr.Apple", icon: #imageLiteral(resourceName: "pablo-profile")),
                                   MenuButton(title: "Dr.Orange", icon: #imageLiteral(resourceName: "pablo-profile")),
                                   MenuButton(title: "Dr.Grape", icon: #imageLiteral(resourceName: "pablo-profile")),
                                   MenuButton(title: "Dr.Paul", icon: #imageLiteral(resourceName: "pablo-profile"))]
    
    lazy var refreshControl1 : UIRefreshControl = {
        let  rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshDoctorData), for: .valueChanged)
        return rc
    }()
    
    @objc func refreshDoctorData() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ဆရာ၀န္မ်ား"
        self.view.backgroundColor = .white
        let searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ask_question_filled"), style: .plain, target: self, action: #selector(searchButtonClick))
        self.navigationItem.rightBarButtonItems = [searchButton]
        
        //searchController
        //        let search = UISearchController(searchResultsController: nil)
        //        search.searchResultsUpdater = self
        //        self.navigationItem.searchController = search
        
        //collectionView
        collectionView!.register(DoctorListCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView?.backgroundColor = .white
        collectionView?.refreshControl = refreshControl1
        
    }
    
    @objc func searchButtonClick(){
        self.navigationController?.pushViewController(DoctorSearchViewController(), animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! DoctorListCell
        cell.profileImage.image = buttonList[indexPath.row].icon
        cell.nameLabel.text = buttonList[indexPath.row].title
        cell.addressLabel.text = "Yangon"
        cell.specializeLabel.text = "General P"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView!.frame.width, height: 89)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let doctorDetailVC = DoctorDetailVC(collectionViewLayout: layout)
        self.navigationController?.pushViewController(doctorDetailVC, animated: true)
    }
    
}
