//
//  UserProfileEditVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/5/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import NVActivityIndicatorView

/// User information fill form view
class UserProfileEditVC: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    var userData = PatientModel()
    let cellID = "cellID"
    var profileImage = UIImage(named: "pablo-profile")
    
    var countryCode = "95"
    var phoneID = ""
    var name = ""
    var dob = ""
    var email = ""
    var gender = "male"
    var height = ""
    var weight = ""
    var bloodType = ""
    var facebookID = ""
    var imageKey = ""
    var imageUrl = ""
    
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
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(confrimBtnClick), for: .touchUpInside)
        return btn
    }()
    
    /**
     To handle confirm button click
     - Parameters: nil
     - Returns: nil
     */
    @objc func confrimBtnClick(){
        if validateForm() {
            uploadUserDataToServer()
            
        } else {
            self.showAlert(title: "Information required!", message: "Please fill all form with correct format!")
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
    
    @objc func handleBackBtn(){
        UtilityClass.changeRootViewController(with: UINavigationController.init(rootViewController: LoginViewController()))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    /// Func : To setup view and subviews
    func setupViews(){
        self.title = "Edit Profile"
        view.backgroundColor = UIColor.white
        
        view.addSubview(confrimBtn)
        view.addSubview(collectionView)
        
        let v = view.safeAreaLayoutGuide
        confrimBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        
        collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: confrimBtn.topAnchor, right: v.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(hideKeyBoard)))
        collectionView.register(UserProfileEditCell.self, forCellWithReuseIdentifier: cellID)
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
        } else if height == ""{
            print("height required")
            result = false
        } else if weight == ""{
            print("weight required")
            result = false
        } else if bloodType == ""{
            print("blood type required")
            result = false
        } else if validateEmail(email: self.email) == false{
            print("invalid email")
        }
        
        return result
    }
    
    func validateEmail(email: String?) -> Bool {
        
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate =  NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isValid: Bool = emailTest.evaluate(with: email)
        
        return isValid
    }
    
    func getImageUploadLinkFromServer(){
        let url = EndPoints.imagesProfile.path
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                print("Response status: \(responseStatus ?? 0)")
                
                if responseStatus == 400{
                    print("Failed to get image upload link")
                    self.showAlert(title: "Failed to signup!", message: "Please try again.")
                    
                } else if responseStatus == 200{
                    if let result = response.result.value as? NSDictionary{
                        if let key = result.object(forKey: "key") as? String{
                            self.imageKey = key
                        }
                        if let url = result.object(forKey: "url") as? String{
                            self.imageUrl = url
                            print("Image url return from server: \(url)")
                        }
                        
                        if self.imageUrl != "" && self.imageKey != ""{
                            self.uploadImageToS3(self.imageUrl)
                            
                        } else {
                            print("image url was nil")
                        }
                    }
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func uploadImageToS3(_ urlString:String){
        
        self.startAnimating()
        
        let url = urlString
        guard let imageData = profileImage?.jpegData(compressionQuality: 0.7) else {
            return
        }
        
        print("Image Data : -> \(imageData)")
        
        let heads = ["Content-Type":"image/jpeg"]
        
        Alamofire.upload(imageData, to: URL(string: url)!, method: .put, headers: heads).response { (response) in
            
            print("RAW RESPONSE S3 -> \(response)")
            
            let responseStatus = response.response?.statusCode
            print("RESPONSE STATUS CODE FROM S3 : \(responseStatus ?? 0)")
            
            switch responseStatus{
            case 200:
                print("Image uploaded to s3 success...")
            default:
                print("Failed uploading Image to s3...")
                self.showAlert(title: "Failed", message: "Failed to upload image!")
            }
            self.stopAnimating()
        }
        
    }
    
    func uploadUserDataToServer(){
        
        startAnimating()
        
        var params = [
            "name": self.name,
            "dob": self.dob,
            "mobile": self.phoneID,
            "gender": self.gender,
            "email": self.email,
            "height": self.height,
            "weight": self.weight,
            "blood_type": self.bloodType,
            "device_os": "iOS",
            "user_device_info": "\(UIDevice.current.name)"
        ]
        
        if self.imageKey != ""{
            params.updateValue(self.imageKey, forKey: "avatar")
        }
        
        
        print("Requested params : \(params)")
        
        let heads = ["Authorization":"\(jwtTkn)"]
        
        let url = EndPoints.patientUpdate.path
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in

            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                print("Response : \(responseStatus)")
                
                if responseStatus == 400 || responseStatus == 404{
                    if let responseData = response.result.value as? NSDictionary{
                        if let message = responseData.object(forKey: "message") as? NSDictionary{
                            if let messageArr = message.object(forKey: "Validation_Failed") as? NSArray{
                                print(messageArr)
                            }
                        }
                        
                        if let messageString = responseData.object(forKey: "message") as? NSString{
                            print(messageString)
                        }
                    }
                    self.showAlert(title: "An error occured", message: "Failed to update")
                    
                } else if responseStatus == 201 || responseStatus == 200{
                    //apply login process here
                    
                    if let responseData = response.result.value as? [String:Any]{
                        
                        let user = PatientModel()
                        user.updateModel(usingDictionary: responseData)
                        
                        let info:NSDictionary = ["name":user.name!, "wallet_balance":user.wallet_balance!, "image_url":user.image_url!,
                                                 "height":user.height!,
                                                 "age":user.age!,
                                                 "weight":user.weight!,
                                                 "facebook_id":user.facebook_id!,
                                                 "country_code":user.country_code!,
                                                 "_id":user._id!,
                                                 "id":user._id!,
                                                 "createdAt":user.createdAt!,
                                                 "gender":user.gender!,
                                                 "dob":user.dob!,
                                                 "email":user.email!,
                                                 "mobile":user.mobile!,
                                                 "blood_type":user.bloodType!,
                                                 "username":user.username!,
                                                 "updatedAt":user.updatedAt!]
                        UserDefaults.standard.setUserData(value: info)
                        print("user data : \(UserDefaults.standard.getUserData())")
                        
                    }
                    let alert = UIAlertController(title: "Success", message: "Your information was updated!", preferredStyle: UIAlertController.Style.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.navigationController?.popViewController(animated: true)
                    }))
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                }
            case .failure(let error):
                print("failed to upload user data")
                print(error)
            }
            self.stopAnimating()
        }
    }
}

extension UserProfileEditVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UserProfileEditCell
        cell.userInfoVC = self
        
        cell.profileImage.image = UIImage.init(named: "no-image")
        cell.nameTextField.text = userData.name!
        cell.phoneUserIDTextField.text = "\(userData.country_code!)\(userData.mobile!)"
        cell.dobTextField.text = userData.dob!
        cell.emailTextField.text = userData.email!
        if userData.gender == "male" {
            cell.maleBtn.backgroundColor = UIColor.MyanCareColor.orange
        } else {
            cell.femaleBtn.backgroundColor = UIColor.MyanCareColor.orange
        }
        self.gender = userData.gender!
        cell.heightTextField.text = "\(userData.height!.replacingOccurrences(of: ".", with: "'"))"
        cell.weightTextField.text = "\(userData.weight!)"
        cell.bloodtypeTextField.text = "\(userData.bloodType!)"
//        UIImage.loadImage(userData.image_url!) { (image) in
//            cell.profileImage.image = image
//        }
        cell.profileImage.loadImage(urlString: userData.image_url!)
        cell.setUerInfo()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 1000)
    }
    
}

extension UserProfileEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
            
            self.getImageUploadLinkFromServer()
        }
        
        self.dismiss(animated: true) {
            self.collectionView.reloadData()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

