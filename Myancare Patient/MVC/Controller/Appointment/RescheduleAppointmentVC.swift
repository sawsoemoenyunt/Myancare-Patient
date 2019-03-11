//
//  RescheduleAppointmentVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/11/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class RescheduleAppointmentVC: UIViewController {
    
    let cellID = "cellID"
    
    
    let datelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Jan 2019"
        lbl.font = UIFont.mmFontBold(ofSize: 16)
        return lbl
    }()
    
    let calendarView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    let slotLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "     Today, Jan 23"
        lbl.font = UIFont.mmFontBold(ofSize: 16)
        lbl.backgroundColor = UIColor.lightGray
        return lbl
    }()
    
    lazy var slotCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("CONFIRM RESCHEDULE", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.orange
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.layer.cornerRadius = 5 //height 50
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(confirmBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func confirmBtnClick(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Book Appointment"
        slotCollectionView.register(RescheduleSlotsCell.self, forCellWithReuseIdentifier: cellID)
        setupViews()
    }
    
    func setupViews(){
        
        view.backgroundColor = .white
        
        view.addSubview(datelabel)
        view.addSubview(calendarView)
        view.addSubview(slotLabel)
        view.addSubview(slotCollectionView)
        view.addSubview(confirmBtn)
        
        datelabel.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        calendarView.anchor(datelabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 80)
        slotLabel.anchor(calendarView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 40, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        confirmBtn.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 8, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        slotCollectionView.anchor(slotLabel.bottomAnchor, left: view.leftAnchor, bottom: confirmBtn.topAnchor, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 20, rightConstant: 20, widthConstant: 0, heightConstant: 0)
    }
}

extension RescheduleAppointmentVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! RescheduleSlotsCell
        cell.isUserInteractionEnabled = indexPath.row == 0 ? false : true
        cell.radio.isHidden = indexPath.row == 0 ? true : false
        cell.statusButton.isHidden = indexPath.row == 0 ? false : true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

class RescheduleSlotsCell: UICollectionViewCell {
    
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
