//
//  RepeatingVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/31/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class RepeatingVC: UIViewController {
    
    let cellID_day = "cellID_day"
    let cellID_hour = "cellID_hour"
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let hours = ["1:00 AM","2:00 AM", "3:00 AM", "4:00 AM", "5:00 AM","6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM", "12:00 AM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM", "7:00 PM", "8:00 PM", "9:00 PM", "10:00 PM", "11:00 PM", "12:00 PM"]
    
    lazy var dayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        return cv
    }()
    
    lazy var hourCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        return cv
    }()
    
    let daylabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Repeating Day"
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    let hourlabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Repeating Hour"
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("SAVE", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.isEnabled = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        self.title = "Repeating"
        view.backgroundColor = UIColor.white
        
        view.addSubview(daylabel)
        view.addSubview(hourlabel)
        view.addSubview(dayCollectionView)
        view.addSubview(hourCollectionView)
        view.addSubview(saveBtn)
        
        let v = view.safeAreaLayoutGuide
        saveBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        dayCollectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: saveBtn.topAnchor, right: nil, topConstant: 50, leftConstant: 20, bottomConstant: 4, rightConstant: 0, widthConstant: view.frame.width/2 - 20, heightConstant: 0)
        daylabel.anchor(nil, left: v.leftAnchor, bottom: dayCollectionView.topAnchor, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        hourCollectionView.anchor(v.topAnchor, left: dayCollectionView.rightAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 50, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        hourlabel.anchor(nil, left: hourCollectionView.leftAnchor, bottom: hourCollectionView.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        dayCollectionView.register(RepeatingCell.self, forCellWithReuseIdentifier: cellID_day)
        hourCollectionView.register(RepeatingCell.self, forCellWithReuseIdentifier: cellID_hour)
    }
}

extension RepeatingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dayCollectionView{
            return days.count
        } else {
            return hours.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if collectionView == dayCollectionView{
            let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_day, for: indexPath) as! RepeatingCell
            dayCell.label.text = "Every \(days[indexPath.row])"
            cell = dayCell
        } else {
            let hourCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_hour, for: indexPath) as! RepeatingCell
            hourCell.label.text = "\(hours[indexPath.row])"
            cell = hourCell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
}

class RepeatingCell: UICollectionViewCell {
    
    let box: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        return view
    }()
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "End Day"
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.MyanCareColor.lightGray
        return lbl
    }()
    
    func setupViews(){
        backgroundColor = UIColor.groupTableViewBackground
        addSubview(box)
        addSubview(label)
        
        box.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 15, heightConstant: 15)
        box.anchorCenterYToSuperview()
        label.anchor(topAnchor, left: box.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                backgroundColor = UIColor.MyanCareColor.orange
                label.textColor = UIColor.white
            } else {
                backgroundColor = UIColor.groupTableViewBackground
                label.textColor = UIColor.MyanCareColor.lightGray
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
