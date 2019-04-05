//
//  DocotorSpecializeCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/2/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

//specialization cell
class SpecializationCell: UICollectionViewCell {
    
    var specData:SpecializationModel?{
        didSet{
            if let data = specData{
                label.text = data.name!
                
                UIImage.loadImage(data.image!) { (image) in
                    self.icon.image = image
                }
            }
        }
    }
    
    let backView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .white
        img.layer.borderColor = UIColor.lightGray.cgColor
        img.layer.borderWidth = 1 
        img.clipsToBounds = true
        return img
    }()
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "no-image")
        img.backgroundColor = .white
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "SP1"
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = UIFont.MyanCareFont.type2
        return lbl
    }()
    
    func setupViews(){
        addSubview(backView)
        addSubview(label)
        
        backView.anchor(self.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        backView.anchorCenterXToSuperview()
        label.anchor(backView.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        backView.layer.cornerRadius = 50
        backView.clipsToBounds = true
        
        backView.addSubview(icon)
        icon.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 60)
        icon.anchorCenterXToSuperview()
        icon.anchorCenterYToSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

