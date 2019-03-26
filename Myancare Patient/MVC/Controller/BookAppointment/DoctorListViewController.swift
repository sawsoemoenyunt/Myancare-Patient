//
//  DoctorListViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

enum DoctorType{
    case recommand
    case favourite
    case all
    case specialize
}

class DoctorListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {
    
    let cellID = "cellID"
    var isPaging = false
    var doctorType = DoctorType.all
    var specializeID = ""
    var doctors = [DoctorListModel]()
    
    lazy var refreshControl1 : UIRefreshControl = {
        let  rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshDoctorData), for: .valueChanged)
        return rc
    }()
    
    @objc func refreshDoctorData() {
        doctors.removeAll()
        self.getAllDoctors()
        self.refreshControl1.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Doctors"
        self.view.backgroundColor = .white
        let searchButton = UIBarButtonItem(image: UIImage.init(named: "icons8-search"), style: .plain, target: self, action: #selector(searchButtonClick))
        self.navigationItem.rightBarButtonItems = [searchButton]
        
        //searchController
        //        let search = UISearchController(searchResultsController: nil)
        //        search.searchResultsUpdater = self
        //        self.navigationItem.searchController = search
        
        //collectionView
        collectionView!.register(DoctorListCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView?.backgroundColor = .white
        collectionView?.refreshControl = refreshControl1
        
        //load doctors
        self.getAllDoctors()
        
    }
    
    @objc func searchButtonClick(){
        self.navigationController?.pushViewController(DoctorSearchViewController(), animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if doctors.count == 0 {
            let notDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height))
            notDataLabel.text = "No doctor available!"
            notDataLabel.textColor = UIColor.MyanCareColor.darkGray
            notDataLabel.textAlignment = .center
            collectionView.backgroundView = notDataLabel
        }
        return doctors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! DoctorListCell
        if doctors.count > 0 {
            cell.docData = doctors[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView!.frame.width, height: 89)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let doctorDetailVC = DoctorDetailVC(collectionViewLayout: layout)
        self.navigationController?.pushViewController(doctorDetailVC, animated: true)
    }
    
}

extension DoctorListViewController{
    func getAllDoctors(){
        
        startAnimating()
        
//        let skip = doctors.count != 0 ? doctors.count : 0
//        let limit = 20
        let url = EndPoints.getDoctors.path
        let heads = ["Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjViMDU2MGUzZjg4MTdjMzg4ODE5YWY1MCIsInJvbGUiOiJQYXRpZW50IiwiaWF0IjoxNTUzMjI4Mzk5fQ.4a0POJTeBdl70PLBRomm4VVmEKrPMsDkZauClaRBDxY"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                print("Request successful!")
                
                let responseStatus = response.response?.statusCode
                print("Response status: \(responseStatus ?? 0)")
                
                if responseStatus == 400{
                    print("Record not found!")
                    
                } else if responseStatus == 200{
                    print("Docots found!")
                    if let responseDataArr = response.result.value as? NSArray{
                        for responseData in responseDataArr{
                            if let resData = responseData as? [String:Any]{
                                let docListModel = DoctorListModel()
                                docListModel.updateDoctorListModel(resData)
                                
                                self.doctors.append(docListModel)
                            }
                        }
                        self.collectionView.reloadData()
                    }
                }
                
            case .failure(let error):
                print("Error occur on request")
                print("\(error)")
            }
        }
        self.stopAnimating()
    }
}
