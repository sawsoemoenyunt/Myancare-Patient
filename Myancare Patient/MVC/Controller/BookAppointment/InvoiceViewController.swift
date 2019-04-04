//
//  InvoiceViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/23/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class InvoiceViewController: UIViewController, NVActivityIndicatorViewable{
    
    let bgView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1) //light gray
        return view
    }()
    
    let doctorNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dr.John Doe"
        lbl.textAlignment = .center
        lbl.font = UIFont.mmFontBold(ofSize: 28)
        return lbl
    }()
    
    let dateIssueLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "today date"
        lbl.textAlignment = .center
        lbl.font = UIFont.mmFontRegular(ofSize: 12)
        return lbl
    }()
    
    let scheduleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Scheduled Date/Time:"
        lbl.textAlignment = .left
        lbl.font = UIFont.mmFontRegular(ofSize: 12)
        return lbl
    }()
    
    let verticalLine: UIView = {
            let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
        }()
    
    let reasonLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Reason for visit:"
        lbl.textAlignment = .left
        lbl.font = UIFont.mmFontRegular(ofSize: 12)
        return lbl
    }()
    
    let scheduleDataLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "20 Feb 2019 | 6:00 PM"
        lbl.textAlignment = .left
        lbl.font = UIFont.mmFontBold(ofSize: 12)
        return lbl
    }()
    
    let reasonDataLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sick"
        lbl.textAlignment = .left
        lbl.font = UIFont.mmFontBold(ofSize: 12)
        return lbl
    }()
    
    let dottedLine1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let dottedLine2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let dottedLine3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let unitLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Service Unit"
        lbl.textAlignment = .left
        lbl.font = UIFont.mmFontRegular(ofSize: 12)
        return lbl
    }()
    
    let typeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Service Type"
        lbl.textAlignment = .left
        lbl.font = UIFont.mmFontRegular(ofSize: 12)
        return lbl
    }()
    
    let unitDataLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "15 min (max)"
        lbl.textAlignment = .left
        lbl.font = UIFont.mmFontBold(ofSize: 16)
        return lbl
    }()
    
    let typeDataLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "VOICE"
        lbl.textAlignment = .left
        lbl.font = UIFont.mmFontBold(ofSize: 16)
        return lbl
    }()
    
    let totalLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Total Amount"
        lbl.textAlignment = .center
        lbl.font = UIFont.mmFontRegular(ofSize: 14)
        return lbl
    }()
    
    let totalDataLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "2400.00 Coin"
        lbl.textAlignment = .center
        lbl.font = UIFont.mmFontBold(ofSize: 32)
        return lbl
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("CONFIRM", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 25 //height 50
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(confirmBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func confirmBtnClick(){
        sendBooking()
//        self.navigationController?.pushViewController(ShareBookVC(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Service Invoice"
        
        setupViews()
        setupData()
    }
    
    func setupData(){
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateOfIssue = formatter.string(from: date)
        
        doctorNameLabel.text = bookAppointmentData.doctor_name
        dateIssueLabel.text = "Date of issue \(dateOfIssue)"
        scheduleDataLabel.text = bookAppointmentData.date_of_issue_utc
        reasonDataLabel.text = bookAppointmentData.reason
        typeDataLabel.text = bookAppointmentData.type?.uppercased()
        totalDataLabel.text = "\(bookAppointmentData.total_appointment_fees!) coin"
    }
    
    func setupViews(){
        
        view.addSubview(bgView)
        bgView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 460)
        
        bgView.addSubview(doctorNameLabel)
        bgView.addSubview(dateIssueLabel)
        bgView.addSubview(scheduleLabel)
        bgView.addSubview(scheduleDataLabel)
        bgView.addSubview(verticalLine)
        bgView.addSubview(reasonLabel)
        bgView.addSubview(reasonDataLabel)
        bgView.addSubview(dottedLine1)
        bgView.addSubview(unitLabel)
        bgView.addSubview(unitDataLabel)
        bgView.addSubview(typeLabel)
        bgView.addSubview(typeDataLabel)
        bgView.addSubview(dottedLine2)
        bgView.addSubview(totalLabel)
        bgView.addSubview(totalDataLabel)
        bgView.addSubview(dottedLine3)
        bgView.addSubview(confirmBtn)
        
        doctorNameLabel.anchor(bgView.topAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        dateIssueLabel.anchor(doctorNameLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        scheduleLabel.anchor(dateIssueLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: view.frame.width/2 - 40, heightConstant: 0)
        scheduleDataLabel.anchor(scheduleLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        verticalLine.anchor(dateIssueLabel.bottomAnchor, left: scheduleLabel.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 1, heightConstant: 60)
        reasonLabel.anchor(dateIssueLabel.bottomAnchor, left: verticalLine.rightAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        reasonDataLabel.anchor(reasonLabel.bottomAnchor, left: verticalLine.rightAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        dottedLine1.anchor(verticalLine.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        unitLabel.anchor(dottedLine1.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        unitDataLabel.anchor(unitLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: bgView.frame.width/2, heightConstant: 0)
        typeLabel.anchor(dottedLine1.bottomAnchor, left: verticalLine.rightAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        typeDataLabel.anchor(typeLabel.bottomAnchor, left: typeLabel.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        dottedLine2.anchor(unitDataLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        totalLabel.anchor(dottedLine2.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        totalDataLabel.anchor(totalLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        dottedLine3.anchor(totalDataLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        confirmBtn.anchor(nil, left: nil, bottom: bgView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: -25, rightConstant: 0, widthConstant: 120, heightConstant: 50)
        confirmBtn.anchorCenterXToSuperview()
    }
}

extension InvoiceViewController{
    
    func sendBooking(){
        self.startAnimating()
        let url = EndPoints.appointmentCreate.path
        let params = ["doctor": bookAppointmentData.doctor!,
                      "type" : bookAppointmentData.type!,
                      "date_of_issue" : bookAppointmentData.date_of_issue!,
                      "amount" : bookAppointmentData.amount!,
                      "service_fees" : bookAppointmentData.service_fees!,
                      "total_appointment_fees" : bookAppointmentData.total_appointment_fees!,
                      "slotStartTime" : bookAppointmentData.slotStartTime!,
                      "slotEndTime" : bookAppointmentData.slotEndTime!,
                      "date_of_issue_utc" : bookAppointmentData.date_of_issue_utc!,
                      "slot" : bookAppointmentData.slot!,
                      "reason" : bookAppointmentData.reason!] as [String:Any]
        let heads = ["Authorization" : "\(jwtTkn)"]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                if responseStatus == 201 || responseStatus == 200{
                    print("SUccess booking")
                    if let responseDict = response.result.value as? NSDictionary{
                        if let recordBookID = responseDict.object(forKey: "recordBook") as? String{
                            let alert = UIAlertController(title: "Success", message: "Your booking for appointment was successfully created!", preferredStyle: UIAlertController.Style.alert)
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                self.uploadSheets(recordBookID)
                            }))
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    print("Failed booking")
                    print(response.result.value as Any)
                    
                    var messageString = "An error occur. You appointment was failed to book."
                    if let responseDict = response.result.value as? NSDictionary{
                        if let message = responseDict.object(forKey: "message") as? String{
                            messageString = message
                        }
                    }
                    self.showAlert(title: "Failed", message: messageString)
                }
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
    func uploadSheets(_ recordBookID:String){
        let url = EndPoints.addSheet.path
        imageKeys.removeAll {$0 == ""}
        let params = ["medicalbook_id" : recordBookID,
        "image" : imageKeys] as [String:Any]
        let heads = ["Authorization":"\(jwtTkn)"]
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            print(response.result.value as Any)
            
            let shareVC = ShareBookVC()
            shareVC.doctorID = bookAppointmentData.doctor!
            self.navigationController?.pushViewController(shareVC, animated: true)
            //doctor_id
            //medical_record_book
        }
        
    }
}
