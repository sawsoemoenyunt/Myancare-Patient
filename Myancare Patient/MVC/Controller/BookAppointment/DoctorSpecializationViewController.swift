//
//  DoctorSpecializationViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import NVActivityIndicatorView

class DoctorSpecializeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {
    
    let cellID = "cellID"
    var specList = [SpecializationModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.topItem?.title = ""
        
        //add right barbuttonitem
//        let questionButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-ask_question_filled"), style: .plain, target: self, action: nil)
//        self.navigationItem.rightBarButtonItems = [questionButton]
        
        //setup collectionview
        collectionView?.backgroundColor = .white
        collectionView?.register(SpecializationCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        
        //get data
        getSpecializations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Specialization".localized()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return specList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView!.frame.width/2-10, height: 160)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SpecializationCell
        cell.specData = specList[indexPath.row]
        print("spec id \(specList[indexPath.row])")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let docVC = DoctorListViewController(collectionViewLayout: layout)
        docVC.doctorType = DoctorType.specialize
        docVC.specializeID = specList[indexPath.row].id!
        docVC.specializeName = specList[indexPath.row].name!
        self.navigationController?.pushViewController(docVC, animated: true)
    }
}

extension DoctorSpecializeViewController{
    func getSpecializations(){
        startAnimating()
        
        let url = EndPoints.getSpecializations.path
        print("Your specializations request link : \(url)")
        
        let heads = ["Authorization":"\(jwtTkn)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                print("Request successful!")
                
                let responseStatus = response.response?.statusCode
                print("Response status: \(responseStatus ?? 0)")
                
                if responseStatus == 400{
                    print("RecoSpecializations not found!")
                    
                } else if responseStatus == 200{
                    print("Specializations found!")
                    if let responseDataArr = response.result.value as? NSArray{
                        for responseData in responseDataArr{
                            if let resData = responseData as? [String:Any]{
                                let specModel = SpecializationModel()
                                specModel.updateModelUsingDict(resData)
                                
                                self.specList.append(specModel)
                            }
                        }
                        self.collectionView.reloadData()
                    }
                }
                
            case .failure(let error):
                print("Error occur on request")
                print("\(error)")
                self.showAlert(title: "Something went wrong!".localized(), message: "The connection to the server failed!".localized())
            }
            self.stopAnimating()
        }
    }
}
