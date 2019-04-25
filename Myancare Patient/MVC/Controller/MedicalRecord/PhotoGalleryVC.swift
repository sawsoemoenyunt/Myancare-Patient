//
//  PhotoGalleryVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/11/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class PhotoGalleryVC: UIViewController, NVActivityIndicatorViewable {
    
    let cellId = "cellID"
    let headerID = "headerID"
    var medicalRecordBook = MedicalRecordBookModel()
    var recordSheet = MedicalRecordSheetModel()
    var imagePicker = UIImagePickerController()
    var imageToUpload = UIImage()
    var imageKey = ""
    var imageUrl = ""
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 70, right: 0)
        return cv
    }()
    
    lazy var addBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("+", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.orange
        btn.layer.cornerRadius = 28 //56
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(showSourceOption), for: .touchUpInside)
        return btn
    }()
    
    lazy var refreshControl1 : UIRefreshControl = {
        let  rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshDoctorData), for: .valueChanged)
        return rc
    }()
    
    @objc func refreshDoctorData() {
        self.getRecordSheet()
        self.refreshControl1.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        if medicalRecordBook.doctor_id != ""{
            self.addBtn.isHidden = true
        }
        
        getRecordSheet()
    }
    
    func setupViews(){
        self.title = "Photo Gallery"
        view.backgroundColor = .white
        
        let v = view.safeAreaLayoutGuide
        
        view.addSubview(collectionView)
        view.addSubview(addBtn)
        collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        addBtn.anchor(nil, left: nil, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 20, widthConstant: 56, heightConstant: 56)
        
//        let addBtn = UIBarButtonItem(title: "ADD", style: .plain, target: self, action: #selector(showSourceOption))
//        self.navigationItem.rightBarButtonItem = addBtn
        
        collectionView.register(PhotoGalleryCell.self, forCellWithReuseIdentifier: cellId)
//        collectionView.register(PhotoGalleryHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        collectionView.refreshControl = refreshControl1
    }
}

extension PhotoGalleryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if let sheed = recordSheet.record_sheed![indexPath.row] as? NSDictionary{
//            if let url = sheed.object(forKey: "images") as? String{
//                let imageUrl = "\(recordSheet.imageLink!)\(url)"
//                let zoomVC = ChatImageZoomVC()
//                zoomVC.imageUrl = imageUrl
//                self.navigationController?.pushViewController(zoomVC, animated: true)
//            }
//        }
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoGalleryCell
        let zoomVC = ChatImageZoomVC()
        zoomVC.imageView.image = cell.imageView.image
        self.navigationController?.pushViewController(zoomVC, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (recordSheet.record_sheed?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoGalleryCell
        
        if recordSheet.record_sheed!.count > 0{
            if let sheed = recordSheet.record_sheed![indexPath.row] as? NSDictionary{
                if let url = sheed.object(forKey: "images") as? String{
                    let imageUrl = "\(recordSheet.imageLink!)\(url)"
                    UIImage.loadImage(imageUrl) { (image) in
                        cell.imageView.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.bounds.width, height: 60)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID, for: indexPath) as! PhotoGalleryHeaderCell
//        return view
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsize = collectionView.bounds.width/3 - 10
        return CGSize(width: cellsize, height: cellsize)
    }
}

extension PhotoGalleryVC{
    
    func getRecordSheet(){
        
        self.startAnimating()

        let url = EndPoints.getSheet(medicalRecordBook.id!).path
        let heads = ["Authorization":"\(jwtTkn)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                
                if responseStatus == 200{
                    if let responseDict = response.result.value as? [String:Any]{
                        let sheet = MedicalRecordSheetModel()
                        sheet.updateModelUsingDict(responseDict)
                        self.recordSheet = sheet
                        self.collectionView.reloadData()
                    }
                    
                } else if responseStatus == 400 || responseStatus == 404{
                    print("Failed to get medical record sheet")
                }
                
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
}

extension PhotoGalleryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageToUpload = image
        self.getImageUploadLinkFromServer()
    }
}

extension PhotoGalleryVC{
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
        let params = ["medicalbook_id" : medicalRecordBook.id as Any,
                      "image" : ["\(imageKey)"]] as [String:Any]
        let heads = ["Authorization":"\(jwtTkn)"]
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            print(response.result.value as Any)
            
            self.getRecordSheet()
        }
        
    }
}

