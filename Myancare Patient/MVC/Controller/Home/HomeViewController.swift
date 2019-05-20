//
//  HomeViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Localize_Swift
import Alamofire
import NVActivityIndicatorView
import UserNotifications

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {
    
    let collectionViewCellID_Menu = "collectionViewCellID_Menu"
    let collectionViewCellID_Category = "collectionViewCellID_Category"
    let collectionViewCellID_Online = "collectionViewCellID_Online"
    let collectionViewCellID_Today = "collectionViewCellID_Today"
    var favoriteDoctorArr = [DoctorListModel]()
    var recommandDoctorArr = [DoctorListModel]()
    var todayAppointmentArr = [AppointmentModel]()
    var notiCount = 0
    
    func updateDeviceToken(){
        if let deviceToken = UserDefaults.standard.getPushyToken(){
            let url = EndPoints.updateDeviceToken.path
            let params = ["device_token":"\(deviceToken)", "app_version" : "3.0.0"]
            let heads = ["Authorization" : "\(jwtTkn)"]
            Alamofire.request(url, method: HTTPMethod.put, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
                let status = response.response?.statusCode
                print("Update device token response status : \(status ?? 0)")
                
                if status == 403 || status == 500{
                    self.logoutDeviceFromServer()
                    SocketManagerHandler.sharedInstance().disconnectSocket()
                    UserDefaults.standard.setToken(value: "")
                    UserDefaults.standard.setIsLoggedIn(value: false)
                    UserDefaults.standard.setUserData(value: NSDictionary())
                    jwtTkn = ""
                    UtilityClass.changeRootViewController(with: UINavigationController(rootViewController: LoginViewController()))
                } else if status == 426{
                    print("Update ios app")

                    let alert = UIAlertController(title: "Update Available!", message: "Please update MyanCare app!", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "UPDATE", style: UIAlertAction.Style.default, handler: { (action) in
                        print("redirect to app store")
                        if let openUrl = URL(string: "itms://itunes.apple.com/app/apple-store/id1396490288?mt=8"){
                            UIApplication.shared.open(openUrl, options: [:], completionHandler: nil)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func logoutDeviceFromServer(){
        self.startAnimating()
        if let deviceToken = UserDefaults.standard.getPushyToken(){
            let url = EndPoints.logout(deviceToken).path
            let heads = ["Authorization" : "\(jwtTkn)"]
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
                
                switch response.result{
                case .success:
                    let statusCode = response.response?.statusCode
                    if statusCode == 200 || statusCode == 201{
                        print("Logout success")
                    }
                case .failure(let error):
                    print("\(error)")
                }
                self.stopAnimating()
            }
        }
    }
    
    func initSinch(){
        if let userID = UserDefaults.standard.getUserData().object(forKey: "_id") as? String{
            (UIApplication.shared.delegate as? AppDelegate)?.initSinchClient(withUserId: userID)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collectionview
        self.collectionView?.backgroundColor = .white
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        //register cell
        self.collectionView?.register(MenuCell.self, forCellWithReuseIdentifier: collectionViewCellID_Menu)
        self.collectionView?.register(MenuCategoryCell.self, forCellWithReuseIdentifier: collectionViewCellID_Category)
        self.collectionView?.register(MenuOnlineCell.self, forCellWithReuseIdentifier: collectionViewCellID_Online)
        self.collectionView?.register(MenuTodayCell.self, forCellWithReuseIdentifier: collectionViewCellID_Today)
        
        UNUserNotificationCenter.current().delegate = self
        updateDeviceToken()
        initSinch()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.todayAppointmentArr.removeAll()
        self.collectionView.reloadData()
        
        setupViews()
        
        ///MARK : CHANGE LATER
        if let token = UserDefaults.standard.getToken(){
            print("Login token : \(token)")
            jwtTkn = "Bearer \(token)"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.title = "Welcome".localized()
        setupNavBarItems()
        
        if SocketManagerHandler.sharedInstance().isSocketConnected() == false{
            print("WORK HERE Home")
            SocketManagerHandler.sharedInstance().connectSocket { (data, emit) in
                print("Socket connected")
                print(data)
                print(emit)
            }
        }
        
        getDoctors(.recommand)
        getDoctors(.favourite)
        getAppointments()
        
//        let semephore = DispatchSemaphore(value: 0)
//        let dispatchQueue = DispatchQueue.global(qos: .background)
//        dispatchQueue.sync {
//            getDoctors(.recommand)
//            semephore.wait()
//
//            getDoctors(.favourite)
//            semephore.wait()
//
//            getAppointments()
//            semephore.wait()
//        }
    }
    
    func setupNavBarItems(){
        let chatButton = UIBarButtonItem(image: UIImage.init(named: "icons8-sms"), style: .plain, target: self, action: #selector(messagesButtonPressed))
        let notiButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-appointment_reminders"), style: .plain, target: self, action: #selector(self.notiButtonPressed))
        self.navigationItem.rightBarButtonItems = [chatButton, notiButton]
    }
    
    // MARK: - Navigation Message Button Action
    @objc func messagesButtonPressed () {
        self.navigationController?.pushViewController(ChatListVC(), animated: true)
    }
    
    // MARK: - Navigation Message Button Action
    @objc func notiButtonPressed () {
        self.navigationController?.pushViewController(NotificationListVC(), animated: true)
    }
    
    func setupViews(){
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Welcome".localized()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.mmFontBold(ofSize: 32)]
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.mmFontBold(ofSize: 14)]
    }
    
    func pushToVC(vc: UIViewController){
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        switch indexPath.row {
        case 0:
            let menuCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID_Menu, for: indexPath) as! MenuCell
            menuCell.homeViewController = self
            menuCell.collectionView.reloadData()
            cell = menuCell
            break
        case 1:
            let todayCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID_Today, for: indexPath) as! MenuTodayCell
            todayCell.homeViewController = self
            todayCell.appointmentList = todayAppointmentArr
            todayCell.viewmoreLabel.isHidden = todayAppointmentArr.count == 0 ? true : false
            cell = todayCell
            break
        case 2:
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID_Category, for: indexPath) as! MenuCategoryCell
            categoryCell.homeViewController = self
            categoryCell.collectionView.reloadData()
            cell = categoryCell
            break
        case 3:
            let onlinecell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID_Online, for: indexPath) as! MenuOnlineCell
            onlinecell.labe1.text = "Online".localized()
            onlinecell.labe2.text = "View all".localized()+" >"
            onlinecell.homeViewController = self
            onlinecell.docType = DoctorType.recommand
            onlinecell.docList = recommandDoctorArr
            cell = onlinecell
            break
        case 4:
            let mydocCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID_Online, for: indexPath) as! MenuOnlineCell
            mydocCell.labe1.text = "Favourite".localized()
            mydocCell.homeViewController = self
            mydocCell.docType = DoctorType.favourite
            mydocCell.docList = favoriteDoctorArr
            cell = mydocCell
            break
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 180.0
        if indexPath.row == 1 {
            if todayAppointmentArr.count == 0{
                height = 0 //hide today appointment list
            } else {
                height = 110
            }
        }
        return CGSize(width: (self.collectionView?.frame.width)! - 20, height: height)
    }
    
}

extension HomeViewController{
    func getDoctors(_ docType:DoctorType){
        
//        startAnimating()
        
        //        let skip = doctors.count != 0 ? doctors.count : 0
        //        let limit = 20
        var url = EndPoints.getDoctors(0,10).path
        
        switch docType {
        case .recommand:
            url = EndPoints.getRecommandDoctors.path
            break
        case .favourite:
            url = EndPoints.getFavoriteDoctors.path
            break
        default:
            break
        }
        
        let heads = ["Authorization":"\(jwtTkn)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                
                if responseStatus == 400{
                    print("Record not found!")
                } else if responseStatus == 200{
                    if let responseDataArr = response.result.value as? NSArray{
                        self.assignDocArray(docType, dataArr: responseDataArr)
                    }
                }
                
            case .failure(let error):
                print("Error occur on request")
                print("\(error)")
                self.showAlert(title: "Something went wrong!".localized(), message: "The connection to the server failed!".localized())
            }
//            self.stopAnimating()
        }
    }
    
    func assignDocArray(_ type:DoctorType, dataArr:NSArray){
        var docArr = [DoctorListModel]()
        
        for responseData in dataArr{
            if let resData = responseData as? [String:Any]{
                let docListModel = DoctorListModel()
                docListModel.updateDoctorListModel(resData)
                docArr.append(docListModel)
            }
        }
        
        if type == .favourite{
            self.favoriteDoctorArr = docArr
        } else{
            self.recommandDoctorArr = docArr
        }
        
        self.collectionView.reloadData()
    }
    
    func getAppointments(){
        
//        self.startAnimating()
        let url = EndPoints.getAppointment.path
        
        let heads = ["Authorization" : "\(jwtTkn)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let status = response.response?.statusCode
                print("Status code : \(status ?? 0)")
                
                if status == 200{
                    DispatchQueue.main.async {
                        var appointmentarray = [AppointmentModel]()
                        if let responseDict = response.result.value as? [String:Any]{
                            let appointment = AppointmentModel()
                            appointment.updateModleUsingDict(responseDict)
                            appointmentarray.append(appointment)
                            
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){  self.todayAppointmentArr = appointmentarray
                            self.collectionView.reloadData()
                        }
                    }
                } else {
                    print("Record not found!")
                }
                
            case .failure(let error):
                print("\(error)")
            }
//            self.stopAnimating()
        }
    }
}

extension HomeViewController: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        self.navigationController?.pushViewController(NotificationListVC(), animated: true)
        completionHandler([.alert,.sound,.badge])
    }
}
