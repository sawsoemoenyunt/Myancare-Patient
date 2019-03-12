//
//  UserInterestListCel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

//UICollectionViewCell for UserInterest table view cell
class UserInterestCell: UICollectionViewCell {
    
    ///UIImageView : to show icon
    let icon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = UIColor.gray
        img.layer.cornerRadius = 15 //size 30
        img.clipsToBounds = true
        return img
    }()
    
    ///UILabel : to show info
    let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "Urology"
        lbl.font = UIFont.mmFontBold(ofSize: 14)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    ///Setup view and subviews
    func setupViews(){
        addSubview(icon)
        addSubview(label)
        
        icon.anchor(nil, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        icon.anchorCenterYToSuperview()
        label.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 45, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        layer.cornerRadius = 25 //size 50
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        clipsToBounds = true
    }
    
    ///To handle cell selection
    override var isSelected: Bool{
        didSet{
            if isSelected{
                icon.backgroundColor = .white
                backgroundColor = UIColor.MyanCareColor.green
                label.textColor = UIColor.white
                layer.borderWidth = 0
            } else {
                icon.backgroundColor = .gray
                backgroundColor = UIColor.white
                label.textColor = .black
                layer.borderWidth = 1
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
