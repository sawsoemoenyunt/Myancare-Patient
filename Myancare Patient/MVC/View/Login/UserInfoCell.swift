//
//  UserInfoCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/21/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class UserInfoCell: UICollectionViewCell, UITextFieldDelegate {
    
    var userInfoVC:UserInformationVC?
    var isFemaleSelected = false
    
    lazy var profileImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = UIColor.gray
        img.layer.cornerRadius = 40 //80
        img.clipsToBounds = true
        img.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(profileImageClick)))
        img.isUserInteractionEnabled = true
        return img
    }()
    
    @objc func profileImageClick(){
        userInfoVC?.showImagePicker()
    }
    
    let phoneIDlabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Phone Number / User ID"
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    lazy var phoneUserIDTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Phone Number / User ID"
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .next
        tf.delegate = self
        return tf
    }()
    
    let namelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Name"
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .next
        tf.delegate = self
        return tf
    }()
    
    let doblabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Date of Birth"
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    lazy var dobTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Date of Birth"
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .next
        tf.delegate = self
        tf.inputView = datePicker
        return tf
    }()
    
    lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        dp.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        return dp
    }()
    
    @objc func dateChange(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        dobTextField.text = formatter.string(from: datePicker.date)
        hideKeyboard()
    }
    
    let emaillabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Email Address"
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email Address"
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .next
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
    
    let heightlabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Height"
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    lazy var heightTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Height"
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .next
        tf.delegate = self
        return tf
    }()
    
    let weightlabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Weight"
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    lazy var weightTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Weight"
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .next
        tf.delegate = self
        return tf
    }()
    
    let bloodlabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Blood Type"
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    lazy var bloodtypeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Blood Type"
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .done
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
        addSubview(phoneIDlabel)
        addSubview(namelabel)
        addSubview(doblabel)
        addSubview(emaillabel)
        addSubview(heightlabel)
        addSubview(weightlabel)
        addSubview(bloodlabel)
        
        profileImage.anchor(topAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 80)
        profileImage.anchorCenterXToSuperview()
        
        phoneUserIDTextField.anchor(profileImage.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 60, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        phoneIDlabel.anchor(nil, left: phoneUserIDTextField.leftAnchor, bottom: phoneUserIDTextField.topAnchor, right: phoneUserIDTextField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        nameTextField.anchor(phoneUserIDTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 50, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        namelabel.anchor(nil, left: nameTextField.leftAnchor, bottom: nameTextField.topAnchor, right: nameTextField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        dobTextField.anchor(nameTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 50, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        doblabel.anchor(nil, left: dobTextField.leftAnchor, bottom: dobTextField.topAnchor, right: dobTextField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        emailTextField.anchor(dobTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 50, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        emaillabel.anchor(nil, left: emailTextField.leftAnchor, bottom: emailTextField.topAnchor, right: emailTextField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        femaleBtn.anchor(emailTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24)
        femalelabel.anchor(femaleBtn.topAnchor, left: femaleBtn.rightAnchor, bottom: femaleBtn.bottomAnchor, right: nil, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        maleBtn.anchor(femaleBtn.topAnchor, left: femalelabel.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 24, heightConstant: 24)
        malelabel.anchor(maleBtn.topAnchor, left: maleBtn.rightAnchor, bottom: maleBtn.bottomAnchor, right: nil, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        let tfWidth = self.bounds.width/3 - 20
        heightTextField.anchor(femaleBtn.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 50, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: tfWidth, heightConstant: 50)
        heightlabel.anchor(nil, left: heightTextField.leftAnchor, bottom: heightTextField.topAnchor, right: heightTextField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        weightTextField.anchor(femaleBtn.bottomAnchor, left: heightTextField.rightAnchor, bottom: nil, right: nil, topConstant: 50, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: tfWidth, heightConstant: 50)
        weightlabel.anchor(nil, left: weightTextField.leftAnchor, bottom: weightTextField.topAnchor, right: weightTextField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        bloodtypeTextField.anchor(femaleBtn.bottomAnchor, left: weightTextField.rightAnchor, bottom: nil, right: nil, topConstant: 50, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: tfWidth, heightConstant: 50)
        bloodlabel.anchor(nil, left: bloodtypeTextField.leftAnchor, bottom: bloodtypeTextField.topAnchor, right: bloodtypeTextField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(normalView)))
    }
    
    func setUerInfo(){
        userInfoVC?.name = nameTextField.text!
        userInfoVC?.email = emailTextField.text!
        userInfoVC?.dob = dobTextField.text!
        userInfoVC?.gender = isFemaleSelected == true ? "female" : "male"
        userInfoVC?.height = heightTextField.text!
        userInfoVC?.weight = weightTextField.text!
        userInfoVC?.bloodType = bloodtypeTextField.text!
    }
    
    @objc func normalView(){
        hideKeyboard()
    }
    
    @objc func hideKeyboard(){
        setUerInfo()
        self.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        
        switch textField {
        case phoneUserIDTextField:
            nameTextField.becomeFirstResponder()
        case nameTextField:
            dobTextField.becomeFirstResponder()
        case dobTextField:
            emailTextField.becomeFirstResponder()
        default:
            print("text field return default")
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
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
