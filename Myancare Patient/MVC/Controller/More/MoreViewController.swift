//
//  MoreViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Localize_Swift
import CallKit
import Sinch
import NVActivityIndicatorView

class MoreViewController: UIViewController, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {
    
    var appointmentModelData = AppointmentModel()
    let cellID = "cellID"
    let cellID_profile = "cellID_profile"
    let buttonList:[MenuButton] = [MenuButton(title: "User Name", icon: #imageLiteral(resourceName: "pablo-profile")),
                                   MenuButton(title: "Change Language", icon: #imageLiteral(resourceName: "icons8-language")),
                                   MenuButton(title: "Security", icon: #imageLiteral(resourceName: "icons8-security_checked_filled")),
                                   MenuButton(title: "Feedback Us", icon: #imageLiteral(resourceName: "icons8-filled_message")),
                                   MenuButton(title: "Invite your Friend", icon: #imageLiteral(resourceName: "icons8-share")),
                                   MenuButton(title: "Help", icon: #imageLiteral(resourceName: "icons8-help")),
                                   MenuButton(title: "About", icon: #imageLiteral(resourceName: "icons8-about"))]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    lazy var signOutBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign out".localized(), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(red:0.94, green:0.36, blue:0.19, alpha:1) //orange
        btn.layer.cornerRadius = 23
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.addTarget(self, action: #selector(showLogoutOption), for: .touchUpInside)
        return btn
    }()
    
    @objc func signOutButtonClick(){
        //logout user and delete token from userdefaults
        self.logoutDeviceFromServer()
        UserDefaults.standard.setToken(value: "")
        UserDefaults.standard.setIsLoggedIn(value: false)
        UserDefaults.standard.setUserData(value: NSDictionary())
        jwtTkn = ""
        UIApplication.shared.applicationIconBadgeNumber = 0
        UtilityClass.changeRootViewController(with: LoginViewController())
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
    
    @objc func showLogoutOption(){
        let actionSheet = UIAlertController(title: "Are you sure to signout?", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (action) in
            self.signOutButtonClick()
        }
        
        actionSheet.addAction(confirm)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Copyright © 2018-2019\nAllright reserved by MyanCare\nVersion 3.0"
        lbl.numberOfLines = 3
        lbl.textAlignment = .center
        lbl.font = UIFont.mmFontRegular(ofSize: 11)
        
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
        self.view.backgroundColor = UIColor.white
        self.navigationItem.largeTitleDisplayMode = .never
        
        setupViews()
        
//        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
//        infoLabel.text = "Copyright © 2018-2019\nAllright reserved by MyanCare\nVersion \(appVersion ?? "x.x.x")"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.collectionView.reloadData()
    }
    
    func setupViews(){
        view.addSubview(collectionView)
        view.addSubview(signOutBtn)
        view.addSubview(infoLabel)
        
        infoLabel.anchor(nil, left: self.view.safeAreaLayoutGuide.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 4, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        signOutBtn.anchor(nil, left: self.view.safeAreaLayoutGuide.leftAnchor, bottom: infoLabel.topAnchor, right: self.view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 12, rightConstant: 8, widthConstant: 0, heightConstant: 46)
        collectionView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: signOutBtn.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        collectionView.register(MoreCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(MoreCollectionViewEditProfileCell.self, forCellWithReuseIdentifier: cellID_profile)
    }
}

extension MoreViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func showLanguagePicker(){
        let actionSheet = UIAlertController(title: "Change Language", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let mmBtn = UIAlertAction(title: "Myanmar", style: .default) { (action) in
            Localize.setCurrentLanguage("my")
            self.collectionView.reloadData()
        }
        let enBtn = UIAlertAction(title: "English", style: .default) { (action) in
            Localize.setCurrentLanguage("en")
            self.collectionView.reloadData()
        }
        
        actionSheet.addAction(mmBtn)
        actionSheet.addAction(enBtn)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.navigationController?.pushViewController(UserProfileVC(), animated: true)
        
        } else if indexPath.row == 1{
            print("language picker action sheet appear...")
            self.showLanguagePicker()
            
        } else if indexPath.row == 2{
            self.showAlert(title: "Avilable soon", message: "...")
            
        } else if indexPath.row == 3{
            if let openUrl = URL(string: "https://m.me/myancareapps"){
                UIApplication.shared.open(openUrl, options: [:], completionHandler: nil)
                print("Redirect to myancare messenger...")
            }
            
        } else if indexPath.row == 4{
            if let name = NSURL(string: "https://itunes.apple.com/us/app/myancare/id1396490288?mt=8") {
                let objectsToShare = [name]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                self.present(activityVC, animated: true, completion: nil)
            }
            else
            {
                print("sharing not available...")
            }
            
        } else if indexPath.row == 5{
            self.showAlert(title: "Avilable soon", message: "...")
        } else if indexPath.row == 6{
            self.navigationController?.pushViewController(AboutusVC(), animated: true)
        }
    }
    
    func showCallTypePicker(){
        let actionSheet = UIAlertController(title: "Choose option to test", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let mmBtn = UIAlertAction(title: "Voice", style: .default) { (action) in
            self.actionButtonAction("Voice")
        }
        let enBtn = UIAlertAction(title: "Video", style: .default) { (action) in
            self.actionButtonAction("Video")
        }
        
        actionSheet.addAction(mmBtn)
        actionSheet.addAction(enBtn)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    /// funcion to initialize SINCH Client variable
    ///
    /// - Returns: return SINClient value
    func client() -> SINClient
    {
        return ((UIApplication.shared.delegate as? AppDelegate)?.client)!
    }
    
    @objc func actionButtonAction(_ type:String)
    {
        let myDictOfDict = [
            "CALLER_NAME" : "Saw Soe Moe Nyunt",
            "CALL_ID" : "whyouwannknowmyid",
            "CALLER_IMAGE" : "http://portal.bilardo.gov.tr/assets/pages/media/profile/profile_user.jpg",
            "RECEIVER_NAME" : "Aye Aye",
            "RECEIVER_IMAGE" : "https://content-static.upwork.com/uploads/2014/10/01073427/profilephoto1.jpg",
            "APPOINTMENT_ID" : "NOAPPIDBLBALBALBLA"
            ]
//        let id = "5c236db0477cf001e3979321"
        let id = "5c32d818870ffa2f826a6ea3"
        if type == "Voice"{
            if(self.client().isStarted())
            {
                weak var call: SINCall? = self.client().call().callUser(withId:id,headers: myDictOfDict as [AnyHashable : Any])
                
                ((UIApplication.shared.delegate as? AppDelegate)?.callKitProvider)?.reportNewOutgoingCall(call)
            }
            
        } else {
            if(self.client().isStarted())
            {
                weak var call: SINCall? = self.client().call().callUserVideo(withId:id, headers: myDictOfDict as [AnyHashable : Any])
                
                ((UIApplication.shared.delegate as? AppDelegate)?.callKitProvider)?.reportNewOutgoingCall(call)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize = CGSize(width: self.collectionView.frame.width, height: 54)
        
        if indexPath.row == 0 {
            cellSize = CGSize(width: self.collectionView.frame.width, height: 85)
        }
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if indexPath.row == 0 {
            let profilecell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_profile, for: indexPath) as! MoreCollectionViewEditProfileCell
            if let userName = UserDefaults.standard.getUserData().object(forKey: "name") as? String{
                    profilecell.namelabel.text = userName
            }
            if let image_url = UserDefaults.standard.getUserData().object(forKey: "image_url") as? String{
//                UIImage.loadImage(image_url) { (image) in
//                    profilecell.icon.image = image
//                }
                profilecell.icon.loadImage(urlString: image_url)
            }
            
            
            cell = profilecell
        } else {
            let morecell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MoreCollectionViewCell
            morecell.icon.image = buttonList[indexPath.row].icon
            morecell.label.text = buttonList[indexPath.row].title.localized()
            morecell.swLangauge.isHidden = true
            
            cell = morecell
        }
        return cell
    }
}
