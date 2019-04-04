//
//  AddPhotoVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/11/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class AddPhotoVC: UIViewController, NVActivityIndicatorViewable {
    
    var recordBook = MedicalRecordBookModel()
    var imagePicker = UIImagePickerController()
    var imageToUpload = UIImage()
    var imageKey = ""
    var imageUrl = ""
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "hand-camera")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let photolabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "ADD PHOTO"
        lbl.numberOfLines = 0
        lbl.font = UIFont.MyanCareFont.title
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.textAlignment = .center
        return lbl
    }()
    
    let infolabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "သင်ရဲ့ဆေးမှတ်တမ်းများကို ဓါတ်ပုံရိုက်ယူ၍\nထည့်သွင်းသိမ်းဆည်းထားနိုင်ပါသည်။"
        lbl.numberOfLines = 0
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var chooseBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("SELECT PHOTO", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(handleChooseBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleChooseBtnClick(){
        showSourceOption()
    }
    
    lazy var skipBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("CHOOSE LATER", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.setTitleColor(UIColor.MyanCareColor.green, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.MyanCareColor.green.cgColor
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(skipBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func skipBtnClick(){
        let galleryVC = PhotoGalleryVC()
        galleryVC.medicalRecordBook = self.recordBook
        self.navigationController?.pushViewController(galleryVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        view.backgroundColor = .white
        
        view.addSubview(icon)
//        view.addSubview(photolabel)
//        view.addSubview(infolabel)
        view.addSubview(chooseBtn)
        view.addSubview(skipBtn)
        
        let v = view.safeAreaLayoutGuide
        chooseBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        skipBtn.anchor(nil, left: v.leftAnchor, bottom: chooseBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 10, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        
//        photolabel.anchorCenterSuperview()
        icon.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width, heightConstant: 300)
        icon.anchorCenterSuperview()
//        infolabel.anchor(photolabel.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
    }
}

extension AddPhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func showSourceOption(){
        let actionSheet = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let cameraBtn = UIAlertAction(title: "From Camera", style: .default) { (action) in
            self.chooseImage(type: .camera)
        }
        let galleryBtn = UIAlertAction(title: "From Gallery", style: .default) { (action) in
            self.chooseImage(type: .savedPhotosAlbum)
        }
        
        actionSheet.addAction(cameraBtn)
        actionSheet.addAction(galleryBtn)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func chooseImage(type:UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = type;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageToUpload = image
        self.getImageUploadLinkFromServer()
    }
}

extension AddPhotoVC{
    func getImageUploadLinkFromServer(){
        let url = EndPoints.imagesUpload.path
        let heads = ["Authorization":"\(jwtTkn)"]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                print("Response status: \(responseStatus ?? 0)")
                
                if responseStatus == 400 || responseStatus == 404{
                    print("Failed to get image upload link")
                    self.showAlert(title: "An error occur", message: "Failed while adding image to sheet")
                    
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
        guard let imageData = imageToUpload.jpegData(compressionQuality: 0.7) else {
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
                self.uploadSheets()
            default:
                print("Failed uploading Image to s3...")
                self.showAlert(title: "An error occur", message: "Failed while adding image to sheet")
            }
            self.stopAnimating()
        }
    }
    
    func uploadSheets(){
        let url = EndPoints.addSheet.path
        let params = ["medicalbook_id" : recordBook.id as Any,
                      "image" : ["\(imageKey)"]] as [String:Any]
        let heads = ["Authorization":"\(jwtTkn)"]
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            print(response.result.value as Any)
            
            let galleryVC = PhotoGalleryVC()
            galleryVC.medicalRecordBook = self.recordBook
            self.navigationController?.pushViewController(galleryVC, animated: true)
        }
        
    }
}
