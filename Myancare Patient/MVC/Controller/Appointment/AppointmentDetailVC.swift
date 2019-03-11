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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 650)
    }
}

class AppointmentDetailCell: UICollectionViewCell {
    
    var appointmentDetailVC:AppointmentDetailVC?
    
    let bgView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    
    let doctorImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = UIColor.gray
        img.layer.cornerRadius = 25 //size 50
        img.clipsToBounds = true
        return img
    }()
    
    lazy var statusBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("RESCHEDULE", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.MyanCareColor.yellow
        btn.layer.cornerRadius = 25 //50
        btn.clipsToBounds = true
        return btn
    }()
    
    let doctorNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dr.Zayar Phyo Maung"
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let lineView1: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.gray
        return v
    }()
    
    private let patientLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Patient Name : "
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.gray
        return lbl
    }()
    
    let patientNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Kris"
        lbl.numberOfLines = 0
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Date of Issue : "
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.gray
        return lbl
    }()
    
    let dateNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "20 Feb 2019 | 8:00AM"
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    private let reasonLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Reason for Visit : "
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.gray
        return lbl
    }()
    
    let reasonDataLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sick"
        lbl.numberOfLines = 0
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let lineView2: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.gray
        return v
    }()
    
    let centerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    
    private let serviceLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Service Unit"
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.MyanCareColor.gray
        return lbl
    }()
    
    let serviceUnitLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "15 min (max)"
        lbl.font = UIFont.MyanCareFont.type7
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    private let serviceTLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Service Type"
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.MyanCareColor.gray
        return lbl
    }()
    
    let serviceTypeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "VOICE"
        lbl.font = UIFont.MyanCareFont.type7
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let lineView3: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.gray
        return v
    }()
    
    private let totalAmountLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Total Amount"
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.gray
        lbl.textAlignment = .center
        return lbl
    }()
    
    let totalAmountDataLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "2400.00 coin"
        lbl.font = UIFont.MyanCareFont.type1
        lbl.textColor = UIColor.black
        lbl.textAlignment = .center
        return lbl
    }()
    
    let lineView4: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.gray
        return v
    }()
    
    let scheduleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Schedule Date/Time"
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.gray
        lbl.textAlignment = .center
        return lbl
    }()
    
    let scheduleDataLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "25 Feb 2019 | 14:50 PM"
        lbl.font = UIFont.MyanCareFont.type1
        lbl.textColor = UIColor.black
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var medicalRecordBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("MEDICAL RECORD BOOK", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.setTitleColor(UIColor.MyanCareColor.green, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.layer.borderColor = UIColor.MyanCareColor.green.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        return btn
    }()
    
    @objc func medicalRecordBtnClick(){
        
    }
    
    func setupViews(){
        addSubview(bgView)
        addSubview(medicalRecordBtn)
        medicalRecordBtn.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        bgView.anchor(topAnchor, left: leftAnchor, bottom: medicalRecordBtn.topAnchor, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 30, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        bgView.addSubview(doctorImage)
        bgView.addSubview(statusBtn)
        bgView.addSubview(doctorNameLabel)
        bgView.addSubview(lineView1)
        
        bgView.addSubview(patientLabel)
        bgView.addSubview(patientNameLabel)
        bgView.addSubview(dateLabel)
        bgView.addSubview(dateNameLabel)
        bgView.addSubview(reasonLabel)
        bgView.addSubview(reasonDataLabel)
        bgView.addSubview(lineView2)
        
        bgView.addSubview(centerView)
        bgView.addSubview(serviceLabel)
        bgView.addSubview(serviceUnitLabel)
        bgView.addSubview(serviceTLabel)
        bgView.addSubview(serviceTypeLabel)
        bgView.addSubview(lineView3)
        
        bgView.addSubview(totalAmountLabel)
        bgView.addSubview(totalAmountDataLabel)
        bgView.addSubview(lineView4)
        
        bgView.addSubview(scheduleLabel)
        bgView.addSubview(scheduleDataLabel)
        
        doctorImage.anchor(bgView.topAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        statusBtn.anchor(bgView.topAnchor, left: nil, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 200, heightConstant: 50)
        doctorNameLabel.anchor(doctorImage.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        lineView1.anchor(doctorNameLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        patientLabel.anchor(lineView1.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        patientNameLabel.anchor(lineView1.bottomAnchor, left: patientLabel.rightAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        dateLabel.anchor(patientNameLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        dateNameLabel.anchor(patientNameLabel.bottomAnchor, left: dateLabel.rightAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        reasonLabel.anchor(dateLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        reasonDataLabel.anchor(dateLabel.bottomAnchor, left: reasonLabel.rightAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        lineView2.anchor(reasonDataLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        centerView.anchor(lineView2.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 1, heightConstant: 1)
        centerView.anchorCenterXToSuperview()
        serviceLabel.anchor(lineView2.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: centerView.leftAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        serviceUnitLabel.anchor(serviceLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: centerView.leftAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        serviceTLabel.anchor(lineView2.bottomAnchor, left: centerView.rightAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 4, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        serviceTypeLabel.anchor(serviceTLabel.bottomAnchor, left: centerView.rightAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 10, leftConstant: 4, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        lineView3.anchor(serviceTypeLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        totalAmountLabel.anchor(lineView3.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        totalAmountDataLabel.anchor(totalAmountLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        lineView4.anchor(totalAmountDataLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        scheduleLabel.anchor(lineView4.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        scheduleDataLabel.anchor(scheduleLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        bgView.layer.borderColor = UIColor.MyanCareColor.lightGray.cgColor
        bgView.layer.borderWidth = 1
        bgView.layer.cornerRadius = 5
        bgView.layer.masksToBounds = true
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
