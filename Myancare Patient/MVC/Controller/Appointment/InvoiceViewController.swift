//
//  InvoiceViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/23/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class InvoiceViewController: UIViewController {
    
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
        lbl.text = "Dr.John Doe"
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
        btn.tintColor = .white
        btn.backgroundColor = UIColor(red:0.54, green:0.77, blue:0.45, alpha:1) //green
        btn.layer.cornerRadius = 25 //height 50
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(confirmBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func confirmBtnClick(){
        self.navigationController?.pushViewController(ShareBookVC(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Service Invoice"
        
        setupViews()
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
