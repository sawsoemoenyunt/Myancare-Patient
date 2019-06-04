//
//  DoctorDetailViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import NVActivityIndicatorView

var bookAppointmentData = BookAppointmentModel()

class DoctorDetailVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {
    
    let profileCellID = "cellID_Profile"
    let additionalCellID = "cellID_additional"
    var doctorID = ""
    var doctorData = DoctorModel()
    
    lazy var likeButton : UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(named: "icons8-like")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(likeButtonClick))
        btn.tintColor = UIColor.MyanCareColor.lightGray
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView?.register(DoctorDetailProfileCell.self, forCellWithReuseIdentifier: profileCellID)
        collectionView?.register(DoctorDetailAdditionCell.self, forCellWithReuseIdentifier: additionalCellID)
        
        self.navigationItem.rightBarButtonItem = likeButton
        
        if doctorID != "" {
            self.getDoctorData(doctorID)
        }
    }
    
    @objc func likeButtonClick(){
        if doctorData.favorite!{
            self.deleteFavourite()
        } else {
            self.setFavourite()
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if indexPath.row == 0 {
            
            let profileCell = collectionView.dequeueReusableCell(withReuseIdentifier: profileCellID, for: indexPath) as! DoctorDetailProfileCell
            profileCell.doctorDetailViewController = self
            profileCell.docData = doctorData

            cell = profileCell
            
        } else {
            let additionalCell = collectionView.dequeueReusableCell(withReuseIdentifier: additionalCellID, for: indexPath) as! DoctorDetailAdditionCell
            
            if indexPath.row == 1{
                additionalCell.iconImage.image = UIImage(named: "heart-green")
                additionalCell.titleLabel.text = "အထူးပြုဆွေးနွေးနိုင်သောအကြောင်းအရာများ"
                additionalCell.bodyLabel.text = "\(doctorData.specialization!)"
                
            } else if indexPath.row == 2{
                additionalCell.iconImage.image = UIImage(named: "education-red")
                additionalCell.titleLabel.text = "အရည်အချင်းများ"
                additionalCell.bodyLabel.text = "\(doctorData.degrees!)"
                
            } else if indexPath.row == 3{
                additionalCell.iconImage.image = UIImage(named: "info-yellow")
                additionalCell.titleLabel.text = "ကိုယ်ရေးအကျဉ်း"
//                additionalCell.bodyLabel.text = "\(doctorData.biography!)"
                if let htmlString = doctorData.biography!.htmlToAttributedString{
                    additionalCell.bodyLabel.text = "\(htmlString.string)"
                }
                
            } else if indexPath.row == 4{
                additionalCell.iconImage.image = UIImage(named: "language-green")
                additionalCell.titleLabel.text = "ဘာသာစကား"
                var speakingLanguages = ""
                
                for lan in (doctorData.language)!{
                    if let language = lan as? String{
                        speakingLanguages = "\(speakingLanguages)\(language)\n"
                    }
                }
                
                additionalCell.bodyLabel.text = speakingLanguages
            }
            
            cell = additionalCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 105 //other 105 : calculate auto height later
        if indexPath.row == 0 {
            height = 280 //profile
            
        } else {
            var text = "one line dummy text"
            
            switch indexPath.row{
            case 1:
                text = doctorData.specialization!
                break
            case 2:
                text = doctorData.degrees!
                break
            case 3:
                text = doctorData.biography!
            case 4:
                for lan in doctorData.language!{
                    text = "\(text)\(lan)\n"
                }
            default:
                break
            }
            
            height = self.view.calculateHeightofTextView(dummyText: "\(text)", fontSize: 14, viewWdith: collectionView.bounds.width - 40) + 90
        }
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
}

extension DoctorDetailVC{
    
    func setFavourite(){
        self.startAnimating()
        let url = EndPoints.setFavourites.path
        let params = ["doctor":doctorData.id!]
        let heads = ["Authorization" : "\(jwtTkn)"]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            print("DOC FAV : \(response)")
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                if responseStatus == 201 || responseStatus == 200{
                    self.likeButton.tintColor = UIColor.red
                    self.doctorData.favorite = true
                } else {
                    print("\(responseStatus ?? 0)")
                }
                
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
    func deleteFavourite(){
        self.startAnimating()
        let url = EndPoints.deleteFavourites(doctorData.id!).path
        let heads = ["Authorization" : "\(jwtTkn)"]
        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                if responseStatus == 201 || responseStatus == 200{
                    self.likeButton.tintColor = UIColor.gray
                    self.doctorData.favorite = false
                } else {
                    print("\(responseStatus ?? 0)")
                }
                
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
    func getDoctorData(_ docID:String){
        
        startAnimating()
        
        let url = EndPoints.getDoctorData(docID).path
        let heads = ["Authorization" : "\(jwtTkn)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                print("Success geeting doctor data")
                let responseStatus = response.response?.statusCode
                print("Response status: \(responseStatus ?? 0)")
                
                if responseStatus == 400{
                    print("Record not found!")
                    
                } else if responseStatus == 200{
                    print("Record found")
                    if let responseData = response.result.value as? [String:Any]{
                        self.doctorData.updateUsingDict(responseData)
                        if self.doctorData.favorite!{
                            self.likeButton.tintColor = UIColor.red
                        } else {
                            self.likeButton.tintColor = UIColor.gray
                        }
                        self.collectionView.reloadData()
                    }
                }
                
            case .failure(let error):
                print("Error getting doctor data")
                print("\(error)")
                self.showAlert(title: "Something went wrong!".localized(), message: "The connection to the server failed!".localized())
            }
            self.stopAnimating()
        }
    }
}
