//
//  UserInterestVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/2/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class UserInterestVC: UIViewController {
    
    let cellID = "cellID"
    
    //UILabel to show information
    let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "What are you interest in?\nChoose one or more. You can edit this later."
        lbl.numberOfLines = 0
        lbl.font = UIFont.mmFontRegular(ofSize: 14)
        lbl.textColor = UIColor.MyanCareColor.gray
        return lbl
    }()
    
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
    
    @objc func confrimBtnClick(){
        UtilityClass.switchToHomeViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.title = "Your Interests"
        view.addSubview(label)
        view.addSubview(collectionView)
        view.addSubview(confrimBtn)
        label.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        confrimBtn.anchor(nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        collectionView.anchor(label.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: confrimBtn.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 10, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        collectionView.register(UserInterestCell.self, forCellWithReuseIdentifier: cellID)
    }
}

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

class UserInterestCell: UICollectionViewCell {
    
    let icon: UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = UIColor.gray
        img.layer.cornerRadius = 15 //size 30
        img.clipsToBounds = true
        return img
    }()
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "Urology"
        lbl.font = UIFont.mmFontBold(ofSize: 14)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    func setupViews(){
        addSubview(icon)
        addSubview(label)
        
        icon.anchor(nil, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        icon.anchorCenterYToSuperview()
        label.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 45, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        layer.cornerRadius = 25 //size 50
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        clipsToBounds = true
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                icon.backgroundColor = .white
                backgroundColor = UIColor.MyanCareColor.green
                label.textColor = UIColor.white
                layer.borderWidth = 0
            } else {
                icon.backgroundColor = .gray
                backgroundColor = UIColor.white
                label.textColor = .black
                layer.borderWidth = 1
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
