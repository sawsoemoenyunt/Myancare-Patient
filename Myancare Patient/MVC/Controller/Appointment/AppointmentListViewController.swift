//
//  AppointmentListViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/23/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class AppointmentListViewController: UIViewController {
    
    
    let cellID = "cellID"
    var numberofCell = 5
    
    lazy var listTypeSegment:UISegmentedControl = {
        let sg = UISegmentedControl(items: ["Upcoming","Ongoing", "History"])
//        sg.setImage( #imageLiteral(resourceName: "icons8-magazine"), forSegmentAt: 0)
//        sg.setImage( #imageLiteral(resourceName: "icons8-more_filled"), forSegmentAt: 1)
//        sg.setImage( #imageLiteral(resourceName: "icons8-appointment_reminders"), forSegmentAt: 2)
        sg.tintColor = UIColor(red:0.51, green:0.75, blue:0.35, alpha:1)
        sg.backgroundColor = .clear
        sg.selectedSegmentIndex = 0
        sg.layer.cornerRadius = 17
        sg.clipsToBounds = true
        sg.layer.borderWidth = 2
        sg.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        sg.layer.borderColor = UIColor(red:0.51, green:0.75, blue:0.35, alpha:1).cgColor
        sg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        sg.addTarget(self, action: #selector(handleSegment), for: .valueChanged)
        return sg
    }()
    
    lazy var refreshControl1 : UIRefreshControl = {
        let  rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshAppointment), for: .valueChanged)
        return rc
    }()
    
    @objc func refreshAppointment() {
        numberofCell = Int.random(in: 1..<10)
        refreshControl1.endRefreshing()
        appointmentListCollectionView.reloadData()
    }
    
    @objc func handleSegment(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            appointmentTypeLabel.text = "Upcoming Appointment"
            numberofCell = 5
        } else if sender.selectedSegmentIndex == 1{
            appointmentTypeLabel.text = "Ongoing Appointment"
            numberofCell = 2
        } else {
            appointmentTypeLabel.text = "Appointment History"
            numberofCell = 10
        }
        self.appointmentListCollectionView.reloadData()
    }
    
    let appointmentTypeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Upcoming Appointment"
        lbl.font = UIFont.mmFontBold(ofSize: 16)
        return lbl
    }()
    
    lazy var appointmentListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Appointments"
        view.backgroundColor = .white
        appointmentListCollectionView.register(AppointmentListCell.self, forCellWithReuseIdentifier: cellID)
        setupViews()
    }

    func setupViews(){
        view.addSubview(listTypeSegment)
        view.addSubview(appointmentTypeLabel)
        view.addSubview(appointmentListCollectionView)
        
        listTypeSegment.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 34)
        appointmentTypeLabel.anchor(listTypeSegment.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        appointmentListCollectionView.anchor(appointmentTypeLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        appointmentListCollectionView.refreshControl = refreshControl1
    }
}

extension AppointmentListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(AppointmentDetailVC(), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberofCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AppointmentListCell
       
        if indexPath.row % 2 == 0 {
            cell.typeBtn.setTitle("Voice", for: .normal)
            cell.conditionBtn.setTitle("Accepted", for: .normal)
            cell.conditionBtn.setTitleColor(UIColor.white, for: .normal)
            cell.conditionBtn.backgroundColor = UIColor(red:0.51, green:0.75, blue:0.35, alpha:1)
        } else {
            cell.typeBtn.setTitle("Chat", for: .normal)
            cell.conditionBtn.setTitle("Waiting", for: .normal)
            cell.conditionBtn.setTitleColor(UIColor.black, for: .normal)
            cell.conditionBtn.backgroundColor = UIColor.yellow
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: appointmentListCollectionView.frame.width, height: 110)
    }
}

class AppointmentListCell: UICollectionViewCell {
    
    let profileImage: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        img.image = #imageLiteral(resourceName: "pablo-profile")
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 32
        img.clipsToBounds = true
        return img
    }()
    
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "15 Feb 2019 | 02:50 PM"
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = UIColor(red:0.53, green:0.53, blue:0.53, alpha:1)
        return lbl
    }()
    
    let doctorNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dr.John Doe"
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    lazy var typeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Chat", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = UIColor.lightGray
        btn.titleLabel?.font = UIFont.mmFontRegular(ofSize: 11)
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var conditionBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Waiting", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.mmFontRegular(ofSize: 11)
        btn.backgroundColor = UIColor.yellow
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        return btn
    }()
    
    func setupViews(){
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        self.layer.masksToBounds = true
        
        self.backgroundColor = .white
        
        addSubview(profileImage)
        addSubview(dateLabel)
        addSubview(doctorNameLabel)
        addSubview(typeBtn)
        addSubview(conditionBtn)
        addSubview(lineView)
        
        profileImage.anchor(nil, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 64, heightConstant: 64)
        profileImage.anchorCenterYToSuperview()
        dateLabel.anchor(profileImage.topAnchor, left: profileImage.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        doctorNameLabel.anchor(dateLabel.bottomAnchor, left: profileImage.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        typeBtn.anchor(doctorNameLabel.bottomAnchor, left: profileImage.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 55, heightConstant: 20)
        conditionBtn.anchor(doctorNameLabel.bottomAnchor, left: typeBtn.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 20)
        lineView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0.5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
