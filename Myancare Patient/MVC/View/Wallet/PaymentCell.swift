//
//  PaymentCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class PaymentCell: UICollectionViewCell {
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .white
        img.layer.cornerRadius = 25 //size 50
        img.layer.borderColor = UIColor.gray.cgColor
        img.layer.borderWidth = 0.5
        img.clipsToBounds = true
        return img
    }()
    
    let gateWayNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Payment Gateway"
        lbl.font = UIFont.mmFontRegular(ofSize: 12)
        lbl.textColor = UIColor.black
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        return lbl
    }()
    
    let autoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Auto"
        lbl.font = UIFont.mmFontRegular(ofSize: 8)
        lbl.textColor = UIColor.gray
        lbl.textAlignment = .center
        return lbl
    }()
    
    func setupViews(){
        addSubview(icon)
        addSubview(gateWayNameLabel)
        addSubview(autoLabel)
        
        icon.anchor(topAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        icon.anchorCenterXToSuperview()
        gateWayNameLabel.anchor(icon.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 2, leftConstant: 4, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        autoLabel.anchor(gateWayNameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        
        autoLabel.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
