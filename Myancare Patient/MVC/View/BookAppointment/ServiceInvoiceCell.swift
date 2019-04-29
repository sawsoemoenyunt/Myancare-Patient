//
//  ServiceInvoiceCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/23/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class ServiceInvoiceCell: UICollectionViewCell {
    
    var invoiceVC: InvoiceViewController?
    
    var appointmentData: BookAppointmentModel?{
        didSet{
            if let data = appointmentData{
                doctorNameLabel.text = data.doctor_name
                dateIssueDataLabel.text = UtilityClass.getDateTimeStringFromUTC(data.date_of_issue_utc!)
                
                if appointmentData?.type == "chat"{
                    appointmentDateDataLabel.text = UtilityClass.getDateTimeStringFromUTC(data.date_of_issue_utc!)
                } else {
                    let dFormatter = DateFormatter()
                    dFormatter.dateFormat = "dd-MMM-yyyy h:mm a"
                    let startDate = Date(milliseconds: data.slotStartTime!)
                    appointmentDateDataLabel.text = dFormatter.string(from: startDate)
                }
                
                serviceUnitDataLabel.text = "-"
                serviceTypeDataLabel.text = data.type?.uppercased()
                totalAmountDataLabel.text = "\(data.total_appointment_fees!) Coin"
                reasonDataLabel.text = data.reason
            }
        }
    }
    
    let doctorNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dr.John Doe"
        lbl.font = UIFont.MyanCareFont.subtitle1
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    let dateIssueLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Date of Issue:"
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.MyanCareColor.gray
        return lbl
    }()
    
    let dateIssueDataLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "25 Feb 2019 | 14:50 PM"
        lbl.font = UIFont.MyanCareFont.type8
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let appointmentDateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Appointment Date/Time:"
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.MyanCareColor.gray
        return lbl
    }()
    
    let appointmentDateDataLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "-"
        lbl.font = UIFont.MyanCareFont.type8
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let lineView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    let lineViewVertical: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    let serviceUnitLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Service Unit"
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.gray
        return lbl
    }()
    
    let serviceTypeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Service Type"
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.gray
        return lbl
    }()
    
    let serviceUnitDataLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "15 min ( max )"
        lbl.font = UIFont.MyanCareFont.type7
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    let serviceTypeDataLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "VOICE"
        lbl.font = UIFont.MyanCareFont.type7
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    let lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    let totalAmountLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Total Amount"
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.gray
        return lbl
    }()
    
    let totalAmountDataLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "2,400 Coin"
        lbl.font = UIFont.MyanCareFont.title
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    let lineView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    let reasonLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Reason for Visit:"
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.gray
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let reasonDataLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "ဘာဖြစ်မုန်းမသိလို့ဆရာကိုပြချင်တာပါ။ စကားပြောပြီးရင် အကုန်သိ သွားပါလိမ့်မယ်"
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let lineView4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    lazy var promoCodeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Promo Code"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    lazy var applyBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("APPLY", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button1
        btn.backgroundColor = UIColor.MyanCareColor.yellow
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(applyBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func applyBtnClick(){
        
        let promoString = promoCodeTextField.text
        
        if promoString == ""{
            invoiceVC?.showAlert(title: "Invalid", message: "Please enter promo code")
            
        } else {
            invoiceVC?.getCoupon(couponID: promoString!)
        }
    }
    
    let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "အတည်ပြုပြီးလျင် ချိန်းဆိုချက်ပျက်ကွက်မူဆိုင်ရာမူဝါဒကိုဖတ်ရူလက်ခံပြီးသည် ဟုမှတ်ယူပါမည်"
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.red
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    func setupViews(){
        addSubview(doctorNameLabel)
        addSubview(dateIssueLabel)
        addSubview(dateIssueDataLabel)
        addSubview(appointmentDateLabel)
        addSubview(appointmentDateDataLabel)
        addSubview(lineView1)
        addSubview(serviceUnitLabel)
        addSubview(serviceTypeLabel)
        addSubview(serviceUnitDataLabel)
        addSubview(serviceTypeDataLabel)
        addSubview(lineViewVertical)
        addSubview(lineView2)
        addSubview(totalAmountLabel)
        addSubview(totalAmountDataLabel)
        addSubview(lineView3)
        addSubview(reasonLabel)
        addSubview(reasonDataLabel)
        addSubview(lineView4)
        addSubview(infoLabel)
        addSubview(promoCodeTextField)
        addSubview(applyBtn)
        
        doctorNameLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        dateIssueLabel.anchor(doctorNameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        dateIssueDataLabel.anchor(doctorNameLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 30, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        appointmentDateLabel.anchor(dateIssueLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        appointmentDateDataLabel.anchor(dateIssueLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 30, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        lineView1.anchor(appointmentDateLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        lineViewVertical.anchor(lineView1.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0.5, heightConstant: 100)
        lineViewVertical.anchorCenterXToSuperview()
        lineView2.anchor(lineViewVertical.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        serviceUnitLabel.anchor(lineView1.bottomAnchor, left: leftAnchor, bottom: nil, right: lineViewVertical.leftAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        serviceUnitDataLabel.anchor(serviceUnitLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: lineViewVertical.leftAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        serviceTypeLabel.anchor(lineView1.bottomAnchor, left: lineViewVertical.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        serviceTypeDataLabel.anchor(serviceTypeLabel.bottomAnchor, left: lineViewVertical.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        totalAmountLabel.anchor(lineView2.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        totalAmountDataLabel.anchor(totalAmountLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        lineView3.anchor(totalAmountDataLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        reasonLabel.anchor(lineView3.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        reasonDataLabel.anchor(reasonLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        lineView4.anchor(reasonDataLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        applyBtn.anchor(lineView4.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 100, heightConstant: 40)
        promoCodeTextField.anchor(lineView4.bottomAnchor, left: leftAnchor, bottom: nil, right: applyBtn.leftAnchor, topConstant: 30, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 40)
        
        infoLabel.anchor(promoCodeTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 30, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }
    
    override func layoutSubviews() {
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 6
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
