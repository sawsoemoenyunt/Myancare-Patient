//
//  NotiListCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

///UICollectionViewCell for notification list
class NotiCell: UICollectionViewCell {
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let noteLabel: UITextView = {
        let lbl = UITextView()
        lbl.text = "Your next appointment with Dr.Henry is in 5 mins"
        lbl.textAlignment = .left
        lbl.isUserInteractionEnabled = false
        lbl.font = UIFont.mmFontRegular(ofSize: 14)
        lbl.textColor = UIColor.black
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
        
        icon.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        icon.anchorCenterYToSuperview()
        dateLabel.anchor(nil, left: icon.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        noteLabel.anchor(topAnchor, left: icon.rightAnchor, bottom: dateLabel.topAnchor, right: rightAnchor, topConstant: 4, leftConstant: 16, bottomConstant: 4, rightConstant: 4, widthConstant: 0, heightConstant: 0)
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
