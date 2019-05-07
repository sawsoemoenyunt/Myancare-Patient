//
//  ArticleCategoryCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

//cell for article category list
class ArticleCategoryCell: UICollectionViewCell {
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "no-image")
        img.backgroundColor = .gray
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    func setupViews(){
        addSubview(icon)
        icon.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 4, bottomConstant: 10, rightConstant: 4, widthConstant: 0, heightConstant: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
