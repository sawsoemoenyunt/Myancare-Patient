//
//  DoctorDetailProfileCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Localize_Swift

class DoctorDetailProfileCell: UICollectionViewCell {
    
    var buttonWidth:CGFloat?
    var doctorDetailViewController: DoctorDetailVC?
    var stackView: UIStackView?
    
    var docData:DoctorModel?{
        didSet{
            if let data = docData{
                nameLabel.text = data.name!
                specializeLabel.text = data.specialization!
                
                if Localize.currentLanguage() == "en"{
                    experienceLabel.text = "\(data.experience!) Year of Experience"
                } else {
                    experienceLabel.text = "အတွေ့အကြုံ \(data.experience!) နှစ်"
                }
                
                self.profileImage.loadImage(urlString: data.image_url!)
                
                if data.chat_rate! <= 0 {
                    stackView = UIStackView(arrangedSubviews: [voiceBtn, videoBtn])
                } else {
                    stackView = UIStackView(arrangedSubviews: [chatBtn, voiceBtn, videoBtn])
                }
                
                stackView?.axis = .horizontal
                stackView?.distribution = .fillEqually
                stackView?.spacing = 4
                
                self.addSubview(stackView!)
                stackView?.anchor(experienceLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 12, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
                stackView?.isHidden = true
                
            }
        }
    }
    
    func assignAction(_ buttonName:String, button:UIButton){
        
        button.setTitle("\(buttonName)", for: .normal)
        
        switch buttonName {
        case "CHAT":
            button.addTarget(self, action: #selector(chatBtnClick), for: .touchUpInside)
        case "VOICE":
            button.addTarget(self, action: #selector(chatBtnClick), for: .touchUpInside)
        case "VIDEO":
            button.addTarget(self, action: #selector(chatBtnClick), for: .touchUpInside)
        default:
            break
        }
    }
    
    lazy var profileImage: CachedImageView = {
        let img = CachedImageView()
        img.image = UIImage(named: "no-image")
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 57.5
        img.layer.borderColor = UIColor.MyanCareColor.darkGray.cgColor
        img.layer.borderWidth = 0.5
        img.clipsToBounds = true
        return img
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dr.Steve Jobs"
        lbl.textAlignment = .center
        lbl.font = UIFont.MyanCareFont.type1
        return lbl
    }()
    
    let specializeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Specialization"
        lbl.textAlignment = .center
        lbl.font = UIFont.MyanCareFont.chip
        //        lbl.textColor = UIColor.gray
        return lbl
    }()
    
    let experienceLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "8 Years of Experience"
        lbl.textAlignment = .center
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.gray
        return lbl
    }()
    
    lazy var bookBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Book Appointment".localized(), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(red:0.54, green:0.77, blue:0.45, alpha:1) //green
        btn.layer.cornerRadius = 25 //height 50
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont.MyanCareFont.type2
        btn.addTarget(self, action: #selector(bookBtnClick), for: .touchUpInside)
        return btn
    }()
    
    var bookBtnTopAnchor:NSLayoutConstraint?
    var chatBtnTopAnchor:NSLayoutConstraint?
    var voiceBtnTopAnchor:NSLayoutConstraint?
    var videoBtnTopAnchor:NSLayoutConstraint?
    
    @objc func bookBtnClick(){
        bookBtn.isHidden = true
        stackView?.isHidden = false
    }
    
    lazy var voiceBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Voice".localized(), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "icons8-phone").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.flamingo
        btn.titleLabel?.font = UIFont.MyanCareFont.button1
        btn.layer.cornerRadius = 25 //height 50
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(bookVoiceAppointment), for: .touchUpInside)
        return btn
    }()
    
    @objc func bookVoiceAppointment(){
        bookAppointmentData = BookAppointmentModel()
        let bookVC = BookAppointmentViewController()
        if let id = docData?.id!{
            bookAppointmentData.doctor = id
            bookAppointmentData.doctor_name = docData?.name
            bookAppointmentData.type = "voice"
            bookAppointmentData.amount = docData?.voice_rate
            bookVC.consultationType = .voice
            doctorDetailViewController?.navigationController?.pushViewController(bookVC, animated: true)
        }
    }
    
    lazy var videoBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Video".localized(), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "icons8-video_call").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.mantis //orange
        btn.layer.cornerRadius = 25 //height 50
        btn.titleLabel?.font = UIFont.MyanCareFont.button1
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(bookVideoAppointment), for: .touchUpInside)
        return btn
    }()
    
    @objc func bookVideoAppointment(){
        bookAppointmentData = BookAppointmentModel()
        let bookVC = BookAppointmentViewController()
        if let id = docData?.id!{
            bookAppointmentData.doctor = id
            bookAppointmentData.doctor_name = docData?.name
            bookAppointmentData.type = "video"
            bookAppointmentData.amount = docData?.video_rate
            bookVC.consultationType = .video
            doctorDetailViewController?.navigationController?.pushViewController(bookVC, animated: true)
        }
    }
    
    lazy var chatBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Chat".localized(), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "icons8-chat").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.lightSeaGreen //green
        btn.layer.cornerRadius = 25 //height 50
        btn.titleLabel?.font = UIFont.MyanCareFont.button1
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(chatBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func chatBtnClick(){
        let bookVC = ReasonVC()
        bookAppointmentData = BookAppointmentModel()
        if docData?.id != ""{
            bookAppointmentData.doctor = docData?.id
            bookAppointmentData.doctor_name = docData?.name
            bookAppointmentData.type = "chat"
            bookAppointmentData.amount = docData?.chat_rate
            bookAppointmentData.date_of_issue = UtilityClass.getDate()
            bookAppointmentData.date_of_issue_utc = UtilityClass.getUtcDate()
            doctorDetailViewController?.navigationController?.pushViewController(bookVC, animated: true)
        }
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
        bookBtnTopAnchor = bookBtn.anchorWithReturnAnchors(experienceLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 12, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)[0]
        
        chatBtnTopAnchor?.constant = self.frame.width
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
