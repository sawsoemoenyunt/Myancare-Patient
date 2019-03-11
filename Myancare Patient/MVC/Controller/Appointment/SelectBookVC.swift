//
//  SelectBookVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/11/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class SelectBookVC: UIViewController {
    
    let cellID = "cellID"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        cv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 4, right: 0)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        view.backgroundColor = .white
        self.title = "Share Book"
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "View Book List", style: .plain, target: self, action: nil)
        
        collectionView.register(MedicalRecordCell.self, forCellWithReuseIdentifier: cellID)
    }
}

extension SelectBookVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MedicalRecordCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 85)
    }
}

class MedicalRecordCell: UICollectionViewCell {
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = .gray
        return img
    }()
    
    let docNamelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dr.Thomas"
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "12-Feb-2019"
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
    
    let checkBox: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.layer.borderColor = UIColor.MyanCareColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()
    
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
        bgView.addSubview(docNamelabel)
        bgView.addSubview(dateLabel)
        bgView.addSubview(infolabel)
        bgView.addSubview(verticalLine)
        bgView.addSubview(checkBox)
        
        
        verticalLine.anchor(bgView.topAnchor, left: nil, bottom: bgView.bottomAnchor, right: bgView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 50, widthConstant: 0.5, heightConstant: 0)
        checkBox.anchor(nil, left: nil, bottom: nil, right: bgView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 16, heightConstant: 16)
        checkBox.anchorCenterYToSuperview()
        icon.anchor(nil, left: bgView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 69, heightConstant: 69)
        icon.anchorCenterYToSuperview()
        docNamelabel.anchor(icon.topAnchor, left: icon.rightAnchor, bottom: nil, right: verticalLine.leftAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        dateLabel.anchor(docNamelabel.bottomAnchor, left: icon.rightAnchor, bottom: nil, right: verticalLine.leftAnchor, topConstant: 4, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        infolabel.anchor(dateLabel.bottomAnchor, left: icon.rightAnchor, bottom: nil, right: verticalLine.leftAnchor, topConstant: 4, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2.0
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected {
                checkBox.backgroundColor = UIColor.MyanCareColor.green
            } else {
                checkBox.backgroundColor = UIColor.white
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
