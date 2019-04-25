//
//  ReasonImageCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class ReasonImageCell: UICollectionViewCell {
    
    var reasonVC : ReasonVC?
    var index: Int?
    
    let selectedImage: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.gray
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    lazy var icon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "icons8-add")?.withRenderingMode(.alwaysTemplate)
        img.tintColor = UIColor.white
        img.contentMode = .scaleAspectFill
        img.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(iconClick)))
        img.isUserInteractionEnabled = true
        return img
    }()
    
    @objc func iconClick(){
        reasonVC?.selectedIndex = index!
        reasonVC?.showSourceOption()
    }
    
    func setupViews(){
        addSubview(selectedImage)
        addSubview(icon)
        
        selectedImage.fillSuperview()
        icon.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        icon.anchorCenterSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
