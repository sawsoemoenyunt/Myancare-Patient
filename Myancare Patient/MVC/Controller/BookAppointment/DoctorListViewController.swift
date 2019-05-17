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
    case recent
    case gp
}

class DoctorListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {
    
    let cellID = "cellID"
    var isPaging = true
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
        isPaging = true
        doctors.removeAll()
        self.getAllDoctors(doctorType)
        self.refreshControl1.endRefreshing()
    }
    
    lazy var filterBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "icons8-filter").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.orange
        btn.layer.cornerRadius = 28 //56
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(filterButtonClick), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    @objc func filterButtonClick(){
        showFilterList()
    }
    
    func showFilterList(){
        let actionSheet = UIAlertController(title: "Choose option to filter doctors", message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Close", style: .cancel) { (action) in
            self.title = "Doctors"
        }
        let allBtn = UIAlertAction(title: "All Doctors", style: .default) { (action) in
            self.doctorType = .all
            self.title = "Doctors"
            self.refreshDoctorData()
        }
        let gpBtn = UIAlertAction(title: "General Practitioners", style: .default) { (action) in
            self.doctorType = .gp
            self.title = "General Practitioners"
            self.refreshDoctorData()
        }
        let filterBtn = UIAlertAction(title: "Filter", style: .default) { (action) in
            self.doctorType = .filter
            docSearch.isSearch = true
            self.title = "Doctors"
            self.navigationController?.pushViewController(DoctorSearchViewController(), animated: true)
        }
        let favBtn = UIAlertAction(title: "Favourite", style: .default) { (action) in
            self.doctorType = .favourite
            self.title = "Favourite"
            self.refreshDoctorData()
        }
        let recentBtn = UIAlertAction(title: "Recent", style: .default) { (action) in
            self.doctorType = .recent
            self.title = "Recent"
            self.refreshDoctorData()
        }
        
        actionSheet.addAction(allBtn)
        actionSheet.addAction(gpBtn)
        actionSheet.addAction(filterBtn)
        actionSheet.addAction(favBtn)
        actionSheet.addAction(recentBtn)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Doctors".localized()
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
            self.title = "Online".localized()
            break
        case .favourite:
            self.title = "Favourite".localized()
            break
        case .specialize:
            self.title = "\(specializeName)".localized()
            break
        default:
            self.title = "General Practitioners".localized()
            self.navigationItem.rightBarButtonItems = [searchButton]
            self.filterBtn.isHidden = false
            break
        }
        
        //load doctors
        self.getAllDoctors(doctorType)
        
        view.addSubview(filterBtn)
        let v = view.safeAreaLayoutGuide
        filterBtn.anchor(nil, left: nil, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 20, widthConstant: 56, heightConstant: 56)
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
            notDataLabel.text = "No doctor available".localized()
            notDataLabel.textColor = UIColor.MyanCareColor.darkGray
            notDataLabel.textAlignment = .center
            notDataLabel.font = UIFont.MyanCareFont.type6
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
            cell.profileImage.image = #imageLiteral(resourceName: "no-image")
            
            
            cell.profileImage.loadImage(urlString: self.doctors[indexPath.row].image_url!, completion: nil)
            
            if doctorType == .all{
                if indexPath.row == doctors.count - 1 && isPaging{
                    isPaging = true
                    print("load more worked")
                    self.getAllDoctors(doctorType)
                }
            }
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
        
        if doctors.count == 0{
            startAnimating()
        }
        
        let skip = doctors.count
        let limit = 10
        
        var url = EndPoints.getDoctors(limit,skip).path
        
        switch docType {
        case .gp:
            url = EndPoints.getDocotrBySpecialiation("5a4e2ec2d683b52694167b2f").path
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
        case .recent:
            url = EndPoints.getRecentDoctors.path
        case .all:
            url = EndPoints.getDoctors(limit,skip).path
        default:
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
                        self.isPaging = responseDataArr.count > 0 ? true : false
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
