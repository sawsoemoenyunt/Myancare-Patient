//
//  ProfileCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class ProfileCell: UICollectionViewCell, UITextFieldDelegate {
    
    var userProfileVC:UserProfileVC?
    var isFemaleSelected = false
    
    let profileImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = UIColor.gray
        img.layer.cornerRadius = 40 //80
        img.clipsToBounds = true
        return img
    }()
    
    lazy var phoneUserIDTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Phone Number / User ID"
        tf.borderStyle = .roundedRect
        tf.delegate = self
        return tf
    }()
    
    lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.borderStyle = .roundedRect
        tf.delegate = self
        return tf
    }()
    
    lazy var dobTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Date of Birth"
        tf.borderStyle = .roundedRect
        tf.delegate = self
        return tf
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email Address"
        tf.borderStyle = .roundedRect
        tf.delegate = self
        return tf
    }()
    
    lazy var femaleBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.backgroundColor = UIColor.white
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 12 //24
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(handleFemaleButton), for: .touchUpInside)
        return btn
    }()
    
    let femalelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Female"
        lbl.font = UIFont.mmFontRegular(ofSize: 14)
        lbl.textAlignment = .center
        return lbl
    }()
    
    @objc func handleFemaleButton(){
        maleBtn.backgroundColor = UIColor.white
        femaleBtn.backgroundColor = UIColor.MyanCareColor.orange
        isFemaleSelected = true
    }
    
    lazy var maleBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.backgroundColor = UIColor.white
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 12 //24
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(handleMaleButton), for: .touchUpInside)
        return btn
    }()
    
    let malelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Male"
        lbl.font = UIFont.mmFontRegular(ofSize: 14)
        lbl.textAlignment = .center
        return lbl
    }()
    
    @objc func handleMaleButton(){
        femaleBtn.backgroundColor = UIColor.white
        maleBtn.backgroundColor = UIColor.MyanCareColor.orange
        isFemaleSelected = false
    }
    
    lazy var heightTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Height"
        tf.borderStyle = .roundedRect
        tf.delegate = self
        return tf
    }()
    
    lazy var weightTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Weight"
        tf.borderStyle = .roundedRect
        tf.delegate = self
        return tf
    }()
    
    lazy var bloodtypeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Blood Type"
        tf.borderStyle = .roundedRect
        tf.delegate = self
        return tf
    }()
    
    func setupViews(){
        addSubview(profileImage)
        addSubview(phoneUserIDTextField)
        addSubview(nameTextField)
        addSubview(dobTextField)
        addSubview(emailTextField)
        addSubview(femaleBtn)
        addSubview(femalelabel)
        addSubview(maleBtn)
        addSubview(malelabel)
        addSubview(heightTextField)
        addSubview(weightTextField)
        addSubview(bloodtypeTextField)
        
        profileImage.anchor(topAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 80)
        profileImage.anchorCenterXToSuperview()
        phoneUserIDTextField.anchor(profileImage.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        nameTextField.anchor(phoneUserIDTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        dobTextField.anchor(nameTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        emailTextField.anchor(dobTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        femaleBtn.anchor(emailTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24)
        femalelabel.anchor(femaleBtn.topAnchor, left: femaleBtn.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        maleBtn.anchor(femaleBtn.topAnchor, left: femalelabel.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24)
        malelabel.anchor(maleBtn.topAnchor, left: maleBtn.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let tfWidth = self.bounds.width/3 - 20
        heightTextField.anchor(femaleBtn.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: tfWidth, heightConstant: 50)
        weightTextField.anchor(femaleBtn.bottomAnchor, left: heightTextField.rightAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: tfWidth, heightConstant: 50)
        bloodtypeTextField.anchor(femaleBtn.bottomAnchor, left: weightTextField.rightAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: tfWidth, heightConstant: 50)
        
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(normalView)))
    }
    
    @objc func normalView(){
        hideKeyboard()
        userProfileVC?.moveViewToTopWithConstant(20)
    }
    
    @objc func hideKeyboard(){
        self.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        userProfileVC?.moveViewToTopWithConstant(20)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dobTextField {
            userProfileVC?.moveViewToTopWithConstant(-120)
        } else if textField == emailTextField{
            userProfileVC?.moveViewToTopWithConstant(-180)
        } else if textField == heightTextField || textField == weightTextField || textField == bloodtypeTextField{
            userProfileVC?.moveViewToTopWithConstant(-300)
        } else {
            userProfileVC?.moveViewToTopWithConstant(20)
        }
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
