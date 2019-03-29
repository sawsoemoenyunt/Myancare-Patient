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

///Notifiction list view to show notifications loaded from server
class NotificationListVC: UIViewController, NVActivityIndicatorViewable{
    
    let cellID = "cellID"
    var notiList = [NotificationModel]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        self.getAllNotis()
    }
    
    func setupViews(){
        self.title = "Notifications".localized()
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        let v = view.safeAreaLayoutGuide
        collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
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
        cell.notiData = notiList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let layout = UICollectionViewFlowLayout()
//        let homeVC = HomeViewController(collectionViewLayout:layout)
//        let navController = UINavigationController(rootViewController: homeVC)
//        homeVC.pushToVC(vc: AppointmentListViewController())
//        UtilityClass.changeRootViewController(with: navController)
        
    }
    
}

extension NotificationListVC{
    func getAllNotis(){
        
        self.startAnimating()
        
        let limit = 10
        let skip = notiList.count > 0 ? notiList.count : 0
        let url = EndPoints.getNotifications(limit, skip).path
        
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


