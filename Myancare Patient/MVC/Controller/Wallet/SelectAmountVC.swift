//
//  SelectAmountVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/4/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import NVActivityIndicatorView

class SelectAmountVC: UIViewController, NVActivityIndicatorViewable {
    
    let cellID = "cellID"
    var amountList = [ExchangeRateModel]()
    var gateWayName: String?{
        didSet{
            if let name = gateWayName{
                self.icon.image = UIImage(named: "\(name)")
                self.gateWayNameLabel.text = "Pay with \(name.capitalized)"
                self.infoLabel.text = "Please select the amount that you want to purchase to pay with \(name.capitalized)."
                self.getAllAmount("\(name)")
            }
        }
    }
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "kbz")
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .white
        img.layer.cornerRadius = 30 //size 60
        img.layer.borderColor = UIColor.gray.cgColor
        img.layer.borderWidth = 0.5
        img.clipsToBounds = true
        return img
    }()
    
    let gateWayNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Pay with KBZ"
        lbl.font = UIFont.mmFontBold(ofSize: 16)
        lbl.textColor = UIColor.black
        lbl.numberOfLines = 2
        return lbl
    }()
    
    let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Please select the amount that you want to purchase to pay with KBZ bank."
        lbl.font = UIFont.mmFontRegular(ofSize: 16)
        lbl.textColor = UIColor.black
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let costAmountLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Cost Amount"
        lbl.font = UIFont.mmFontBold(ofSize: 16)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let costLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Cost (Kyat)"
        lbl.font = UIFont.mmFontBold(ofSize: 16)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        return cv
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("CONFIRM", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
//        btn.addTarget(self, action: #selector(topUpBtnClick), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        self.title = "Select Amount"
        view.backgroundColor = .white
        
        collectionView.register(AmountCell.self, forCellWithReuseIdentifier: cellID)
        
        view.addSubview(icon)
        view.addSubview(gateWayNameLabel)
        view.addSubview(infoLabel)
        view.addSubview(lineView)
        view.addSubview(collectionView)
//        view.addSubview(confirmBtn)
        view.addSubview(costLabel)
        view.addSubview(costAmountLabel)
        
        let v = view.safeAreaLayoutGuide
        icon.anchor(v.topAnchor, left: v.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 60)
        gateWayNameLabel.anchor(icon.topAnchor, left: icon.rightAnchor, bottom: icon.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        infoLabel.anchor(icon.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 6, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        lineView.anchor(infoLabel.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0.5)
        costAmountLabel.anchor(lineView.bottomAnchor, left: v.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: view.bounds.width/2 - 4, heightConstant: 0)
        costLabel.anchor(lineView.bottomAnchor, left: costAmountLabel.rightAnchor, bottom: nil, right: v.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
//        confirmBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        collectionView.anchor(lineView.bottomAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 50, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        confirmBtn.isHidden = true
    }
}

extension SelectAmountVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amountList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AmountCell
        cell.amountData = amountList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let exchangeRate = amountList[indexPath.row]
        showConfirmActionSheet(exchangeRate)
    }
    
    func showConfirmActionSheet(_ exchangeRate:ExchangeRateModel){
        let actionSheet = UIAlertController(title: "Please confirm to request manuel payment", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmBtn = UIAlertAction(title: "Confirm", style: .default) { (action) in
            
            if (self.gateWayName?.contains("telenor"))!{
                self.requestAuthKeyForTelenorPayment()
            } else {
                self.requestTransactions(gateWay: exchangeRate.payment_gateway!, coin: exchangeRate.coin_amount!, amount: exchangeRate.kyat_amount!)
            }
        }
        
        actionSheet.addAction(confirmBtn)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension SelectAmountVC{
    
    func requestAuthKeyForTelenorPayment(){
        
        print("requesting auth key")
        
        self.startAnimating()
        
        let authUrl: URL = URL.init(string: "http://sandbox-apigw.mytelenor.com.mm/oauth/v1/userAuthorize?client_id=W7Ibwz5KXWOoAjTvfxPfa5EsSPAcV81J&response_type=code&scope=READ&redirect_uri=https://myancare.org/api/transactions/telenor/callback")!
        
        Alamofire.request(authUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { (response) in
            
            switch response.result{
            case .success:
                if let authKey = response.result.value{
                    print("Auth key : \(authKey)")
                    self.requestTokenForTelenorPayment(authKey: authKey)
                }
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
    func requestTokenForTelenorPayment(authKey:String){
        print("requesting token")
        
        self.startAnimating()
        
        let tokenUrl: URL = URL.init(string: "http://sandbox-apigw.mytelenor.com.mm/oauth/v1/token")!
        let heads = ["Content-Type" : "application/x-www-form-urlencoded"]
        let params = ["code" : authKey,
                      "grant_type" : "authorization_code",
                      "client_secret" : "kHLUe0zKcTdRHNhQ",
                      "client_id" : "W7Ibwz5KXWOoAjTvfxPfa5EsSPAcV81J",
                      "redirect_uri" : "https://myancare.org/api/transactions/telenor/callback"]
        Alamofire.request(tokenUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                if let responseData = response.result.value as? NSDictionary{
                    if let accessToken = responseData.object(forKey: "accessToken") as? String{
                        print("Token : \(accessToken)")
                        self.chargePaymentWithTelenorPayment(token: accessToken)
                    }
                }
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
    func chargePaymentWithTelenorPayment(token:String){
        
        print("requesting telenor payment charges")
        
        self.startAnimating()
        
        let heads = ["Content-Type" : "application/json",
                     "Authorization" : "Bearer \(token)"]
        let params = ["chargeMsisdn":"9790305105",
                      "clientTransactionId": "myancare59089",
                      "productCode": "MC_800",
                      "chargeAmount": 800,
                      "Cpid": 58,
                      "loginName": "myancare",
                      "password": "m49ncare",
                      "isContentProvider": true] as [String:Any]
        let url:URL = URL.init(string: "http://sandbox-apigw.mytelenor.com.mm/payments/v1/charge")!
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            print("\(response)")
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                print("\(responseStatus ?? 0)")
                if responseStatus == 201 || responseStatus == 200{
                    self.showAlert(title: "Success", message: "Your payment with telenor was success")
                } else {
                    self.showAlert(title: "Failed", message: "An error occured while requesting payment")
                }
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
    func requestTransactions(gateWay:String, coin:Int, amount:Int){
        
        self.startAnimating()
        
        let url = EndPoints.transactionsRequest.path
        let params = ["coin" : coin,
                      "amount" : amount,
        "payment_gateway" : gateWay] as [String:Any]
        let heads = ["Authorization":"\(jwtTkn)"]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                if responseStatus == 201 || responseStatus == 200{
                    self.showAlert(title: "Success", message: "Your manual payment was requested to Myancare!")
                } else {
                    self.showAlert(title: "Failed", message: "An error occured while requesting manual payment")
                }
                
            case .failure(let error):
                self.showAlert(title: "Failed", message: "An error occured while requesting manual payment")
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
    func getAllAmount(_ gateWayName: String){
        
        startAnimating()
        
        if let token = UserDefaults.standard.getToken(){
            let url = EndPoints.getExchangeRatesByPaymentGateway(gateWayName).path
            let heads = ["Authorization":"\(jwtTkn)"]
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
                
                switch response.result{
                case .success:
                    print("Success requesting payment amount...")
                    let responseStatus = response.response?.statusCode
                    print("Response status: \(responseStatus ?? 0)")
                    
                    if responseStatus == 400{
                        print("Record not found!")
                        
                    } else if responseStatus == 200{
                        print("Payment amounts for \(gateWayName) found!")
                        
                        if let responseDataArray = response.result.value as? NSArray{
                            for responseData in responseDataArray{
                                if let resData = responseData as? [String:Any]{
                                    let rate = ExchangeRateModel()
                                    rate.updateWithDict(resData)
                                    self.amountList.append(rate)
                                }
                            }
                            self.collectionView.reloadData()
                        }
                    }
                case .failure(let error):
                    print("Error requesting payment amount...")
                    print("\(error)")
                }
                self.stopAnimating()
            }
        }
    }
}


