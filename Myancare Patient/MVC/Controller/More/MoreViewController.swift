//
//  MoreViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    let cellID_profile = "cellID_profile"
    let buttonList:[MenuButton] = [MenuButton(title: "Username", icon: #imageLiteral(resourceName: "icons8-vegan_food")),
                                   MenuButton(title: "Change Language", icon: #imageLiteral(resourceName: "icons8-geography")),
                                   MenuButton(title: "Security", icon: #imageLiteral(resourceName: "icons8-security_checked_filled")),
                                   MenuButton(title: "Feedback Us", icon: #imageLiteral(resourceName: "icons8-stopwatch")),
                                   MenuButton(title: "Invite your friend", icon: #imageLiteral(resourceName: "icons8-stopwatch")),
                                   MenuButton(title: "Help", icon: #imageLiteral(resourceName: "icons8-ask_question_filled")),
                                   MenuButton(title: "About", icon: #imageLiteral(resourceName: "icons8-about"))]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    lazy var signOutBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("SIGN OUT", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(red:0.94, green:0.36, blue:0.19, alpha:1) //orange
        btn.layer.cornerRadius = 23
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(signOutButtonClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func signOutButtonClick(){
        
    }
    
    let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Copyright © 2018-2019\nAllright reserved by MyanCare\nVersion 2.1.1"
        lbl.numberOfLines = 3
        lbl.textAlignment = .center
        lbl.font = UIFont.mmFontRegular(ofSize: 11)
        
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
        self.view.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.topItem?.title = ""
        
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func setupViews(){
        view.addSubview(collectionView)
        view.addSubview(signOutBtn)
        view.addSubview(infoLabel)
        
        collectionView.fillSuperview()
        
        infoLabel.anchor(nil, left: self.view.safeAreaLayoutGuide.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 4, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        signOutBtn.anchor(nil, left: self.view.safeAreaLayoutGuide.leftAnchor, bottom: infoLabel.topAnchor, right: self.view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 12, rightConstant: 8, widthConstant: 0, heightConstant: 46)
        
        collectionView.register(MoreCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(MoreCollectionViewEditProfileCell.self, forCellWithReuseIdentifier: cellID_profile)
    }
}

extension MoreViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize = CGSize(width: self.collectionView.frame.width, height: 54)
        
        if indexPath.row == 0 {
            cellSize = CGSize(width: self.collectionView.frame.width, height: 85)
        }
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if indexPath.row == 0 {
            let profilecell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_profile, for: indexPath) as! MoreCollectionViewEditProfileCell
            cell = profilecell
        } else {
            let morecell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MoreCollectionViewCell
            morecell.icon.image = buttonList[indexPath.row].icon
            morecell.label.text = buttonList[indexPath.row].title
            morecell.swLangauge.isHidden = true
            
            cell = morecell
        }
        return cell
    }
}
