//
//  AppointmentListCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class AppointmentListCell: UICollectionViewCell {
    
    var appointmentData: AppointmentModel?{
        didSet{
            if let data = appointmentData{
                if let docName = data.doctor?.object(forKey: "name") as? String{
                    doctorNameLabel.text = docName
                }
                if let docImage = data.doctor?.object(forKey: "image_url") as? String{
//                    UIImage.loadImage(docImage) { (image) in
//                        self.profileImage.image = image
//                        return
//                    }
                    self.profileImage.loadImage(urlString: docImage)
                }
                
                let startTime : UnixTime = data.slotStartTime! / 1000
                dateLabel.text = "\(startTime.dateTime)"
                typeBtn.setTitle("\(data.type!)", for: .normal)
                conditionBtn.setTitle("\(data.booking_status)", for: .normal)
                
                switch data.booking_status{
                case .PENDING:
                    conditionBtn.backgroundColor = UIColor.MyanCareColor.blue
                    break
                case .REJECTED:
                    conditionBtn.backgroundColor = UIColor.red
                    break
                case .RESCHEDULE_BY_PATIENT, .RESCHEDULE_BY_DOCTOR:
                    conditionBtn.backgroundColor = UIColor.MyanCareColor.yellow
                    break
                case .APPROVED, .COMPLETED:
                    conditionBtn.backgroundColor = UIColor.MyanCareColor.green
                    break
                default:
                    conditionBtn.backgroundColor = UIColor.gray
                    break
                }
            }
        }
    }
    
    let profileImage: CachedImageView = {
        let img = CachedImageView()
        img.image = UIImage(named: "no-image")
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 32
        img.layer.borderWidth = 0.5
        img.layer.borderColor = UIColor.MyanCareColor.darkGray.cgColor
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
        btn.setTitleColor(UIColor.white, for: .normal)
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
        conditionBtn.anchor(doctorNameLabel.bottomAnchor, left: typeBtn.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 90, heightConstant: 20)
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
