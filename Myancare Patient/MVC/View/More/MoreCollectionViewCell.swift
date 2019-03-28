//
//  MoreCollectionViewCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

//morevcollectionview cell
class MoreCollectionViewCell: UICollectionViewCell {
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "Notifications & settings"
        lbl.font = UIFont.MyanCareFont.type2unbold
        return lbl
    }()
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = #imageLiteral(resourceName: "icons8-stopwatch")
        return img
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let swLangauge: UISwitch = {
        let sw = UISwitch()
        return sw
    }()
    
    func setupViews(){
        backgroundColor = .white
        
        addSubview(label)
        addSubview(icon)
        addSubview(lineView)
        addSubview(swLangauge)
        
        icon.anchor(nil, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 14, widthConstant: 25, heightConstant: 25)
        label.anchor(nil, left: self.leftAnchor, bottom: nil, right: icon.leftAnchor, topConstant: 0, leftConstant: 14, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        icon.anchorCenterYToSuperview()
        label.anchorCenterYToSuperview()
        lineView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 14, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0.5)
        
        //add switch to view
        swLangauge.anchor(nil, left: nil
            , bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 14, widthConstant: 0, heightConstant: 0)
        swLangauge.anchorCenterYToSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
