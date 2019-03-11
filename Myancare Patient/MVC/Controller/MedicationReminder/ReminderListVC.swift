//
//  ReminderListVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/11/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class ReminderListVC: UIViewController {
    
    let cellID = "cellID"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 70, right: 0)
        return cv
    }()
    
    lazy var typeSegment:UISegmentedControl = {
        let sg = UISegmentedControl(items: ["Today","All"])
        //        sg.setImage( #imageLiteral(resourceName: "icons8-magazine"), forSegmentAt: 0)
        //        sg.setImage( #imageLiteral(resourceName: "icons8-more_filled"), forSegmentAt: 1)
        //        sg.setImage( #imageLiteral(resourceName: "icons8-appointment_reminders"), forSegmentAt: 2)
        sg.tintColor = UIColor(red:0.51, green:0.75, blue:0.35, alpha:1)
        sg.backgroundColor = .clear
        sg.selectedSegmentIndex = 0
        sg.layer.cornerRadius = 17
        sg.clipsToBounds = true
        sg.layer.borderWidth = 2
        sg.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        sg.layer.borderColor = UIColor(red:0.51, green:0.75, blue:0.35, alpha:1).cgColor
        sg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        sg.addTarget(self, action: #selector(handleSegment), for: .valueChanged)
        return sg
    }()
    
    @objc func handleSegment(){
        
    }
    
    lazy var addBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("+", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.orange
        btn.layer.cornerRadius = 28 //56
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func addBtnClick(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        self.title = "Medication Reminder"
        view.backgroundColor = .white
        
        view.addSubview(typeSegment)
        view.addSubview(collectionView)
        view.addSubview(addBtn)
        
        let v = view.safeAreaLayoutGuide
        typeSegment.anchor(v.topAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 34)
        collectionView.anchor(typeSegment.bottomAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        addBtn.anchor(nil, left: nil, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 20, widthConstant: 56, heightConstant: 56)
        
        collectionView.register(ReminderListCell.self, forCellWithReuseIdentifier: cellID)
    }
}

extension ReminderListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ReminderListCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 85)
    }
}

class ReminderListCell: UICollectionViewCell {
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = .gray
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
        print("edit button click")
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
        editBtn.anchor(nil, left: nil, bottom: nil, right: bgView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 25, heightConstant: 25)
        editBtn.anchorCenterYToSuperview()
        icon.anchor(nil, left: bgView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 69, heightConstant: 69)
        icon.anchorCenterYToSuperview()
        typelabel.anchor(icon.topAnchor, left: icon.rightAnchor, bottom: nil, right: verticalLine.leftAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
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
