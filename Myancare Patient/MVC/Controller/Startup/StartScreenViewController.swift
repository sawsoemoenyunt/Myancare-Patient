//
//  StartScreenViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/24/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import SwiftyGif
import Alamofire
import NVActivityIndicatorView

/// Start Screen View Controller with Animated gif logo
class StartScreenViewController: UIViewController, SwiftyGifDelegate, NVActivityIndicatorViewable {
    
    ///Imageview for gif logo
    let logo: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    ///This func work after view was loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup views
        view.backgroundColor = .white
        view.addSubview(logo)
        logo.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 140, heightConstant: 140)
        logo.anchorCenterSuperview()
        
        //init gif
        initGifPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let token = UserDefaults.standard.getToken(){
            print("Login token : \(token)")
            jwtTkn = "Bearer \(token)"
        }
    }
    
    /**
     Initializes a new gif with file name
     - Parameters: nil
     - Returns: nil
     */
    func initGifPlayer(){
        let gif = UIImage(gifName: "Logo-Motion_Gif.gif")
        logo.delegate = self
        logo.setGifImage(gif, manager: SwiftyGifManager.defaultManager, loopCount: 1)
        logo.startAnimatingGif()
    }
    
    /**
     gif player listener to check gif was playing
     - Parameters: nil
     - Returns: nil
     */
    func gifDidStart(sender: UIImageView) {
        print("StartScreen : gif file start animating")
    }
    
    /**
     gif player listener to check gif was stop playing
     - Parameters: nil
     - Returns: nil
     */
    func gifDidStop(sender: UIImageView) {
        print("StartScreen : gif file finished animating")
        //switch rootview controller to HomeViewController after gif was finished playing
//        let layout = UICollectionViewFlowLayout()
//        let homeViewController =  HomeViewController(collectionViewLayout:layout)
//        UtilityClass.changeRootViewController(with: UINavigationController(rootViewController: homeViewController))
        
        self.updateDeviceToken { (res) in
            if res{
                if UserDefaults.standard.isLoggedIn(){
                    print("User already logged in")
                    UtilityClass.switchToHomeViewController()
                } else {
                    print("User didn't logged in")
//                    UtilityClass.changeRootViewController(with: UINavigationController(rootViewController: LoginViewController()))
                    UtilityClass.changeRootViewController(with: LanguageViewController())
                }
            } else {
                print("hola")
            }
            return
        }
        
        if !UserDefaults.standard.isLoggedIn(){
            self.stopAnimating()
            UtilityClass.changeRootViewController(with: LanguageViewController())
        }
    }
    
    func updateDeviceToken(result: @escaping (Bool)-> ()){
        
        self.startAnimating()
        
        if let deviceToken = UserDefaults.standard.getPushyToken(){
            let url = EndPoints.updateDeviceToken.path
            let params = ["device_token":"\(deviceToken)", "app_version" : "3.1.0"]
            let heads = ["Authorization" : "\(jwtTkn)"]
            Alamofire.request(url, method: HTTPMethod.put, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
                
                switch response.result{
                case .success:
                    let status = response.response?.statusCode
                    print("Update device token response status : \(status ?? 0)")
                    
                    if status == 403 || status == 500{
                        self.removeData()
                        result(false)
                        
                    } else if status == 426 {
                        print("Update ios app")
                        self.showUpdateAlert()
                        result(false)
                        
                    } else if status == 200 || status == 201{
                        result(true)
                        
                    } else {
                        self.removeData()
                        result(false)
                    }
                    
                case .failure(let error):
                    print("\(error)")
                    self.showAlert(title: "Something went wrong!".localized(), message: "The connection to the server failed!".localized())
                    self.removeData()
                    result(false)
                }
                self.stopAnimating()
            }
        }
    }
    
    func removeData(){
        SocketManagerHandler.sharedInstance().disconnectSocket()
        self.logoutDeviceFromServer()
        jwtTkn = ""
        UserDefaults.standard.setToken(value: "")
        UserDefaults.standard.setIsLoggedIn(value: false)
        UserDefaults.standard.setUserData(value: NSDictionary())
//        UtilityClass.changeRootViewController(with: UINavigationController(rootViewController: LoginViewController()))
        UtilityClass.changeRootViewController(with: LanguageViewController())
    }
    
    @objc func showUpdateAlert(){
        let alert = UIAlertController(title: "Update Available!", message: "Please update MyanCare app!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "UPDATE", style: UIAlertAction.Style.default, handler: { (action) in
            print("redirect to app store")
            if let openUrl = URL(string: "itms://itunes.apple.com/app/apple-store/id1396490288?mt=8"){
                UIApplication.shared.open(openUrl, options: [:], completionHandler: nil)
            }
            self.showUpdateAlert()
        }))
        self.present(alert, animated: true, completion: nil)
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
                    self.showAlert(title: "Something went wrong!".localized(), message: "The connection to the server failed!".localized())
                }
                self.stopAnimating()
            }
        }
    }
    
    // MARK : Deinit
    deinit {
        print("StartScreen Deinit")
    }
}
