//
//  PatientFeedbackVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 5/8/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class PatientFeedbackVC: UIViewController, NVActivityIndicatorViewable {
    
    var patientID = ""
    var doctorID = ""
    var rating = 1
    var comment = ""
    
    let infolabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Are you satisfied to our doctor?"
        lbl.font = UIFont.MyanCareFont.subtitle1
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var star1 : UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "icons8-star").withRenderingMode(.alwaysTemplate)
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.tintColor = UIColor.MyanCareColor.darkGray
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(star1Click)))
        return img
    }()
    
    @objc func star1Click(){
        star1.image = #imageLiteral(resourceName: "icons8-filled_star")
        star2.image = #imageLiteral(resourceName: "icons8-star")
        star3.image = #imageLiteral(resourceName: "icons8-star")
        star4.image = #imageLiteral(resourceName: "icons8-star")
        star5.image = #imageLiteral(resourceName: "icons8-star")
        rating = 1
    }
    
    lazy var star2 : UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "icons8-star").withRenderingMode(.alwaysTemplate)
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.tintColor = UIColor.MyanCareColor.darkGray
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(star2Click)))
        return img
    }()
    
    @objc func star2Click(){
        star1.image = #imageLiteral(resourceName: "icons8-filled_star")
        star2.image = #imageLiteral(resourceName: "icons8-filled_star")
        star3.image = #imageLiteral(resourceName: "icons8-star")
        star4.image = #imageLiteral(resourceName: "icons8-star")
        star5.image = #imageLiteral(resourceName: "icons8-star")
        rating = 2
    }
    
    lazy var star3 : UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "icons8-star").withRenderingMode(.alwaysTemplate)
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.tintColor = UIColor.MyanCareColor.darkGray
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(star3Click)))
        return img
    }()
    
    @objc func star3Click(){
        star1.image = #imageLiteral(resourceName: "icons8-filled_star")
        star2.image = #imageLiteral(resourceName: "icons8-filled_star")
        star3.image = #imageLiteral(resourceName: "icons8-filled_star")
        star4.image = #imageLiteral(resourceName: "icons8-star")
        star5.image = #imageLiteral(resourceName: "icons8-star")
        rating = 3
    }
    
    lazy var star4 : UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "icons8-star").withRenderingMode(.alwaysTemplate)
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.tintColor = UIColor.MyanCareColor.darkGray
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(star4Click)))
        return img
    }()
    
    @objc func star4Click(){
        star1.image = #imageLiteral(resourceName: "icons8-filled_star")
        star2.image = #imageLiteral(resourceName: "icons8-filled_star")
        star3.image = #imageLiteral(resourceName: "icons8-filled_star")
        star4.image = #imageLiteral(resourceName: "icons8-filled_star")
        star5.image = #imageLiteral(resourceName: "icons8-star")
        rating = 4
    }
    
    lazy var star5 : UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "icons8-star").withRenderingMode(.alwaysTemplate)
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.tintColor = UIColor.MyanCareColor.darkGray
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(star5Click)))
        return img
    }()
    
    @objc func star5Click(){
        star1.image = #imageLiteral(resourceName: "icons8-filled_star")
        star2.image = #imageLiteral(resourceName: "icons8-filled_star")
        star3.image = #imageLiteral(resourceName: "icons8-filled_star")
        star4.image = #imageLiteral(resourceName: "icons8-filled_star")
        star5.image = #imageLiteral(resourceName: "icons8-filled_star")
        rating = 5
    }
    
    let reasonTextView: UITextView = {
        let tv = UITextView()
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.layer.borderWidth = 1
        return tv
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("CONFIRM", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(confirmBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func confirmBtnClick(){
        comment = reasonTextView.text!

        sendFeedback()
    }
    
    override func viewDidLoad() {
        self.title = ""
        setupViews()
    }
    
    func setupViews(){
        view.backgroundColor = UIColor.white
        view.addSubview(infolabel)
        view.addSubview(star1)
        view.addSubview(star2)
        view.addSubview(star3)
        view.addSubview(star4)
        view.addSubview(star5)
        view.addSubview(reasonTextView)
        view.addSubview(confirmBtn)
        
        let v = view.safeAreaLayoutGuide
        infolabel.anchor(v.topAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        star1.anchor(infolabel.bottomAnchor, left: v.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 35, heightConstant: 35)
        star2.anchor(star1.topAnchor, left: star1.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 35, heightConstant: 35)
        star3.anchor(star1.topAnchor, left: star2.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 35, heightConstant: 35)
        star4.anchor(star1.topAnchor, left: star3.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 35, heightConstant: 35)
        star5.anchor(star1.topAnchor, left: star4.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 35, heightConstant: 35)
        reasonTextView.anchor(star1.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 30, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 150)
        confirmBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
    }
}

extension PatientFeedbackVC{
    func sendFeedback(){
        self.startAnimating()
        
        let url = EndPoints.feebacks.path
        let heads = ["Authorization":"\(jwtTkn)"]
        let params = ["doctor" : self.doctorID,
                      "patient" : self.patientID,
                      "comment" : self.comment,
                      "rating" : self.rating
        ] as [String:Any]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let statusCode = response.response?.statusCode
                if statusCode == 200 || statusCode == 201{
                    let alert = UIAlertController(title: "Success", message: "Your feedback was successfully send!", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (response) in
//                        self.navigationController?.popViewController(animated: true)
                        let layout = UICollectionViewFlowLayout()
                        let homeVC = HomeViewController(collectionViewLayout:layout)
                        let navController = UINavigationController(rootViewController: homeVC)
                        homeVC.pushToVC(vc: AppointmentListViewController())
                        UtilityClass.changeRootViewController(with: navController)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    self.showAlert(title: "Failed", message: "Failed to send your feedback!")
                }
                
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
}
