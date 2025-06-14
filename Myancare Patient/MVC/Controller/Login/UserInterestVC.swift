//
//  UserInterestVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/2/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

///UIViewController : To choose favourite category
class UserInterestVC: UIViewController {
    
    ///Cell id for collectionview
    let cellID = "cellID"
    
    ///UILabel : to show information
    let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "What are you interest in?\nChoose one or more. You can edit this later."
        lbl.numberOfLines = 0
        lbl.font = UIFont.mmFontRegular(ofSize: 14)
        lbl.textColor = UIColor.MyanCareColor.gray
        return lbl
    }()
    
    ///UICollectionView : to show list of category
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        return cv
    }()
    
    //UIButton : Custom button for confirmation
    lazy var confrimBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("NEXT", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(confrimBtnClick), for: .touchUpInside)
        return btn
    }()
    
    /**
     To handle confrim button click
     - Parameters: nil
     - Returns: nil
     */
    @objc func confrimBtnClick(){
        UtilityClass.switchToHomeViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.title = "Your Interests"
        
        //adding subviews to view
        view.addSubview(label)
        view.addSubview(collectionView)
        view.addSubview(confrimBtn)
        
        //adding constraints to subviews
        label.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        confrimBtn.anchor(nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        collectionView.anchor(label.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: confrimBtn.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 10, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        //register custom cell for collectionview
        collectionView.register(UserInterestCell.self, forCellWithReuseIdentifier: cellID)
    }
}

///UICollectionvewi Extension for UserInterestVC
extension UserInterestVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UserInterestCell
        cell.label.text = indexPath.row%3 == 0 ? "Neurology" : "Ear, Nose, Throat"

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        let infoText = indexPath.row%3 == 0 ? "Neurology" : "Ear, Nose, Throat"
        let cellWidth = infoText.count < 10 ? screenWidth/3+10 : screenWidth/2 + 40
        return CGSize(width: cellWidth, height: 50)
    }
}


