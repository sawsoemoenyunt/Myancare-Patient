//
//  AmountCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class AmountCell: UICollectionViewCell {
    
    var amountData: ExchangeRateModel?{
        didSet{
            if let data = amountData{
                coinLabel.text = "\(data.coin_amount!) Coin"
                kyatLabel.text = "\(data.kyat_amount!) Kyat"
            }
        }
    }
    
    let coinImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "coin")
        img.contentMode = .scaleAspectFill
        
        return img
    }()
    
    let kyatImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "ks")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let arrowIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "icons8-forward")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let firstView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        return view
    }()
    
    let secondView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        return view
    }()
    
    let coinLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "10,000 Coin"
        lbl.font = UIFont.mmFontRegular(ofSize: 16)
        lbl.textColor = UIColor.black
        lbl.textAlignment = .right
        return lbl
    }()
    
    let kyatLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "16,000 Kyat"
        lbl.font = UIFont.mmFontRegular(ofSize: 16)
        lbl.textColor = UIColor.black
        lbl.textAlignment = .right
        return lbl
    }()
    
    func setupViews(){
        addSubview(firstView)
        addSubview(secondView)
        
        firstView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: self.bounds.width/2 - 4, heightConstant: 0)
        secondView.anchor(topAnchor, left: firstView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        firstView.addSubview(coinImage)
        firstView.addSubview(coinLabel)
        coinImage.anchor(nil, left: firstView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 22, heightConstant: 22)
        coinImage.anchorCenterYToSuperview()
        coinLabel.anchor(firstView.topAnchor, left: coinImage.rightAnchor, bottom: firstView.bottomAnchor, right: firstView.rightAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        secondView.addSubview(kyatImage)
        secondView.addSubview(kyatLabel)
        secondView.addSubview(arrowIcon)
        kyatImage.anchor(nil, left: secondView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 22, heightConstant: 22)
        kyatImage.anchorCenterYToSuperview()
        arrowIcon.anchor(nil, left: nil, bottom: nil, right: secondView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 22, heightConstant: 22)
        arrowIcon.anchorCenterYToSuperview()
        kyatLabel.anchor(secondView.topAnchor, left: kyatImage.rightAnchor, bottom: secondView.bottomAnchor, right: arrowIcon.leftAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
