//
//  AppointmentDetailVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/11/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class AppointmentDetailVC: UIViewController {
    
    let cellID = "cellID"
    
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
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return cv
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("CLOSE", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.backgroundColor = UIColor.MyanCareColor.lightGray
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var rejectBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("REJECT", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.MyanCareColor.orange
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var acceptBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("ACCEPT", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(acceptBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func acceptBtnClick(){
        self.navigationController?.pushViewController(RescheduleAppointmentVC(), animated: true)
    }
    
    lazy var rescheduleBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("RESCHEDULE", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var startChatBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("START CHAT", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.clipsToBounds = true
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        self.title = "Appointment Detail"
        view.backgroundColor = UIColor.white
        
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(rejectBtn)
        view.addSubview(acceptBtn)
        
        let v = view.safeAreaLayoutGuide
        let buttonWidth = view.bounds.width/3
        closeBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
        rejectBtn.anchor(nil, left: closeBtn.rightAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
        acceptBtn.anchor(nil, left: rejectBtn.rightAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
        collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: closeBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        collectionView.register(AppointmentDetailCell.self, forCellWithReuseIdentifier: cellID)
    }
}

extension AppointmentDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AppointmentDetailCell
        cell.doctorImage.image = UIImage.init(named: "pablo-profile")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 650)
    }
}


