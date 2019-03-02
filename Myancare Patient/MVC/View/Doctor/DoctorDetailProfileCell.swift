//
//  DoctorDetailProfileCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class DoctorDetailProfileCell: UICollectionViewCell {
    
    var doctorDetailViewController: DoctorDetailVC?
    
    let profileImage: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 115, height: 115))
        img.image = #imageLiteral(resourceName: "pablo-profile")
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 57.5
        img.clipsToBounds = true
        return img
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dr.Steve Jobs"
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return lbl
    }()
    
    let specializeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Specialization"
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        //        lbl.textColor = UIColor.gray
        return lbl
    }()
    
    let experienceLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "8 Years of Experience"
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.textColor = UIColor.gray
        return lbl
    }()
    
    lazy var bookBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("BOOK APPOINTMENT", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(red:0.54, green:0.77, blue:0.45, alpha:1) //green
        btn.layer.cornerRadius = 25 //height 50
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(bookBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func bookBtnClick(){
        bookBtn.isHidden = true
        addSubview(chatBtn)
        addSubview(voiceBtn)
        addSubview(videoBtn)
        
        let btnWidth = self.frame.width/3 - 30
        chatBtn.anchor(experienceLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 39, bottomConstant: 0, rightConstant: 0, widthConstant: btnWidth, heightConstant: 50)
        voiceBtn.anchor(experienceLabel.bottomAnchor, left: self.chatBtn.rightAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: btnWidth, heightConstant: 50)
        videoBtn.anchor(experienceLabel.bottomAnchor, left: self.voiceBtn.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 12, leftConstant: 8, bottomConstant: 0, rightConstant: 39, widthConstant: btnWidth, heightConstant: 50)
    }
    
    lazy var voiceBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Voice", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(red:0.4, green:0.4, blue:0.4, alpha:1) //yellow
        btn.layer.cornerRadius = 25 //height 50
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var videoBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Video", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(red:0.82, green:0.31, blue:0.16, alpha:1) //orange
        btn.layer.cornerRadius = 25 //height 50
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var chatBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Chat", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(red:0.54, green:0.77, blue:0.45, alpha:1) //green
        btn.layer.cornerRadius = 25 //height 50
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(chatBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func chatBtnClick(){
        doctorDetailViewController?.navigationController?.pushViewController(BookAppointmentViewController(), animated: true)
    }
    
    func setupViews(){
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(specializeLabel)
        addSubview(experienceLabel)
        addSubview(bookBtn)
        
        profileImage.anchor(self.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 115, heightConstant: 115)
        profileImage.anchorCenterXToSuperview()
        nameLabel.anchor(profileImage.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 4, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        specializeLabel.anchor(nameLabel.bottomAnchor, left: nameLabel.leftAnchor, bottom: nil, right: nameLabel.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        experienceLabel.anchor(specializeLabel.bottomAnchor, left: specializeLabel.leftAnchor, bottom: nil, right: specializeLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        bookBtn.anchor(experienceLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 12, leftConstant: 39, bottomConstant: 0, rightConstant: 39, widthConstant: 0, heightConstant: 50)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
