//
//  SelectBookVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/11/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class SelectBookVC: UIViewController, NVActivityIndicatorViewable {
    
    let cellID = "cellID"
    var books = [MedicalRecordBookModel]()
    var doctorID = ""
    var bookIDArray = [String]()
    var isPaging = true
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        cv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 4, right: 0)
        return cv
    }()
    
    lazy var shareBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("SHARE", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(shareButtonClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func shareButtonClick(){
        shareMedicalBooks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getAllMedicalRecords()
    }
    
    func setupViews(){
        view.backgroundColor = .white
        self.title = "Share Book"
        
        view.addSubview(collectionView)
        view.addSubview(shareBtn)
        let v = view.safeAreaLayoutGuide
        shareBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: shareBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "View Book List", style: .plain, target: self, action: #selector(viewBookList))
        
        collectionView.register(MedicalRecordSelectCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    @objc func viewBookList(){
        
        //start chat conversation with doctor
        let layout = UICollectionViewFlowLayout()
        let homeVC = HomeViewController(collectionViewLayout:layout)
        let navController = UINavigationController(rootViewController: homeVC)
        homeVC.pushToVC(vc: RecordBookVC())
        UtilityClass.changeRootViewController(with: navController)
    }
}

extension SelectBookVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MedicalRecordSelectCell
        if books.count > 0{
            cell.recordData = books[indexPath.row]
            
            if isPaging && indexPath.row == books.count - 1{
                getAllMedicalRecords()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recordBookID = books[indexPath.row].id!
        bookIDArray.append(recordBookID)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let recordBookID = books[indexPath.row].id!
        //remove id
        bookIDArray.removeAll{$0 == recordBookID}
    }
}

extension SelectBookVC{
    func getAllMedicalRecords(){
        
        if books.count == 0{
            self.startAnimating()
        }
        
        let skip = books.count
        let limit = 10
        
        let url = EndPoints.getMedicalRecordBooks(skip, limit).path
        let heads = ["Authorization":"\(jwtTkn)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                
                if responseStatus == 200{
                    if let responseArray = response.result.value as? NSArray{
                        for responseData in responseArray{
                            if let dataDict = responseData as? [String:Any]{
                                let book = MedicalRecordBookModel()
                                book.updateModelUsingDict(dataDict)
                                
                                self.books.append(book)
                            }
                        }
                        self.isPaging = responseArray.count > 0 ? true : false
                        self.collectionView.reloadData()
                    }
                    
                } else {
                    print("Data not found!")
                }
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
    func shareMedicalBooks(){
        self.startAnimating()
        let url = EndPoints.addBookPermission.path
        let params = ["doctor_id": doctorID,
                      "medical_record_book": bookIDArray] as [String:Any]
        let heads = ["Authorization":"\(jwtTkn)"]
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                if responseStatus == 200 || responseStatus == 201{
                    let alert = UIAlertController(title: "Success", message: "Your selected medical record books shared to \(bookAppointmentData.doctor_name!)", preferredStyle: UIAlertController.Style.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        //redirect to homeview controller
                        UtilityClass.switchToHomeViewController()
                    }))
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    print("Failed to share books")
                    self.showAlert(title: "Failed", message: "An error occur while sharing your medical record books to \(bookAppointmentData.doctor_name!)")
                }
            
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
}
