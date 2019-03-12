//
//  WalletCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class WalletCell: UICollectionViewCell {
    
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "dd-MMM-yy"
        lbl.numberOfLines = 1
        lbl.font = UIFont.mmFontRegular(ofSize: 12)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let noteLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "transaction note here"
        lbl.numberOfLines = 0
        lbl.font = UIFont.mmFontRegular(ofSize: 12)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let verticallineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    func setupViews(){
        addSubview(dateLabel)
        addSubview(noteLabel)
        addSubview(verticallineView)
        addSubview(circleView)
        
        dateLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 14, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 0)
        circleView.anchor(topAnchor, left: dateLabel.rightAnchor, bottom: nil, right: nil, topConstant: 14, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 22, heightConstant: 22)
        verticallineView.anchor(topAnchor, left: circleView.leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 11, bottomConstant: 0, rightConstant: 0, widthConstant: 1, heightConstant: 0)
        noteLabel.anchor(topAnchor, left: circleView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 14, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
