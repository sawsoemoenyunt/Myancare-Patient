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


