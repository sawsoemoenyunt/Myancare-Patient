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
            PaymentGateway.init(name: "telenor", iconName: "telenor")]),
        PaymentList.init(paymentGroup: "Pay with Banking", paymentGateways: [
            PaymentGateway.init(name: "kbz", iconName: "kbz"),
            PaymentGateway.init(name: "cb", iconName: "cb"),
            PaymentGateway.init(name: "aya", iconName: "aya"),
            PaymentGateway.init(name: "mpu", iconName: "mpu")
            ]),
        PaymentList.init(paymentGroup: "Pay with Mobile Money", paymentGateways: [
            PaymentGateway.init(name: "Wave Money", iconName: "wave_money"),
            PaymentGateway.init(name: "ok$", iconName: "ok"),
            PaymentGateway.init(name: "mpitesan", iconName: "mpitesan")
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


