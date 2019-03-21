//
//  MoreCollectionViewEditProfileCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

//morevcollectionview view and edit profile cell
class MoreCollectionViewEditProfileCell: UICollectionViewCell {
    
    let namelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Pablo Escobar"
        lbl.font = UIFont.MyanCareFont.type1
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "View & Edit Profile"
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = UIColor.gray
        return lbl
    }()
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = #imageLiteral(resourceName: "pablo-profile")
        return img
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    func setupViews(){
        backgroundColor = .white
        
        addSubview(namelabel)
        addSubview(label)
        addSubview(icon)
        addSubview(lineView)
        
        icon.anchor(nil, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 50, heightConstant: 50)
        label.anchor(nil, left: self.leftAnchor, bottom: icon.bottomAnchor, right: icon.leftAnchor, topConstant: 0, leftConstant: 14, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        namelabel.anchor(icon.topAnchor, left: self.leftAnchor, bottom: nil, right: icon.leftAnchor, topConstant: 0, leftConstant: 14, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        icon.anchorCenterYToSuperview()
        lineView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 14, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0.5)
        
        //circle icon
        icon.layer.cornerRadius = 25
        icon.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



