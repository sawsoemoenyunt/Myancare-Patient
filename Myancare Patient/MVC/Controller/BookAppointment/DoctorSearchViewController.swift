//
//  DoctorSearchViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class DoctorSearchViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    let buttonList:[MenuButton] = [MenuButton(title: "Vegan", icon: #imageLiteral(resourceName: "icons8-vegan_food")),
                                   MenuButton(title: "Heart", icon: #imageLiteral(resourceName: "icons8-medical_heart")),
                                   MenuButton(title: "Babay", icon: #imageLiteral(resourceName: "icons8-baby")),
                                   MenuButton(title: "Medicine", icon: #imageLiteral(resourceName: "icons8-supplement_bottle")),
                                   MenuButton(title: "Sp5", icon: UIImage()),
                                   MenuButton(title: "Sp6", icon: UIImage()),
                                   MenuButton(title: "Vegan", icon: #imageLiteral(resourceName: "icons8-vegan_food")),
                                   MenuButton(title: "Heart", icon: #imageLiteral(resourceName: "icons8-medical_heart")),
                                   MenuButton(title: "Babay", icon: #imageLiteral(resourceName: "icons8-baby")),
                                   MenuButton(title: "Medicine", icon: #imageLiteral(resourceName: "icons8-supplement_bottle")),
                                   MenuButton(title: "Sp5", icon: UIImage()),
                                   MenuButton(title: "Sp6", icon: UIImage())]
    
    let searchField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Search by Name"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1)
        return tf
    }()
    
    let specialitiesLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Specialities"
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return lbl
    }()
    
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Date"
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return lbl
    }()
    
    lazy var collectionView: UICollectionView = {
        //layout of collectionview
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 4
        layout.scrollDirection = .horizontal
        
        //collectionview
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        
        //change content inset
        cv.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 4)
        
        return cv
    }()
    
    let dateView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1)
        return view
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("CONFIRM", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(red:0.54, green:0.77, blue:0.45, alpha:1) //green
        btn.layer.cornerRadius = 25 //height 50
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(confrimbuttonClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func confrimbuttonClick(){
        self.navigationController?.popViewController(animated: true)
        print("Search button clicked")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search Doctor"
        self.view.backgroundColor = .white
        setupViews()
    }
    
    func setupViews(){
        view.addSubview(searchField)
        view.addSubview(specialitiesLabel)
        view.addSubview(dateLabel)
        view.addSubview(collectionView)
        view.addSubview(dateView)
        view.addSubview(confirmBtn)
        
        searchField.anchor(self.view.safeAreaLayoutGuide.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 36)
        specialitiesLabel.anchor(searchField.bottomAnchor, left: self.view.leftAnchor, bottom: nil
            , right: self.view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        collectionView.anchor(specialitiesLabel.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 100)
        dateLabel.anchor(collectionView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        dateView.anchor(dateLabel.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 80)
        confirmBtn.anchor(nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 38, bottomConstant: 50, rightConstant: 38, widthConstant: 0, heightConstant: 50)
        
        collectionView.register(DoctorSearchSpecializationCell.self, forCellWithReuseIdentifier: cellID)
    }
}

extension DoctorSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! DoctorSearchSpecializationCell
        cell.icon.image = buttonList[indexPath.row].icon
        cell.title.text = buttonList[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4 - 10, height: collectionView.frame.height)
    }
}

class DoctorSearchSpecializationCell: UICollectionViewCell {
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .white
        img.layer.borderColor = UIColor.lightGray.cgColor
        img.layer.borderWidth = 0.5
        img.clipsToBounds = true
        return img
    }()
    
    let title: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sp1"
        lbl.textColor = UIColor(red:0.6, green:0.6, blue:0.6, alpha:1) //lihgt gray
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 11)
        return lbl
    }()
    
    func setupViews(){
        
        addSubview(icon)
        addSubview(title)
        
        title.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 2, bottomConstant: 14, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        icon.anchor(nil, left: nil, bottom: title.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 66, heightConstant: 66)
        icon.anchorCenterXToSuperview()
        
        //circle icon
        icon.layer.cornerRadius = 33
        icon.clipsToBounds = true
        
        
        //background color
        self.backgroundColor = UIColor.white
        
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                icon.layer.borderWidth = 4
                icon.layer.borderColor = UIColor(red:0.82, green:0.31, blue:0.16, alpha:1).cgColor
            } else {
                icon.layer.borderWidth = 0.5
                icon.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    }
    
    override var isHighlighted: Bool{
        didSet{
            if isHighlighted{
                UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.transform = self.transform.scaledBy(x: 0.85, y: 0.85)
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                }, completion: nil)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

