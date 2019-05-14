//
//  PhotoGalleryCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class PhotoGalleryCell: UICollectionViewCell {
    
    let imageView: CachedImageView = {
        let img = CachedImageView()
        img.backgroundColor = UIColor.gray
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    func setupViews(){
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PhotoGalleryHeaderCell: UICollectionReusableView {
    
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "12 Feb,2019"
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    func setupViews(){
        addSubview(dateLabel)
        dateLabel.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
