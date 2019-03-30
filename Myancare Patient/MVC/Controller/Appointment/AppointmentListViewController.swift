//
//  AppointmentListViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/23/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

enum AppointmentType{
    case history
    case ongoing
    case upcoming
}

enum AppointmentStatus:String{
    case waiting = "waiting"
    case reschedule = "reschedule"
    case accepted = "accepted"
    case completed = "completed"
    case rejected = "rejected"
}

class AppointmentListViewController: UIViewController, NVActivityIndicatorViewable {
    
    let cellID = "cellID"
    var numberofCell = 5
    var appointmentList = [AppointmentModel]()
    
    lazy var listTypeSegment:UISegmentedControl = {
        let sg = UISegmentedControl(items: ["Upcoming","Ongoing", "History"])
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
        addCutomData()
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
        let appointmentdetailVC = AppointmentDetailVC()
        appointmentdetailVC.appointmentData = appointmentList[indexPath.row]
        self.navigationController?.pushViewController(appointmentdetailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appointmentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AppointmentListCell
       cell.appointmentData = appointmentList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 110)
    }
}

extension AppointmentListViewController{
    func addCutomData(){
        for item in 1...10{
            let appointment = AppointmentModel()
            appointment.doctor = ["name":"Dr.Phyo Phyo Maung", "image_url":"www.imagelink.com"]
            appointment.patient = ["name":"Saw Soe Moe Nyunt"]
            appointment.date_of_issue = ["date":"2019-3-30"]
            appointment.reason = "I'm sick like a sick"
            appointment.type = item%2 == 0 ? "voice" : "chat"
            appointment.service_fees = 1500
            appointment.total_appointment_fees = 2500
            appointment.date_of_issue_utc = ["date":"019-03-30T15:34:29Z"]
            
            switch item{
            case 0:
                appointment.booking_status = "reschedule"
                break
            case 1:
                appointment.booking_status = "waiting"
                break
            case 2:
                appointment.booking_status = "accepted"
                break
            case 3:
                appointment.booking_status = "completed"
                break
            default:
                appointment.booking_status = "waiting"
                break
            }
            
            appointmentList.append(appointment)
        }
        self.appointmentListCollectionView.reloadData()
    }
    
    func getAppointments(_ type:AppointmentType){
        
        self.startAnimating()
        
        let url = EndPoints.getAppointmentHistory.path
        let heads = ["Authorazations" : "\(jwtTkn)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let status = response.response?.statusCode
                print("Status code : \(status ?? 0)")
                
                if status == 400{
                    print("Record Not found!")
                    
                } else if status == 200{
                    if let responseDataArray = response.result.value as? NSArray{
                        for responseData in responseDataArray{
                            if let responseDict = responseData as? [String:Any]{
                                let appointment = AppointmentModel()
                                appointment.updateModleUsingDict(responseDict)
                                
                                self.appointmentList.append(appointment)
                            }
                        }
                        self.appointmentListCollectionView.reloadData()
                    }
                }
                
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
}
