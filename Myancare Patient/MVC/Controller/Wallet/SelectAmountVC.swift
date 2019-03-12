//
//  SelectAmountVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/4/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class SelectAmountVC: UIViewController {
    
    let cellID = "cellID"
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "kbz")
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .white
        img.layer.cornerRadius = 30 //size 60
        img.layer.borderColor = UIColor.gray.cgColor
        img.layer.borderWidth = 0.5
        img.clipsToBounds = true
        return img
    }()
    
    let gateWayNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Pay with KBZ"
        lbl.font = UIFont.mmFontBold(ofSize: 16)
        lbl.textColor = UIColor.black
        lbl.numberOfLines = 2
        return lbl
    }()
    
    let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Please select the amount that you want to purchase to pay with KBZ bank."
        lbl.font = UIFont.mmFontRegular(ofSize: 16)
        lbl.textColor = UIColor.black
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let costAmountLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Cost Amount"
        lbl.font = UIFont.mmFontBold(ofSize: 16)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let costLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Cost (Kyat)"
        lbl.font = UIFont.mmFontBold(ofSize: 16)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        return cv
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("CONFIRM", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
//        btn.addTarget(self, action: #selector(topUpBtnClick), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        self.title = "Select Amount"
        view.backgroundColor = .white
        
        collectionView.register(AmountCell.self, forCellWithReuseIdentifier: cellID)
        
        view.addSubview(icon)
        view.addSubview(gateWayNameLabel)
        view.addSubview(infoLabel)
        view.addSubview(lineView)
        view.addSubview(collectionView)
        view.addSubview(confirmBtn)
        view.addSubview(costLabel)
        view.addSubview(costAmountLabel)
        
        let v = view.safeAreaLayoutGuide
        icon.anchor(v.topAnchor, left: v.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 60)
        gateWayNameLabel.anchor(icon.topAnchor, left: icon.rightAnchor, bottom: icon.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        infoLabel.anchor(icon.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 6, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        lineView.anchor(infoLabel.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0.5)
        costAmountLabel.anchor(lineView.bottomAnchor, left: v.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: view.bounds.width/2 - 4, heightConstant: 0)
        costLabel.anchor(lineView.bottomAnchor, left: costAmountLabel.rightAnchor, bottom: nil, right: v.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        confirmBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        collectionView.anchor(lineView.bottomAnchor, left: v.leftAnchor, bottom: confirmBtn.topAnchor, right: v.rightAnchor, topConstant: 50, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
    }
}

extension SelectAmountVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AmountCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
}


