//
//  BookAppointmentViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/23/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class BookAppointmentViewController: UIViewController {
    
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
        lbl.text = "Slots Available"
        lbl.font = UIFont.mmFontBold(ofSize: 16)
        return lbl
    }()
    
    lazy var slotCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    lazy var bookBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("BOOK NOW", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(red:0.54, green:0.77, blue:0.45, alpha:1) //green
        btn.layer.cornerRadius = 5 //height 50
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(bookBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func bookBtnClick(){
        self.navigationController?.pushViewController(InvoiceViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Book Appointment"
        slotCollectionView.register(SlotsCell.self, forCellWithReuseIdentifier: cellID)
        setupViews()
    }
    
    func setupViews(){
        
        view.backgroundColor = .white
        
        view.addSubview(datelabel)
        view.addSubview(calendarView)
        view.addSubview(slotLabel)
        view.addSubview(slotCollectionView)
        view.addSubview(bookBtn)
        
        datelabel.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        calendarView.anchor(datelabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 80)
        slotLabel.anchor(calendarView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 40, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        bookBtn.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 8, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        slotCollectionView.anchor(slotLabel.bottomAnchor, left: view.leftAnchor, bottom: bookBtn.topAnchor, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 20, rightConstant: 20, widthConstant: 0, heightConstant: 0)
    }
}

extension BookAppointmentViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SlotsCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}

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
                backgroundColor = UIColor(red:0.82, green:0.31, blue:0.16, alpha:1)
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
