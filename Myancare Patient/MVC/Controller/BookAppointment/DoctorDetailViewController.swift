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

class DoctorDetailVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {
    
    let profileCellID = "cellID_Profile"
    let additionalCellID = "cellID_additional"
    var doctorID = ""
    var doctorData = DoctorModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView?.register(DoctorDetailProfileCell.self, forCellWithReuseIdentifier: profileCellID)
        collectionView?.register(DoctorDetailAdditionCell.self, forCellWithReuseIdentifier: additionalCellID)
        
        if doctorID != "" {
            self.getDoctorData(doctorID)
        }
    }
    
    @objc func likeButtonClick(){
        
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
                additionalCell.titleLabel.text = "ကိုယ်ရေးအကျဥ်း"
                additionalCell.bodyLabel.text = "\(doctorData.biography!)"
                
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
                        self.collectionView.reloadData()
                    }
                }
                
            case .failure(let error):
                print("Error getting doctor data")
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
}
