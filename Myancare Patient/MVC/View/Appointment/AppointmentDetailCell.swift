//
//  AppointmentDetailCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class AppointmentDetailCell: UICollectionViewCell {
    
    var appointmentDetailVC:AppointmentDetailVC?
    
    var appointmentData: AppointmentModel?{
        didSet{
            if let data = appointmentData{
                if let docName = data.doctor?.object(forKey: "name") as? String{
                    doctorNameLabel.text = docName
                }
                if let docImage = data.doctor?.object(forKey: "image_url") as? String{
                    UIImage.loadImage(docImage) { (image) in
                        self.doctorImage.image = image
                    }
                }
                
                statusBtn.setTitle("\(data.booking_status)", for: .normal)
                
                switch data.booking_status{
                case .APPROVED:
                    statusBtn.backgroundColor = UIColor.MyanCareColor.green
                case .COMPLETED:
                    statusBtn.backgroundColor = UIColor.MyanCareColor.green
                case .REJECTED:
                    statusBtn.backgroundColor = UIColor.red
                case .PENDING:
                    statusBtn.backgroundColor = UIColor.MyanCareColor.yellow
                case .RESCHEDULE_BY_PATIENT, .RESCHEDULE_BY_DOCTOR:
                    scheduleLabel.text = "Reschedule Date/Time"
                    statusBtn.backgroundColor = UIColor.MyanCareColor.yellow
                default:
                    statusBtn.backgroundColor = UIColor.gray
                }
                
                if let patientName = data.patient?.object(forKey: "name") as? String{
                    patientNameLabel.text = patientName
                }

                dateNameLabel.text = UtilityClass.getDateTimeStringFromUTC(data.date_of_issue!)
                reasonDataLabel.text = "- \(data.reason!)"
                serviceUnitLabel.text = "-"
                serviceTypeLabel.text = data.type!.uppercased()
                totalAmountDataLabel.text = "\(data.total_appointment_fees!) coin"
                
                let dFormatter = DateFormatter()
                dFormatter.dateFormat = "dd-MMM-yyyy h:mm a"
                let startDate = Date(milliseconds: data.slotStartTime!)
                scheduleDataLabel.text = dFormatter.string(from: startDate)
                
                if (data.type?.contains("chat"))!{
                    serviceUnitLabel.text = "3 days"
                } else {
                    serviceUnitLabel.text = "45min (max)"
                }
            }
        }
    }
    
    let bgView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    
    lazy var doctorImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = UIColor.gray
        img.layer.cornerRadius = 25 //size 50
        img.clipsToBounds = true
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(showDoctorDetail)))
        return img
    }()
    
    @objc func showDoctorDetail(){
        if let docID = appointmentData?.doctor?.object(forKey: "id") as? String{
            let doctorDetailVC = DoctorDetailVC(collectionViewLayout:UICollectionViewFlowLayout())
            doctorDetailVC.doctorID = docID

            appointmentDetailVC?.navigationController?.pushViewController(doctorDetailVC, animated: true)
        }
    }
    
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
        v.backgroundColor = UIColor.lightGray
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
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let lineView2: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
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
        v.backgroundColor = UIColor.lightGray
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
        v.backgroundColor = UIColor.lightGray
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
        btn.addTarget(self, action: #selector(medicalRecordBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func medicalRecordBtnClick(){
        appointmentDetailVC?.navigationController?.pushViewController(RecordBookVC(), animated: true)
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
        reasonDataLabel.anchor(reasonLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
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
