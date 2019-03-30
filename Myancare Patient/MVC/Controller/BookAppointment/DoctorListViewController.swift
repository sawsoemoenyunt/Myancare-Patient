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
    case filter
}

class DoctorListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {
    
    let cellID = "cellID"
    var isPaging = false
    var doctorType = DoctorType.all
    var specializeID = ""
    var specializeName = ""
    var doctors = [DoctorListModel]()
    
    lazy var refreshControl1 : UIRefreshControl = {
        let  rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshDoctorData), for: .valueChanged)
        return rc
    }()
    
    @objc func refreshDoctorData() {
        docSearch.isSearch = false
        doctors.removeAll()
        self.getAllDoctors(doctorType)
        self.refreshControl1.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Doctors"
        self.view.backgroundColor = .white
        let searchButton = UIBarButtonItem(image: UIImage.init(named: "icons8-search"), style: .plain, target: self, action: #selector(searchButtonClick))
        self.navigationItem.rightBarButtonItems = []
        
        //searchController
        //        let search = UISearchController(searchResultsController: nil)
        //        search.searchResultsUpdater = self
        //        self.navigationItem.searchController = search
        
        //collectionView
        collectionView!.register(DoctorListCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView?.backgroundColor = .white
        collectionView?.refreshControl = refreshControl1
        
        //change title
        switch doctorType {
        case .recommand:
            self.title = "Online"
            break
        case .favourite:
            self.title = "Favourite"
            break
        case .specialize:
            self.title = "\(specializeName)"
            break
        default:
            self.title = "General Practitioners"
            self.navigationItem.rightBarButtonItems = [searchButton]
            break
        }
        
        //load doctors
        self.getAllDoctors(doctorType)
    }
    
    @objc func searchButtonClick(){
        self.navigationController?.pushViewController(DoctorSearchViewController(), animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if docSearch.isSearch{
            //load data with search query
            print("Searched")
            doctors.removeAll()
            getAllDoctors(.filter)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if doctors.count == 0 {
            let notDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height))
            notDataLabel.text = "No doctor available!"
            notDataLabel.textColor = UIColor.MyanCareColor.darkGray
            notDataLabel.textAlignment = .center
            collectionView.backgroundView = notDataLabel
        }else{
            collectionView.backgroundView = nil
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
        doctorDetailVC.doctorID = doctors[indexPath.row].id!
        self.navigationController?.pushViewController(doctorDetailVC, animated: true)
    }
    
}

extension DoctorListViewController{
    func getAllDoctors(_ docType:DoctorType){
        
        startAnimating()
        
//        let skip = doctors.count != 0 ? doctors.count : 0
//        let limit = 20
        var url = EndPoints.getDoctors.path
        
        switch docType {
        case .recommand:
            url = EndPoints.getRecommandDoctors.path
            break
        case .favourite:
            url = EndPoints.getFavoriteDoctors.path
            break
        case .specialize:
            url = EndPoints.getDocotrBySpecialiation(specializeID).path
            break
        case .filter:
            url = EndPoints.getDoctorFilter(docSearch.name).path
            docSearch.isSearch = false
        default:
            url = EndPoints.getDoctors.path
            break
        }
        
        print("Your doc request link : \(url)")
        
        let heads = ["Authorization":"\(jwtTkn)"]
        
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
            self.stopAnimating()
        }
    }
}
