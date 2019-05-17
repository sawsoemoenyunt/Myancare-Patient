//
//  NotificationListVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/3/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import Localize_Swift

///Notifiction list view to show notifications loaded from server
class NotificationListVC: UIViewController, NVActivityIndicatorViewable{
    
    let cellID = "cellID"
    var notiList = [NotificationModel]()
    var isPaging = true
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        return cv
    }()
    
    lazy var refreshControl1 : UIRefreshControl = {
        let  rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshDoctorData), for: .valueChanged)
        return rc
    }()
    
    @objc func refreshDoctorData() {
        isPaging = true
        notiList.removeAll()
        getAllNotis()
        self.refreshControl1.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        self.getAllNotis()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func setupViews(){
        self.title = "Notifications".localized()
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        let v = view.safeAreaLayoutGuide
        collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        collectionView.refreshControl = refreshControl1
        
        collectionView.register(NotiCell.self, forCellWithReuseIdentifier: cellID)
    }
}

///collection view extension for notificationlistvc
extension NotificationListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notiList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! NotiCell
        
        if notiList.count > 0{
            cell.notiData = notiList[indexPath.row]
            if isPaging && indexPath.row == notiList.count-1 {
                getAllNotis()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var estimatedHeight:CGFloat = 0
        if notiList.count > 0{
             estimatedHeight = self.view.calculateHeightofTextView(dummyText: notiList[indexPath.row].message_body!, fontSize: 18, viewWdith: collectionView.frame.width - 100)
        }
        return CGSize(width: collectionView.bounds.width, height: 60 + estimatedHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let notiTypeString = notiList[indexPath.row].notification_type_string?.lowercased()
        
        if (notiTypeString?.contains("chat"))!{
            let layout = UICollectionViewFlowLayout()
            let homeVC = HomeViewController(collectionViewLayout:layout)
            let navController = UINavigationController(rootViewController: homeVC)
            homeVC.pushToVC(vc: ChatListVC())
            UtilityClass.changeRootViewController(with: navController)

        } else if (notiTypeString?.contains("appointment"))! || (notiTypeString?.contains("consultation"))! || (notiTypeString?.contains("booking"))!{
            let layout = UICollectionViewFlowLayout()
            let homeVC = HomeViewController(collectionViewLayout:layout)
            let navController = UINavigationController(rootViewController: homeVC)
            homeVC.pushToVC(vc: AppointmentListViewController())
            UtilityClass.changeRootViewController(with: navController)
        }
        
    }
    
}

extension NotificationListVC{
    func getAllNotis(){
        
        if notiList.count == 0{
            self.startAnimating()
        }
        
        let limit = 10
        let skip = notiList.count
        let language = Localize.currentLanguage() == "en" ? "en" : "mm"
        let url = EndPoints.getNotifications(limit, skip, language).path
        
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
                            if let responseDict = responseData as? [String:Any]{
                                let noti = NotificationModel()
                                noti.updateModelUsingDic(responseDict)
                                
                                self.notiList.append(noti)
                            }
                        }
                        self.isPaging = responseDataArr.count > 0 ? true : false
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


