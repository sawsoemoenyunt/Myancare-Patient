//
//  WalletVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/3/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class WalletVC: UIViewController {
    
    let cellID = "cellID"
    
    let coinlabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "8000 Coin"
        lbl.numberOfLines = 1
        lbl.font = UIFont.mmFontBold(ofSize: 72)
        lbl.textColor = UIColor.black
        lbl.textAlignment = .center
        return lbl
    }()
    
    let statusLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "coin"
        lbl.numberOfLines = 1
        lbl.font = UIFont.mmFontRegular(ofSize: 14)
        lbl.textColor = UIColor.MyanCareColor.gray
        return lbl
    }()
    
    lazy var topUpBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("TOP UP", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(topUpBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        return cv
    }()
    
    @objc func topUpBtnClick(){
        //do something
    }
    
    let headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Purchase Histories"
        lbl.numberOfLines = 0
        lbl.font = UIFont.mmFontBold(ofSize: 20)
        lbl.textColor = UIColor.MyanCareColor.gray
        return lbl
    }()
    
    lazy var headerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(headerLabel)
        headerLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Wallet Screen"
        view.backgroundColor = .white
        collectionView.register(WalletCell.self, forCellWithReuseIdentifier: cellID)
        
        setupViews()
    }
    
    func setupViews(){
        view.addSubview(coinlabel)
        view.addSubview(topUpBtn)
        view.addSubview(collectionView)
        view.addSubview(headerView)
        
        let v = view.safeAreaLayoutGuide
        coinlabel.anchor(v.topAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 50, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        topUpBtn.anchor(coinlabel.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 50, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        headerView.anchor(topUpBtn.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        collectionView.anchor(headerView.bottomAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 5, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        setupAttributeString()
    }
    
    func setupAttributeString(){
        let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.mmFontBold(ofSize: 72)]
        let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.mmFontRegular(ofSize: 14)]
        
        let coinAmount = NSMutableAttributedString(string: "80,000", attributes: yourAttributes)
        let cointStatus = NSMutableAttributedString(string: " coin", attributes: yourOtherAttributes)
        
        let combination = NSMutableAttributedString()
        
        combination.append(coinAmount)
        combination.append(cointStatus)
        coinlabel.attributedText = combination
    }
}

extension WalletVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
}

class WalletCell: UICollectionViewCell {
    
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "dd-MMM-yy"
        lbl.numberOfLines = 1
        lbl.font = UIFont.mmFontRegular(ofSize: 12)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let noteLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "transaction note here"
        lbl.numberOfLines = 1
        lbl.font = UIFont.mmFontRegular(ofSize: 12)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let circleView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let verticallineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    func setupViews(){
        addSubview(dateLabel)
        addSubview(noteLabel)
        addSubview(verticallineView)
        addSubview(circleView)
        
        dateLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 14, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 0)
        circleView.anchor(topAnchor, left: dateLabel.rightAnchor, bottom: nil, right: nil, topConstant: 14, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 22, heightConstant: 22)
        verticallineView.anchor(topAnchor, left: circleView.leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 11, bottomConstant: 0, rightConstant: 0, widthConstant: 1, heightConstant: 0)
        noteLabel.anchor(topAnchor, left: circleView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 14, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

