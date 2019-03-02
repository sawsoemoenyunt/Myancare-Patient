//
//  UserInformationVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/2/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class UserInformationVC: UIViewController, UITextFieldDelegate {
    
    //scrollView
    let scrollView: UIScrollView = {
        let sc = UIScrollView()
        sc.backgroundColor = UIColor.white
        return sc
    }()
    
    //UILabel to show information
    let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "Make sure your information is correct before continuing"
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = UIColor.MyanCareColor.gray
        return lbl
    }()
    
    //UIImageView for user profile image
    let profileImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = UIColor.gray
        img.layer.cornerRadius = 40
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
    
    let agreeSwitch: UISwitch = {
        let sw = UISwitch()
        return sw
    }()
    
    let agreeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "I agree to the terms of service"
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = UIColor.MyanCareColor.gray
        return lbl
    }()
    
    lazy var confrimBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("CONFIRM", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(confrimBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func confrimBtnClick(){
        UtilityClass.switchToHomeViewController()
    }
    
    lazy var setupPasscodeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("SETUP PASSCODE", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.setTitleColor(UIColor.MyanCareColor.gray, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.MyanCareColor.green.cgColor
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        //        btn.addTarget(self, action: #selector(engBtnClick), for: .touchUpInside)
        return btn
    }()
    
    var labelTopAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupViews(){
        self.title = "User Information"
        view.backgroundColor = UIColor.white
        
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+100)
        view.addSubview(scrollView)
        scrollView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: screenHeight+100)
        
        //adding sub views to view
        scrollView.addSubview(label)
        scrollView.addSubview(profileImage)
        scrollView.addSubview(phoneUserIDTextField)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(dobTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(agreeSwitch)
        scrollView.addSubview(agreeLabel)
        scrollView.addSubview(confrimBtn)
        scrollView.addSubview(setupPasscodeBtn)
        
        let v = scrollView.safeAreaLayoutGuide //scrollview's safe area layout
        //adding constraints to subviews
        labelTopAnchor = label.anchorWithReturnAnchors(v.topAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)[0] //get top anchor of label
        profileImage.anchor(label.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 80)
        profileImage.anchorCenterXToSuperview()
        phoneUserIDTextField.anchor(profileImage.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 30, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 48)
        nameTextField.anchor(phoneUserIDTextField.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 48)
        dobTextField.anchor(nameTextField.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 48)
        emailTextField.anchor(dobTextField.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 48)
        agreeSwitch.anchor(emailTextField.bottomAnchor, left: v.leftAnchor, bottom: nil, right: nil, topConstant: 30, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        agreeLabel.anchor(emailTextField.bottomAnchor, left: agreeSwitch.rightAnchor, bottom: nil, right: v.rightAnchor, topConstant: 40, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        confrimBtn.anchor(agreeSwitch.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        setupPasscodeBtn.anchor(confrimBtn.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        
        scrollView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(hideKeyBoard)))
    }
    
    @objc func hideKeyBoard(){
        self.view.endEditing(true)
        moveViewToTopWithConstant(10)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == dobTextField {
            moveViewToTopWithConstant(-60)
        } else if textField == emailTextField {
            moveViewToTopWithConstant(-120)
        }
        return true
    }
    
    func moveViewToTopWithConstant(_ constant:CGFloat){
        labelTopAnchor?.constant = constant
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyBoard()
        return true
    }
}
