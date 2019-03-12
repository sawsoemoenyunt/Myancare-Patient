//
//  DoctorSearchSpecializationCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class DoctorSearchSpecializationCell: UICollectionViewCell {
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .white
        img.layer.borderColor = UIColor.lightGray.cgColor
        img.layer.borderWidth = 0.5
        img.clipsToBounds = true
        return img
    }()
    
    let title: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sp1"
        lbl.textColor = UIColor(red:0.6, green:0.6, blue:0.6, alpha:1) //lihgt gray
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 11)
        return lbl
    }()
    
    func setupViews(){
        
        addSubview(icon)
        addSubview(title)
        
        title.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 2, bottomConstant: 14, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        icon.anchor(nil, left: nil, bottom: title.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 66, heightConstant: 66)
        icon.anchorCenterXToSuperview()
        
        //circle icon
        icon.layer.cornerRadius = 33
        icon.clipsToBounds = true
        
        
        //background color
        self.backgroundColor = UIColor.white
        
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                icon.layer.borderWidth = 4
                icon.layer.borderColor = UIColor(red:0.82, green:0.31, blue:0.16, alpha:1).cgColor
            } else {
                icon.layer.borderWidth = 0.5
                icon.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    }
    
    override var isHighlighted: Bool{
        didSet{
            if isHighlighted{
                UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.transform = self.transform.scaledBy(x: 0.85, y: 0.85)
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                }, completion: nil)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
