//
//  ReminderListCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class ReminderListCell: UICollectionViewCell {
    
    var reminderListVC : ReminderListVC?
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "capsule")
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    let typelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Vitamins"
        lbl.font = UIFont.MyanCareFont.type7
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Daily 7:00 PM"
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let infolabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dr.Thomas"
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let verticalLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.MyanCareColor.lightGray
        return view
    }()
    
    let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    lazy var editBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "icons8-edit_property"), for: .normal)
        btn.addTarget(self, action: #selector(editBtnclick), for: .touchUpInside)
        return btn
    }()
    
    @objc func editBtnclick() {
        self.reminderListVC?.navigationController?.pushViewController(EditReminderVC(), animated: true)
    }
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    func setupViews(){
        
        addSubview(bgView)
        bgView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 2, leftConstant: 20, bottomConstant: 2, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        bgView.addSubview(icon)
        bgView.addSubview(typelabel)
        bgView.addSubview(dateLabel)
        bgView.addSubview(verticalLine)
        bgView.addSubview(editBtn)
        bgView.addSubview(bottomLineView)
        
        
        verticalLine.anchor(bgView.topAnchor, left: nil, bottom: bgView.bottomAnchor, right: bgView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 50, widthConstant: 0.5, heightConstant: 0)
        editBtn.anchor(nil, left: nil, bottom: nil, right: bgView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 15, widthConstant: 25, heightConstant: 25)
        editBtn.anchorCenterYToSuperview()
        icon.anchor(nil, left: bgView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        icon.anchorCenterYToSuperview()
        typelabel.anchor(topAnchor, left: icon.rightAnchor, bottom: nil, right: verticalLine.leftAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        dateLabel.anchor(typelabel.bottomAnchor, left: icon.rightAnchor, bottom: nil, right: verticalLine.leftAnchor, topConstant: 4, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        
        bottomLineView.anchor(nil, left: bgView.leftAnchor, bottom: bgView.bottomAnchor, right: bgView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
