//
//  DoctorDetailAdditionCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class DoctorDetailAdditionCell: UICollectionViewCell{
    
    let iconImage: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "icons8-medical_heart")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Title"
        //        lbl.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lbl.font = UIFont.MyanCareFont.type2
        return lbl
    }()
    
    let bodyLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "-"
        //        lbl.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lbl.font = UIFont.MyanCareFont.type4
        lbl.numberOfLines = 0
        //        lbl.textColor = UIColor.gray
        return lbl
    }()
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    func setupViews(){
        addSubview(iconImage)
        addSubview(bgView)
        addSubview(lineView)
        
        iconImage.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24)
        bgView.anchor(self.topAnchor, left: iconImage.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 8, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        lineView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0.5)
        
        bgView.addSubview(titleLabel)
        bgView.addSubview(bodyLabel)
        titleLabel.anchor(self.topAnchor, left: bgView.leftAnchor, bottom: nil, right: bgView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        bodyLabel.anchor(titleLabel.bottomAnchor, left: bgView.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


