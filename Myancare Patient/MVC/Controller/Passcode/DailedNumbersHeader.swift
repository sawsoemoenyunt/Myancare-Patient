//
//  DailedNumbersHeader.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/18/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class DialedNumbersHeader: UICollectionReusableView {
    
    let numbersLabel = UILabel()
    
    lazy var dot1:UIView = {
        let dot = UIView()
        dot.backgroundColor = UIColor.white
        dot.layer.borderColor = UIColor.gray.cgColor
        dot.layer.borderWidth = 1
        dot.layer.cornerRadius = 7.5
        dot.layer.masksToBounds = true
        return dot
    }()
    
    lazy var dot2:UIView = {
        let dot = UIView()
        dot.backgroundColor = UIColor.white
        dot.layer.borderColor = UIColor.gray.cgColor
        dot.layer.borderWidth = 1
        dot.layer.cornerRadius = 7.5
        dot.layer.masksToBounds = true
        return dot
    }()
    
    let dot3:UIView = {
        let dot = UIView()
        dot.backgroundColor = UIColor.white
        dot.layer.borderColor = UIColor.gray.cgColor
        dot.layer.borderWidth = 1
        dot.layer.cornerRadius = 7.5
        dot.layer.masksToBounds = true
        return dot
    }()
    
    let dot4:UIView = {
        let dot = UIView()
        dot.backgroundColor = UIColor.white
        dot.layer.borderColor = UIColor.gray.cgColor
        dot.layer.borderWidth = 1
        dot.layer.cornerRadius = 7.5
        dot.layer.masksToBounds = true
        return dot
    }()
    
    let dotView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        numbersLabel.text = "Enter Passcode"
        numbersLabel.font = UIFont.systemFont(ofSize: 32)
        numbersLabel.textAlignment = .center
        numbersLabel.adjustsFontSizeToFitWidth = true
        numbersLabel.numberOfLines = 0
        addSubview(numbersLabel)
        numbersLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 40, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        addSubview(dotView)
        dotView.anchor(numbersLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 30)
        dotView.anchorCenterXToSuperview()
        
        dotView.addSubview(dot1)
        dotView.addSubview(dot2)
        dotView.addSubview(dot3)
        dotView.addSubview(dot4)
        
        dot1.anchor(dotView.topAnchor, left: dotView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 15, heightConstant: 15)
        dot2.anchor(dotView.topAnchor, left: dot1.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 15, heightConstant: 15)
        dot3.anchor(dotView.topAnchor, left: dot2.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 15, heightConstant: 15)
        dot4.anchor(dotView.topAnchor, left: dot3.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 15, heightConstant: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}

