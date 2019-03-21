//
//  ChatRecordCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class ChatRecordCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Sometljsdfj sdf"
        tv.font = UIFont.MyanCareFont.type4
        tv.backgroundColor = .clear
        tv.textColor = .white
        return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.MyanCareColor.lightGray
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "pablo-profile")
        img.layer.cornerRadius = 16
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    var bubbleViewConstraints = [NSLayoutConstraint]()
    
    static let greenColor = UIColor.MyanCareColor.green
    
    func setupViews() {
        self.backgroundColor = .white
        
        addSubview(bubbleView)
        addSubview(profileImageView)
        bubbleView.addSubview(textView)
        
        bubbleViewConstraints = bubbleView.anchorWithReturnAnchors(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 48, bottomConstant: 0, rightConstant: 8, widthConstant: 200, heightConstant: 0)
        profileImageView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 32)
        
        textView.anchor(bubbleView.topAnchor, left: bubbleView.leftAnchor, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

