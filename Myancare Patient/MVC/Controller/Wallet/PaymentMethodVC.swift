//
//  PaymentMethodVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/3/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

struct PaymentList {
    var paymentGroup = ""
    var paymentGateways: [PaymentRateModel]
}

class PaymentMethodVC: UIViewController, NVActivityIndicatorViewable {
    
    let cellID = "cellID"
    var paymentList = [PaymentList]()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
//        cv.allowsMultipleSelection = true
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getPaymentMethods()
    }
    
    func setupViews(){
        self.title = "Payment Methods".localized()
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        let v = view.safeAreaLayoutGuide
        collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        collectionView.register(PaymentRowCell.self, forCellWithReuseIdentifier: cellID)
    }
}

extension PaymentMethodVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paymentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PaymentRowCell
        cell.payments = paymentList[indexPath.row].paymentGateways
        cell.typeLabel.text = paymentList[indexPath.row].paymentGroup.replacingOccurrences(of: "_", with: " ")
        cell.paymentMethodVC = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellCount = paymentList[indexPath.row].paymentGateways.count
        let rowCount = cellCount / 4
        var heightCell:CGFloat = 130 //for 1 row
        
        if rowCount > 0 && rowCount <= 2{
            heightCell = 200
        } else if rowCount > 2 && rowCount <= 3{
            heightCell = 280
        }
        
        return CGSize(width: collectionView.bounds.width, height: heightCell)
    }
}

extension PaymentMethodVC{
    
    func getPaymentMethods(){
        
        self.startAnimating()
        
        let url = EndPoints.getPaymentMethods.path
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
                    
                    if let responseDataArray = response.result.value as? NSArray{
                        self.assignData(responseDataArray)
                    }
                }
            case .failure(let error):
                print("Error requesting payment amount...")
                print("\(error)")
                self.showAlert(title: "Something went wrong!".localized(), message: "The connection to the server failed!".localized())
            }
            self.stopAnimating()
        }
    }
    
    func assignData(_ dataArray:NSArray){
        
        var gateWayList = [PaymentList.init(paymentGroup: "PAY_WITH_CODA", paymentGateways: [PaymentRateModel]()),
                           PaymentList.init(paymentGroup: "PAY_WITH_BANKING", paymentGateways: [PaymentRateModel]())]
        
        for data in dataArray{
            if let dataDict = data as? [String:Any]{
                let paymentGateway = PaymentRateModel()
                paymentGateway.updateUsingDict(dataDict)
                
                switch paymentGateway.gatewayType{
                case "PAY_WITH_CODA":
                    gateWayList[0].paymentGateways.append(paymentGateway)
                case "PAY_WITH_BANKING":
                    gateWayList[1].paymentGateways.append(paymentGateway)
                default:
                    break
                }
            }
        }
        paymentList = gateWayList
        self.collectionView.reloadData()
    }
}
