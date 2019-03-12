//
//  DoctorDetailViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class DoctorDetailVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let profileCellID = "cellID_Profile"
    let additionalCellID = "cellID_additional"
    var doctorID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView?.register(DoctorDetailProfileCell.self, forCellWithReuseIdentifier: profileCellID)
        collectionView?.register(DoctorDetailAdditionCell.self, forCellWithReuseIdentifier: additionalCellID)
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
            cell = profileCell
            
        } else {
            let additionalCell = collectionView.dequeueReusableCell(withReuseIdentifier: additionalCellID, for: indexPath) as! DoctorDetailAdditionCell
            additionalCell.bodyLabel.text = "apple\norange\ngrape"
            
            if indexPath.row == 1{
                additionalCell.iconImage.image = #imageLiteral(resourceName: "icons8-vegan_food")
                additionalCell.titleLabel.text = "အထူးပြုဆွေးနွေးနိုင်သောအကြောင်းအရာများ"
                additionalCell.bodyLabel.text = "Something else"
                
            } else if indexPath.row == 2{
                additionalCell.iconImage.image = #imageLiteral(resourceName: "icons8-vegan_food")
                additionalCell.titleLabel.text = "အရည်အချင်းများ"
                additionalCell.bodyLabel.text = "M.B.BA"
                
            } else if indexPath.row == 3{
                additionalCell.iconImage.image = #imageLiteral(resourceName: "icons8-vegan_food")
                additionalCell.titleLabel.text = "ကိုယ်ရေးအကျဥ်း"
                additionalCell.bodyLabel.text = "The best doctor in the town!"
                
            } else if indexPath.row == 4{
                additionalCell.iconImage.image = #imageLiteral(resourceName: "icons8-vegan_food")
                additionalCell.titleLabel.text = "ဘာသာစကား"
                let speakingLanguages = "Myanmar\nEnglish"
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
        }
        return CGSize(width: collectionView.frame.width, height: height)
    }
}
