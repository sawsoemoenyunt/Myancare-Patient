//
//  NotiListCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Localize_Swift

///UICollectionViewCell for notification list
class NotiCell: UICollectionViewCell {
    
    var notiData:NotificationModel?{
        didSet{
            if let data = notiData{
                let body = Localize.currentLanguage() == "en" ? data.message_en! : data.message_my!
                let title = Localize.currentLanguage() == "en" ? data.title_en! : data.title_my!
                self.setupAttributeString(title, body: body)
                
                dateLabel.text = data.createdAt!
                icon.image = UIImage.init(named: "icons8-alarm_clock")?.withRenderingMode(.alwaysTemplate)
                
                let notiTypeString = data.notification_type!.rawValue
                if notiTypeString.contains("rejected") || notiTypeString.contains("cancel"){
                    icon.tintColor = UIColor.red
                    
                } else if notiTypeString.contains("reschedule"){
                    icon.tintColor = UIColor.MyanCareColor.yellow
                    
                } else {
                    icon.tintColor = UIColor.MyanCareColor.green
                }
            }
        }
    }
    
    func setupAttributeString(_ title:String, body:String){
        let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.MyanCareFont.chip]
        let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.MyanCareFont.type3]
        
        let title1 = NSMutableAttributedString(string: "\(title) • ", attributes: yourAttributes)
        let body1 = NSMutableAttributedString(string: "\(body)", attributes: yourOtherAttributes)
        
        let combination = NSMutableAttributedString()
        
        combination.append(title1)
        combination.append(body1)
        noteLabel.attributedText = combination
    }
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let noteLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Your next appointment with Dr.Henry is in 5 mins"
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.black
        lbl.numberOfLines = 3
        return lbl
    }()
    
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "25 Feb 2019 | 14:50 PM"
        lbl.font = UIFont.mmFontRegular(ofSize: 12)
        lbl.textColor = UIColor.gray
        return lbl
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    func setupViews(){
        addSubview(icon)
        addSubview(noteLabel)
        addSubview(dateLabel)
        addSubview(lineView)
        
        icon.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 4, leftConstant: 6, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        dateLabel.anchor(nil, left: icon.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        noteLabel.anchor(topAnchor, left: icon.rightAnchor, bottom: dateLabel.topAnchor, right: rightAnchor, topConstant: 6, leftConstant: 16, bottomConstant: 4, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        lineView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
