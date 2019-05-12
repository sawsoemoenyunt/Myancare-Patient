//
//  ReasonVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/2/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import NVActivityIndicatorView

var imageKeys = ["", "", "", "", "", "", "", ""]

class ReasonVC: UIViewController, NVActivityIndicatorViewable {
    
    let cellID = "cellID"
    var imageList = [UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage()]
    var imagePicker = UIImagePickerController()
    var selectedIndex = 0
    var imageKey = ""
    var imageUrl = ""
    
    let labelReason: UILabel = {
        let lbl = UILabel()
        lbl.text = "Type reason for visit :"
        lbl.numberOfLines = 0
        lbl.font = UIFont.mmFontBold(ofSize: 20)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let reasonTextView: UITextView = {
        let tv = UITextView()
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.layer.borderWidth = 1
        return tv
    }()
    
    let lineView: UIView = {
       let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let labelPhoto: UILabel = {
        let lbl = UILabel()
        lbl.text = "Add photo to show Doctor :"
        lbl.numberOfLines = 0
        lbl.font = UIFont.mmFontBold(ofSize: 20)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        return cv
    }()
    
    lazy var confrimBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("NEXT", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(confrimBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func confrimBtnClick(){
        bookAppointmentData.reason = reasonTextView.text
        
        if bookAppointmentData.reason != ""{
            let invoiceVC = InvoiceViewController()
            self.navigationController?.pushViewController(invoiceVC, animated: true)
        } else {
            self.showAlert(title: "Reason text required!".localized(), message: "Please fill reason for visit.")
        }
    }
    
    func getServiceFees(){
        
        let url = EndPoints.getServiceFees(bookAppointmentData.amount!).path
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                if responseStatus == 200{
                    if let responseDict = response.result.value as? NSDictionary{
                        if let serviceFees = responseDict.object(forKey: "service_fees") as? Int{
                            bookAppointmentData.service_fees = serviceFees
                        }
                        if let serviceTotal = responseDict.object(forKey: "total") as? Int{
                            bookAppointmentData.total_appointment_fees = serviceTotal
                        }
                    }
                    
                } else {
                    print("\(responseStatus ?? 0)")
                }
                
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        collectionView.register(ReasonImageCell.self, forCellWithReuseIdentifier: cellID)
        getServiceFees()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        bookAppointmentData.discount = 0
        bookAppointmentData.coupon = ""
    }
    
    func setupViews(){
        
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(hidKeyBoard)))
        
        view.backgroundColor = .white
        view.addSubview(labelReason)
        view.addSubview(reasonTextView)
        view.addSubview(lineView)
        view.addSubview(labelPhoto)
        view.addSubview(collectionView)
        view.addSubview(confrimBtn)
        
        //setup constraints
        labelReason.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        confrimBtn.anchor(nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        reasonTextView.anchor(labelReason.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 200)
        lineView.anchor(reasonTextView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        labelPhoto.anchor(lineView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        collectionView.anchor(labelPhoto.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: confrimBtn.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 10, rightConstant: 20, widthConstant: 0, heightConstant: 0)
    }
    
    @objc func hidKeyBoard(){
        self.view.endEditing(true)
    }
}

extension ReasonVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ReasonImageCell
        cell.selectedImage.image = imageList[indexPath.row]
        cell.reasonVC = self
        cell.index = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4 - 4, height: collectionView.frame.width/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        print("cell clicked")
    }
}

extension ReasonVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageList[selectedIndex] = image
        self.getImageUploadLinkFromServer()
        self.dismiss(animated: true) {
            self.collectionView.reloadData()
        }
    }
    
    @objc func showSourceOption(){
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
}

extension ReasonVC{
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
                    self.imageList[self.selectedIndex] = UIImage()
                    
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
        let selectedImage = imageList[selectedIndex]
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.7) else {
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
                imageKeys[self.selectedIndex] = self.imageKey
            default:
                print("Failed uploading Image to s3...")
                self.imageList[self.selectedIndex] = UIImage()
            }
            self.stopAnimating()
        }
        
    }
}


