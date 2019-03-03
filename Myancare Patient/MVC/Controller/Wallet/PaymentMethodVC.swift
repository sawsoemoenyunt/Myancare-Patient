//
//  PaymentMethodVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/3/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

struct PaymentList {
    var paymentGroup = ""
    var paymentGateways: [PaymentGateway]
}

struct PaymentGateway {
    var name = ""
    var iconName = ""
}

class PaymentMethodVC: UIViewController {
    
    let cellID = "cellID"
    let paymentList = [
        PaymentList.init(paymentGroup: "Pay with Bill", paymentGateways: [
            PaymentGateway.init(name: "Telenor", iconName: "telenor")]),
        PaymentList.init(paymentGroup: "Pay with Banking", paymentGateways: [
            PaymentGateway.init(name: "KBZ", iconName: "kbz"),
            PaymentGateway.init(name: "CB", iconName: "cb"),
            PaymentGateway.init(name: "AYA", iconName: "aya"),
            PaymentGateway.init(name: "MPU", iconName: "mpu")
            ]),
        PaymentList.init(paymentGroup: "Pay with Mobile Money", paymentGateways: [
            PaymentGateway.init(name: "Wave Money", iconName: "wave_money"),
            PaymentGateway.init(name: "OK$", iconName: "ok"),
            PaymentGateway.init(name: "MPitesan", iconName: "mpitesan")
            ]),
        PaymentList.init(paymentGroup: "Pay with other", paymentGateways: [
            PaymentGateway.init(name: "2c2p", iconName: "m2c2p")
            ])
    ]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        self.title = "Select Payment Methods"
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        let v = view.safeAreaLayoutGuide
        collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        collectionView.register(PaymentRowCell.self, forCellWithReuseIdentifier: cellID)
    }
}

extension PaymentMethodVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paymentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PaymentRowCell
        cell.payments = paymentList[indexPath.row].paymentGateways
        cell.typeLabel.text = paymentList[indexPath.row].paymentGroup
        cell.paymentMethodVC = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 130)
    }
}

class PaymentRowCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var paymentMethodVC: PaymentMethodVC?
    var payments = [PaymentGateway]()
    
    let cellID = "cellID"
    
    let typeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Pay with bill"
        lbl.font = UIFont.mmFontBold(ofSize: 16)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        return cv
    }()
    
    let roundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    func setupViews(){
       
        addSubview(roundView)
        roundView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 2, leftConstant: 2, bottomConstant: 2, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        
        addSubview(typeLabel)
        addSubview(collectionView)
        typeLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 14, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        collectionView.anchor(typeLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 4, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
        collectionView.register(PaymentCell.self, forCellWithReuseIdentifier: cellID)
        
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return payments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PaymentCell
        cell.gateWayNameLabel.text = payments[indexPath.row].name
        cell.icon.image = UIImage(named: payments[indexPath.row].iconName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/4, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        paymentMethodVC?.navigationController?.pushViewController(SelectAmountVC(), animated: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PaymentCell: UICollectionViewCell {
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .white
        img.layer.cornerRadius = 25 //size 50
        img.layer.borderColor = UIColor.gray.cgColor
        img.layer.borderWidth = 0.5
        img.clipsToBounds = true
        return img
    }()
    
    let gateWayNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Payment Gateway"
        lbl.font = UIFont.mmFontRegular(ofSize: 12)
        lbl.textColor = UIColor.black
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        return lbl
    }()
    
    let autoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Auto"
        lbl.font = UIFont.mmFontRegular(ofSize: 8)
        lbl.textColor = UIColor.gray
        lbl.textAlignment = .center
        return lbl
    }()
    
    func setupViews(){
        addSubview(icon)
        addSubview(gateWayNameLabel)
        addSubview(autoLabel)
        
        icon.anchor(topAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        icon.anchorCenterXToSuperview()
        gateWayNameLabel.anchor(icon.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 2, leftConstant: 4, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        autoLabel.anchor(gateWayNameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        
        autoLabel.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
