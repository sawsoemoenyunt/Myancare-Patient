//
//  SlotCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

///slot cell
class SlotsCell: UICollectionViewCell {
    
    let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "1:45 PM - 2:00 PM"
        lbl.font = UIFont.mmFontRegular(ofSize: 12)
        lbl.textAlignment = .center
        lbl.textColor = .gray
        return lbl
    }()
    
    func setupViews(){
        addSubview(timeLabel)
        timeLabel.fillSuperview()
        
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                timeLabel.textColor = .white
                backgroundColor = UIColor.MyanCareColor.orange
            } else {
                timeLabel.textColor = .gray
                backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
