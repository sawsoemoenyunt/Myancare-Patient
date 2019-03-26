//
//  LoginViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/24/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Alamofire
import AccountKit
import PKHUD
import NVActivityIndicatorView

///Login View Controller to choose login with Facebook or Mobile phone
class LoginViewController: UIViewController, NVActivityIndicatorViewable {
    
    var _accountKit: AKFAccountKit!
    
    /// Cell id for collectionView
    let cellID = "cellID"
    let pages = ["page1", "page2", "page3", "page4", "page5"]
    var countryCode = "95"
    var pohoneID = ""
    var facebookID = ""
    
    
    /// UIPageControl for walk through
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor.MyanCareColor.green
        pc.numberOfPages = pages.count
        return pc
    }()
    
    /// CollectionView to show walk through
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    /// Custom facebook login button
    lazy var fbBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Login with Facebook".localized(), for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.fbBlue
        btn.layer.cornerRadius = 25
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(fbBtnClick), for: .touchUpInside)
        return btn
    }()
    
    /// Custom mobile login button
    lazy var mobileBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Login with Mobile", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 16)
        btn.setTitleColor(UIColor.MyanCareColor.gray, for: .normal)
        btn.addTarget(self, action: #selector(mobileBtnClick), for: .touchUpInside)
        return btn
    }()
    
    /// Line
    let lineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.MyanCareColor.lightGray
        return view
    }()
    
    /// Moblie phone login button bottom constraint
    var loginbtnBottomConstraint: NSLayoutConstraint?
    
    /**
     To handle fbBtn click action
     - Parameters: nil
     - Returns: nil
     */
    @objc func fbBtnClick(){
//        self.navigationController?.pushViewController(UserInformationVC(), animated: true)
        facebookLogin()
    }
    
    func facebookLogin(){
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success:
                print("Logged in!")
                self.getFBUserData()
            }
        }
    }
    
    func getFBUserData(){
        let connection = GraphRequestConnection()
        connection.add(MyProfileRequest()) { response, result in
            switch result {
            case .success(let response):
                print("Custom Graph Request Succeeded: \(response)")
                print("Fblogin id was : \(String(describing: response.facebookId)) and name is \(String(describing: response.facebookName))")
                self.facebookID = response.facebookId!
                self.ischeckFB(isFB: true, id: response.facebookId!)
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
    
    struct MyProfileRequest: GraphRequestProtocol {
        struct Response: GraphResponseProtocol {
            var facebookId : String?
            var facebookName : String?
            var facebookEmail : String?
            init(rawResponse: Any?) {
                // Decode JSON from rawResponse into other properties here.
                if let rawResponse = rawResponse as? [String:String]{
                    facebookId = rawResponse["id"]
                    facebookName = rawResponse["name"]
                    facebookEmail = rawResponse["email"]
                }
            }
        }
        
        var graphPath = "/me"
        var parameters: [String : Any]? = ["fields": "id, name"]
        var accessToken = AccessToken.current
        var httpMethod: GraphRequestHTTPMethod = .GET
        var apiVersion: GraphAPIVersion = .defaultVersion
    }
    
    func ischeckFB(isFB:Bool, id:String){
        
        startAnimating()
        
        let urlToHit = isFB == true ? EndPoints.checkfb(id).path : EndPoints.checkmobile(id).path
        let header = ["Content-Type":"application/json"]
        
        Alamofire.request(urlToHit, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            print("This is requrest url : \(String(describing: response.request))")
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                print("Response status: \(responseStatus ?? 0)")
                
                if responseStatus == 404{
                    //register user process here
                    print("RECORD NOT FOUND")
                    if isFB {
                        self.mobileLogin()
                    } else {
                        if id != ""{
                            let userInfoVC = UserInformationVC()
                            userInfoVC.phoneID = id
                            userInfoVC.countryCode = self.countryCode
                            userInfoVC.facebookID = self.facebookID
                            
                            self.navigationController?.pushViewController(userInfoVC, animated: true)
                        }
                    }
                    
                } else if responseStatus == 200{
                    //apply login process here
                    print("RECORD WAS FOUND")
                    if let responseData = response.result.value as? NSDictionary{
                        if let userToken = responseData.object(forKey: "token") as? String{
                            print("USER TOKEN WAS : \(userToken)")
                            UserDefaults.standard.setToken(value: userToken)
                        }
                        
                        if let userData = responseData.object(forKey: "user") as? [String:Any]{
                            let user = PatientModel()
                            user.updateModel(usingDictionary: userData)
                            print("User data -> \(userData)")
                            
                            let info:NSDictionary = ["name":user.name!, "wallet_balance":user.wallet_balance!, "image_url":user.image_url!,
                                                     "height":user.height!,
                                                     "age":user.age!,
                                                     "weight":user.weight!,
                                                     "facebook_id":user.facebook_id!,
                                                     "country_code":user.country_code!,
                                                     "_id":user._id!,
                                                     "createdAt":user.createdAt!,
                                                     "gender":user.gender!,
                                                     "dob":user.dob!,
                                                     "email":user.email!,
                                                     "mobile":user.mobile!,
                                                     "blood_type":user.bloodType!,
                                                     "username":user.username!,
                                                     "updatedAt":user.updatedAt!]
                            UserDefaults.standard.setUserData(value: info)
                            UserDefaults.standard.setIsLoggedIn(value: true)
                            UtilityClass.switchToHomeViewController()
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
            self.stopAnimating()
        }
        
    }
    
    @objc func mobileBtnClick(){
        mobileLogin()
    }
    
    func mobileLogin()
    {
        let inputState = UUID().uuidString
        let vc = (_accountKit?.viewControllerForPhoneLogin(with: nil, state: inputState))!
        vc.enableSendToFacebook = true
        self.prepareLoginViewController(loginViewController: vc)
        self.present(vc as UIViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        collectionView.register(WalkthroughCell.self, forCellWithReuseIdentifier: cellID)
        
        if _accountKit == nil {
            _accountKit = AKFAccountKit(responseType: .accessToken)
        }
        _accountKit.logOut()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        setupViews()
        
        _accountKit.requestAccount {
            (account, error) -> Void in
            
            if let phoneNumber = account?.phoneNumber{
                print("phoneNumber \(phoneNumber.countryCode)\(phoneNumber.phoneNumber)")
                self.countryCode = phoneNumber.countryCode
                self.ischeckFB(isFB: false, id: "\(phoneNumber.phoneNumber)")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        animateViews()
        
        showLoading()
    }
    
    /**
     To setup view and subviews
     - Parameters: nil
     - Returns: nil
     */
    func setupViews(){
        
        //add subviews to view
        view.addSubview(collectionView)
        view.addSubview(lineView)
        view.addSubview(fbBtn)
        view.addSubview(mobileBtn)
        view.addSubview(pageControl)
        
        //setup contraints of subviews
         loginbtnBottomConstraint = mobileBtn.anchorWithReturnAnchors(nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 0, widthConstant: 287, heightConstant: 30)[0]
        mobileBtn.anchorCenterXToSuperview()
        fbBtn.anchor(nil, left: nil, bottom: mobileBtn.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 287, heightConstant: 50)
        fbBtn.anchorCenterXToSuperview()
        lineView.anchor(nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: fbBtn.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 50, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        collectionView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: lineView.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        pageControl.anchor(lineView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        pageControl.anchorCenterXToSuperview()
        
        loginbtnBottomConstraint?.constant = 150
    }
    
    /**
     Animated views
     - Parameters: nil
     - Returns: nil
     */
    func animateViews(){
        
        loginbtnBottomConstraint?.constant = -20
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func showLoading() {
        startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Loading...")
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.stopAnimating()
        }
    }
    
    func showAlert(title:String, message:String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: AKFViewControllerDelegate{
    
    func prepareLoginViewController(loginViewController: AKFViewController) {
        loginViewController.delegate = self
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        print("did complete login with access token \(accessToken.tokenString) state \(String(describing: state))")
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        print("did complete login with authorizationcode \(String(describing: code))")
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        print("\(String(describing: viewController)) did fail with error: \(error.localizedDescription)")
    }
    
    func viewController(viewController: UIViewController!, didFailWithError error: NSError!) {
        print(error)
    }
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        print("error")
    }
}

///LoginViewController's extension for collection view
extension LoginViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! WalkthroughCell
        cell.image.image = UIImage(named: pages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
    }
}
