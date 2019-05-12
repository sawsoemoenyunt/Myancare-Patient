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

class InvoiceViewController: UIViewController, NVActivityIndicatorViewable, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let cellID = "cellID"
    var discount_value = 0
    var discount_percent = 0
    var couponCode = ""
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        return cv
    }()
    
    let bgView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1) //light gray
        return view
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    func setupViews(){
        view.addSubview(collectionView)
        view.addSubview(confirmBtn)
        
        let v = view.safeAreaLayoutGuide
        confirmBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: confirmBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        collectionView.register(ServiceInvoiceCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ServiceInvoiceCell
        cell.invoiceVC = self
        cell.appointmentData = bookAppointmentData
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedReasonHeight = self.view.calculateHeightofTextView(dummyText: bookAppointmentData.reason!, fontSize: 16, viewWdith: self.view.frame.width)
        return CGSize(width: collectionView.frame.width, height: 600 + estimatedReasonHeight + 180)
    }
}

extension InvoiceViewController{
    
    func getCoupon(couponID:String){
        self.startAnimating()
        let url = EndPoints.getCoupon(couponID.replacingOccurrences(of: " ", with: "")).path
        let heads = ["Authorization" : "\(jwtTkn)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                if responseStatus == 201 || responseStatus == 200{
                    
                    if let responseData = response.result.value as? NSDictionary{
                        
                        if let couponCode1 = responseData.object(forKey: "coupon") as? String{
                            bookAppointmentData.coupon = couponCode1
                        }
                        
                        if let value1 = responseData.object(forKey: "value") as? Int{
                            self.discount_value = value1
                        }
                        
                        if let percent1 = responseData.object(forKey: "percent") as? Int{
                            self.discount_percent = percent1
                        }
                        
                        if self.discount_percent > 0 {
                            let discountAmount = bookAppointmentData.total_appointment_fees! * (self.discount_percent/100)
                             bookAppointmentData.discount = bookAppointmentData.total_appointment_fees! - discountAmount
                            
                        } else if self.discount_value > 0{
                            bookAppointmentData.discount = self.discount_value
                        }
                        self.collectionView.reloadData()
                    }
                    
                } else {
                    self.showAlert(title: "An error occured", message: "Invalid Coupon")
                    print("\(responseStatus ?? 0)")
                }
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
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
                      "reason" : bookAppointmentData.reason!,
                      "coupon" : bookAppointmentData.coupon!] as [String:Any]
        let heads = ["Authorization" : "\(jwtTkn)"]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                if responseStatus == 201 || responseStatus == 200{
                    print("SUccess booking")
                    if let responseDict = response.result.value as? NSDictionary{
                        if let recordBookID = responseDict.object(forKey: "recordBook") as? String{
                            let alert = UIAlertController(title: "Success", message: "Your booking for appointment was successfully created".localized(), preferredStyle: UIAlertController.Style.alert)
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
