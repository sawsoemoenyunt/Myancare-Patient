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
    var appointmentData = AppointmentModel()
    
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
//        btn.addTarget(self, action: #selector(acceptBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func acceptBtnClick(){
        self.navigationController?.pushViewController(RescheduleAppointmentVC(), animated: true)
    }
    
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
        
        collectionView.register(AppointmentDetailCell.self, forCellWithReuseIdentifier: cellID)
        
        setupButtons()
    }
    
    func setupButtons(){
        
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(rejectBtn)
        view.addSubview(acceptBtn)
        
        let v = view.safeAreaLayoutGuide
        let buttonWidth = view.bounds.width/3
        
        switch appointmentData.booking_status{
        case .RESCHEDULE_BY_PATIENT, .RESCHEDULE_BY_DOCTOR:
            closeBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
            rejectBtn.anchor(nil, left: closeBtn.rightAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
            acceptBtn.anchor(nil, left: rejectBtn.rightAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
            collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: closeBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
            
            closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
            rejectBtn.addTarget(self, action: #selector(reject), for: .touchUpInside)
            rejectBtn.setTitle("REJECT", for: .normal)
            acceptBtn.addTarget(self, action: #selector(accept), for: .touchUpInside)
            acceptBtn.setTitle("ACCEPT", for: .normal)
            break
            
        case .PENDING:
            closeBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
            rejectBtn.anchor(nil, left: closeBtn.rightAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
            acceptBtn.anchor(nil, left: rejectBtn.rightAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: 50)
            collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: closeBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
            
            closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
            rejectBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
            rejectBtn.setTitle("CANCEL", for: .normal)
            acceptBtn.addTarget(self, action: #selector(reschedule), for: .touchUpInside)
            acceptBtn.setTitle("RESCHEDULE", for: .normal)
            break
            
        case .APPROVED:
            closeBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width/2, heightConstant: 50)
            acceptBtn.anchor(nil, left: closeBtn.rightAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
            collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: closeBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
            
            closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
            acceptBtn.addTarget(self, action: #selector(start), for: .touchUpInside)
            acceptBtn.setTitle("START \(appointmentData.type!.capitalized)", for: .normal)
            break
        
        case .COMPLETED:
            closeBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
            collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: closeBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
            
            closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
            break

        default:
            closeBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
            collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: closeBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
            closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
            break
        }
    }
    
    @objc func closeBtnClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func reject(){
        //reject doctor's reschedule
    }
    
    @objc func accept(){
        //accept doctor's reschedule
    }
    
    @objc func cancel(){
        //appointent cancel
    }
    
    @objc func reschedule(){
        let rescheduleVC = RescheduleAppointmentVC()
        self.navigationController?.pushViewController(rescheduleVC, animated: true)
    }
    
    @objc func start(){
        //start conversation chat, voice, video
    }
}

extension AppointmentDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AppointmentDetailCell
        cell.appointmentData = self.appointmentData
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 690)
    }
}


