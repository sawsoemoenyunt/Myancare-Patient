//
//  CalendarCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

///calendar cell
class CalendarCell: UICollectionViewCell {
    
    let weekdayLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "S"
        lbl.font = UIFont.mmFontRegular(ofSize: 13)
        lbl.textAlignment = .center
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    let dayLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "12"
        lbl.font = UIFont.mmFontRegular(ofSize: 13)
        lbl.textAlignment = .center
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.MyanCareColor.darkGray
        return view
    }()
    
    func setupViews(){
        backgroundColor = UIColor.groupTableViewBackground
        addSubview(weekdayLabel)
        addSubview(lineView)
        addSubview(dayLabel)
        
        weekdayLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 25)
        lineView.anchor(weekdayLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        dayLabel.anchor(lineView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                backgroundColor = UIColor.MyanCareColor.orange
                lineView.backgroundColor = UIColor.white
                weekdayLabel.textColor = UIColor.white
                dayLabel.textColor = UIColor.white
            } else {
                backgroundColor = UIColor.groupTableViewBackground
                lineView.backgroundColor = UIColor.MyanCareColor.darkGray
                weekdayLabel.textColor = UIColor.MyanCareColor.darkGray
                dayLabel.textColor = UIColor.MyanCareColor.darkGray
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
