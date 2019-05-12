//
//  WalletVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/3/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class WalletVC: UIViewController, NVActivityIndicatorViewable {
    
    let cellID = "cellID"
    var walletbalance = "0"
    var paymentHistories = [PaymentHistoryModel]()
    var isPaging = true
    
    let coinlabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "8000 Coin"
        lbl.numberOfLines = 1
        lbl.font = UIFont.MyanCareFont.title
        lbl.textColor = UIColor.black
        lbl.textAlignment = .center
        lbl.minimumScaleFactor = 10/UIFont.labelFontSize
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    let statusLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "coin"
        lbl.numberOfLines = 1
        lbl.font = UIFont.mmFontRegular(ofSize: 14)
        lbl.textColor = UIColor.MyanCareColor.gray
        return lbl
    }()
    
    lazy var topUpBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Top up".localized().uppercased(), for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(topUpBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return cv
    }()
    
    lazy var refreshControl1 : UIRefreshControl = {
        let  rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshDoctorData), for: .valueChanged)
        return rc
    }()
    
    @objc func refreshDoctorData() {
        paymentHistories.removeAll()
        isPaging = true
        getTransactions()
        self.refreshControl1.endRefreshing()
    }
    
    @objc func topUpBtnClick(){
       self.navigationController?.pushViewController(PaymentMethodVC(), animated: true)
    }
    
    let headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Transaction History".localized()
        lbl.numberOfLines = 0
        lbl.font = UIFont.mmFontBold(ofSize: 20)
        lbl.textColor = UIColor.MyanCareColor.gray
        return lbl
    }()
    
    lazy var headerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(headerLabel)
        headerLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Wallet".localized()
        view.backgroundColor = .white
        collectionView.register(WalletCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.refreshControl = refreshControl1
        
        setupViews()
        setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.getWalletAmount()
    }
    
    func setupData(){
        setupAttributeString()
        getTransactions()
    }
    
    func setupViews(){
        view.addSubview(coinlabel)
        view.addSubview(topUpBtn)
        view.addSubview(collectionView)
        view.addSubview(headerView)
        
        let v = view.safeAreaLayoutGuide
        coinlabel.anchor(v.topAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 100)
        topUpBtn.anchor(coinlabel.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        headerView.anchor(topUpBtn.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        collectionView.anchor(headerView.bottomAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 5, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
    }
    
    func setupAttributeString(){
        let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.mmFontBold(ofSize: 42)]
        let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.mmFontRegular(ofSize: 14)]
        
        let coinAmount = NSMutableAttributedString(string: "\(walletbalance)", attributes: yourAttributes)
        let cointStatus = NSMutableAttributedString(string: " coin", attributes: yourOtherAttributes)
        
        let combination = NSMutableAttributedString()
        
        combination.append(coinAmount)
        combination.append(cointStatus)
        coinlabel.attributedText = combination
    }
}

extension WalletVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if paymentHistories.count == 0 {
            let notDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height))
            notDataLabel.text = "No transaction found".localized()
            notDataLabel.textColor = UIColor.MyanCareColor.darkGray
            notDataLabel.textAlignment = .center
            notDataLabel.font = UIFont.MyanCareFont.type6
            collectionView.backgroundView = notDataLabel
        }else{
            collectionView.backgroundView = UILabel()
        }
        return paymentHistories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! WalletCell
        
        if paymentHistories.count > 0{
            cell.transactionData = paymentHistories[indexPath.row]
        }
        
        if indexPath.row > paymentHistories.count - 1{
            isPaging = true
            getTransactions()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 90)
    }
}

extension WalletVC{
    
    func getWalletAmount(){
        self.startAnimating()
        
        let url = EndPoints.getUserWallet.path
        let heads = ["Authorization":"\(jwtTkn)"]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseString { (response) in
            
            switch response.result{
            case .success:
                if let walletAmount = response.result.value{
                    self.walletbalance = walletAmount
                    self.setupAttributeString()
                }
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
    func getTransactions(){
        
        startAnimating()
        
        let skip  = paymentHistories.count != 0 ? paymentHistories.count : 0
        let url = EndPoints.get_transactions(skip, 20).path // skip, limit
        
        if let token = UserDefaults.standard.getToken(){
            let heads = ["Authorization":"\(jwtTkn)"]
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
                
                print("Response raw : \(response)")
                
                switch response.result{
                case .success:
                    print("success getting trnasaction history from server...")
                    
                    let responseStatus = response.response?.statusCode
                    
                    if responseStatus == 400{
                        print("Transaction record not found!")
                        
                    } else if responseStatus == 200{
                        if let responseDataArray = response.result.value as? NSArray{
                            for responseData in responseDataArray{
                                if let resData = responseData as? [String:Any]{
                                    let paymentHistory = PaymentHistoryModel()
                                    paymentHistory.updateUsingDictionary(resData)
                                    
                                    self.paymentHistories.append(paymentHistory)
                                }
                            }
                            self.isPaging = responseDataArray.count > 0 ? true : false
                            self.collectionView.reloadData()
                        }
                    }
                    
                case .failure(let error):
                    print("Faild to get transaction history from server...")
                    print("\(error)")
                }
            }
            self.stopAnimating()
        }
    }
}


