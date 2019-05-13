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
    
    var operationHour: OperationHourModel?{
        didSet{
            if let data = operationHour{
//                timeLabel.text = "\(data.slot_start_time!) - \(data.slot_end_time!)"
//                timeLabel.text = data.message!
                let startTime : UnixTime = data.slot_start_time_mililisecond! / 1000
                let endTime : UnixTime = data.slot_end_time_mililisecond! / 1000
                timeLabel.text = "\(startTime.to12Hour) - \(endTime.to12Hour)"
            }
        }
    }
    
    let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "1:45 PM - 2:00 PM"
        lbl.font = UIFont.MyanCareFont.type4
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
