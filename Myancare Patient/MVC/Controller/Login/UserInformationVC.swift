//
//  UserInformationVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/2/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

/// User information fill form view
class UserInformationVC: UIViewController, UITextFieldDelegate {
    
    let cellID = "cellID"
    var profileImage: UIImage?
    
    var phoneID = ""
    var name = ""
    var dob = ""
    var email = ""
    var gender = ""
    var height = ""
    var weight = ""
    var bloodType = ""
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "Make sure your information is correct before continuing."
        lbl.numberOfLines = 0
        lbl.font = UIFont.mmFontRegular(ofSize: 14)
        lbl.textColor = UIColor.MyanCareColor.gray
        return lbl
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        return cv
    }()
    
    ///UISwitch : To control agree terms or not
    lazy var agreeSwitch: UISwitch = {
        let sw = UISwitch()
        sw.addTarget(self, action: #selector(swithOnOff), for: .valueChanged)
        return sw
    }()
    
    @objc func swithOnOff(){
        if agreeSwitch.isOn{
            confrimBtn.isEnabled = true
            confrimBtn.backgroundColor = UIColor.MyanCareColor.green
        } else {
            confrimBtn.isEnabled = false
            confrimBtn.backgroundColor = UIColor.MyanCareColor.darkGray
        }
    }
    
    ///UILabel : To show term of service text
    let agreeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "I agree to the terms of service"
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = UIColor.MyanCareColor.gray
        return lbl
    }()
    
    ///UIButton : Custom button for confirm form
    lazy var confrimBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("CONFIRM", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.darkGray
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(confrimBtnClick), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    /**
     To handle confirm button click
     - Parameters: nil
     - Returns: nil
     */
    @objc func confrimBtnClick(){
        if validateForm() {
            self.navigationController?.pushViewController(UserInterestVC(), animated: true)
        } else {
            print("validate form failed!")
            showAlert()
        }
    }
    
    ///UIButton : Custom button for setup passcode
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
    
    ///NSLayoutConstraint : top constraint of label
    var labelTopAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    /// Func : To setup view and subviews
    func setupViews(){
        self.title = "User Information"
        view.backgroundColor = UIColor.white
        
        view.addSubview(confrimBtn)
        view.addSubview(agreeSwitch)
        view.addSubview(agreeLabel)
        view.addSubview(collectionView)
        view.addSubview(label)
        
        let v = view.safeAreaLayoutGuide
        confrimBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        agreeSwitch.anchor(nil, left: v.leftAnchor, bottom: confrimBtn.topAnchor, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 6, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        agreeLabel.anchor(nil, left: agreeSwitch.rightAnchor, bottom: confrimBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 10, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        label.anchor(v.topAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        collectionView.anchor(label.bottomAnchor, left: v.leftAnchor, bottom: agreeSwitch.topAnchor, right: v.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(hideKeyBoard)))
        collectionView.register(UserInfoCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    /**
     To handle key board hide
     - Parameters: nil
     - Returns: nil
     */
    @objc func hideKeyBoard(){
        self.view.endEditing(true)
        moveViewToTopWithConstant(10)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    /**
     To move view to top with animation
     - Parameters: CGFloat
     - Returns: nil
     */
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
    
    func validateForm() -> Bool{
        
        var result = true
        
        if name == "" {
            print("name required")
            result = false
        } else if dob == ""{
            print("dob required")
            result = false
        } else if email == ""{
            print("email required")
            result = false
        } else if gender == ""{
            print("gender required")
            result = false
        } else if height == ""{
            print("height required")
            result = false
        } else if weight == ""{
            print("weight required")
            result = false
        } else if bloodType == ""{
            print("blood type required")
            result = false
        }
        
        return result
    }
    
    func showAlert() {
        // create the alert
        let alert = UIAlertController(title: "Information Required!", message: "Please fill all form!", preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

extension UserInformationVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UserInfoCell
        cell.userInfoVC = self
        cell.profileImage.image = profileImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 1000)
    }
    
}

extension UserInformationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func showImagePicker(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage]{
            selectedImageFromPicker = editedImage as? UIImage
        } else if let originalImage = info[.originalImage]{
            selectedImageFromPicker = originalImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImage = selectedImage
        }
        
        self.dismiss(animated: true) {
            self.collectionView.reloadData()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
