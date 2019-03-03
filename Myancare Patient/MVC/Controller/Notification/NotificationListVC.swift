//
//  NotificationListVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/3/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

///Notifiction list view to show notifications loaded from server
class NotificationListVC: UIViewController{
    
    let cellID = "cellID"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        self.title = "Notifications"
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        let v = view.safeAreaLayoutGuide
        collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        collectionView.register(NotiCell.self, forCellWithReuseIdentifier: cellID)
    }
}

///collection view extension for notificationlistvc
extension NotificationListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! NotiCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell click")
    }
    
}

///UICollectionViewCell for notification list
class NotiCell: UICollectionViewCell {
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .gray
        return img
    }()
    
    let noteLabel: UITextView = {
        let lbl = UITextView()
        lbl.text = "Your next appointment with Dr.Henry is in 5 mins"
        lbl.textAlignment = .left
        lbl.isUserInteractionEnabled = false
        lbl.font = UIFont.mmFontRegular(ofSize: 14)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "25 Feb 2019 | 14:50 PM"
        lbl.font = UIFont.mmFontRegular(ofSize: 12)
        lbl.textColor = UIColor.gray
        return lbl
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    func setupViews(){
        addSubview(icon)
        addSubview(noteLabel)
        addSubview(dateLabel)
        addSubview(lineView)
        
        icon.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        icon.anchorCenterYToSuperview()
        dateLabel.anchor(nil, left: icon.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        noteLabel.anchor(topAnchor, left: icon.rightAnchor, bottom: dateLabel.topAnchor, right: rightAnchor, topConstant: 4, leftConstant: 16, bottomConstant: 4, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        lineView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
