//
//  RescheduleSlotsCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class RescheduleSlotsCell: UICollectionViewCell {
    
    var slotData: OperationHourModel?{
        didSet{
            if let data = slotData{
                timeLabel.text = "\(data.slot_start_time!) - \(data.slot_end_time!)"
            }
        }
    }
    
    let radio: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12 //24
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    let statusButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Now", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button1
        btn.backgroundColor = UIColor.MyanCareColor.orange
        btn.layer.cornerRadius = 15 //30
        btn.layer.masksToBounds = true
        return btn
    }()
    
    let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "1:45 PM - 2:00 PM"
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textAlignment = .left
        lbl.textColor = .black
        return lbl
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    func setupViews(){
        addSubview(radio)
        addSubview(statusButton)
        addSubview(timeLabel)
        addSubview(lineView)
        
        radio.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24)
        radio.anchorCenterYToSuperview()
        statusButton.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 30)
        statusButton.anchorCenterYToSuperview()
        timeLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 80, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        lineView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                radio.backgroundColor = UIColor.MyanCareColor.darkGray
            } else {
                radio.backgroundColor = UIColor.white
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
