//
//  AvoidMedicineCollectionView.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/21/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class AvoidMedicineCellCollectionView: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    var ehrVC : EHRListVC?
    var medicines = [Disease]()
    
    let titlelabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type1
        lbl.textColor = UIColor.black
        lbl.numberOfLines = 2
        lbl.text = "မတည့်သောဆေးများ"
        return lbl
    }()
    
    lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("ဖျက်ရန်", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.type6
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.orange
        btn.layer.cornerRadius = 15
        btn.clipsToBounds = true
        btn.isHidden = true
        return btn
    }()
    
    lazy var addBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("အသစ်ထည့်ရန်", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.type6
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 15
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func addBtnClick(){
        
        let alert = UIAlertController(title: "Medicine", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Medicine Name"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            
            if textField.text != ""{
                let med = Disease()
                med.name = "\(textField.text!)"
                self.ehrVC?.avoidMedicineList.append(med)
                self.ehrVC?.collectionView.reloadData()
            }
        }))
        
        ehrVC!.present(alert, animated: true, completion: nil)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        return cv
    }()
    
    let lineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medicines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AvoidMedicineCell
        
        if medicines.count > 0{
            cell.titlelabel.text = medicines[indexPath.row].name!
            cell.index = indexPath.row
            cell.ehrVC = self.ehrVC
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func setupViews(){
        addSubview(titlelabel)
        addSubview(deleteBtn)
        addSubview(addBtn)
        addSubview(collectionView)
        addSubview(lineView)
        
        addBtn.anchor(topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 70, heightConstant: 30)
        deleteBtn.anchor(topAnchor, left: nil, bottom: nil, right: addBtn.leftAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 70, heightConstant: 30)
        titlelabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: deleteBtn.leftAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        collectionView.anchor(titlelabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        lineView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0.5)
        
        collectionView.register(AvoidMedicineCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AvoidMedicineCell: UICollectionViewCell {
    
    var index: Int?
    var ehrVC: EHRListVC?
    
    let titlelabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.text = "Ear health formula tablet"
        return lbl
    }()
    
    lazy var deleteIcon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "icons8-delete_sign").withRenderingMode(.alwaysTemplate)
        img.tintColor = UIColor.red
        img.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(deleteItem)))
        img.isUserInteractionEnabled = true
        return img
    }()
    
    @objc func deleteItem(){
        ehrVC?.avoidMedicineList.remove(at: index!)
        ehrVC?.collectionView.reloadData()
    }
    
    func setupViews(){
        addSubview(titlelabel)
        addSubview(deleteIcon)
        
        deleteIcon.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 25, heightConstant: 25)
        deleteIcon.anchorCenterYToSuperview()
        titlelabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: deleteIcon.leftAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.gray.cgColor
    }
}


