//
//  LanguageViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/24/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Localize_Swift

/// Language view controller to choose langauge : Available languages -> English/Myanmar
class LanguageViewController: UIViewController {
    
    /// UIImageView for display icon
    let icon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "icons8-language_filled")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    /// UILabel for select language
    let label: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.mmFontBold(ofSize: 28)
        lbl.textColor = UIColor.MyanCareColor.gray
        lbl.text = "Select Language".localized()
        lbl.textAlignment = .center
        return lbl
    }()
    
    /// UILabel for Myancare's info text
    let label2: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = UIColor.MyanCareColor.lightGray
        lbl.text = "Copyright 2019 All rights reserved by\nMyanCare\nVersion 3.0"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    /// Custom UIButton for Myanmare language
    lazy var mmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("မြန်မာ", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.orange
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(mmBtnClick), for: .touchUpInside)
        return btn
    }()
    
    /**
     To handle mmBtn click action
     - Parameters: nil
     - Returns: nil
     */
    @objc func mmBtnClick(){
        Localize.setCurrentLanguage("my")
        pushToNextView()
    }
    
    /// Custom UIButton for English language
    lazy var engBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("English", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(engBtnClick), for: .touchUpInside)
        return btn
    }()
    
    /**
     To handle engBtn click action
     - Parameters: nil
     - Returns: nil
     */
    @objc func engBtnClick(){
        Localize.setCurrentLanguage("eng")
        pushToNextView()
    }
    
    /**
     To show next View
     - Parameters: nil
     - Returns: nil
     */
    func pushToNextView(){
       //show loginview
        UtilityClass.changeRootViewController(with: UINavigationController(rootViewController: LoginViewController()))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
    }
    
    /**
     Setup for subviews
     - Parameters: nil
     - Returns: nil
     */
    func setupViews(){
        //add subviews to view
        view.addSubview(icon)
        view.addSubview(label)
        view.addSubview(mmBtn)
        view.addSubview(engBtn)
        view.addSubview(label2)
        
        //setup constraints
        mmBtn.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 287, heightConstant: 50)
        mmBtn.anchorCenterSuperview()
        engBtn.anchor(mmBtn.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 287, heightConstant: 50)
        engBtn.anchorCenterXToSuperview()
        
        label.anchor(nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: mmBtn.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 60, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        icon.anchor(nil, left: nil, bottom: label.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 40, rightConstant: 0, widthConstant: 90, heightConstant: 90)
        icon.anchorCenterXToSuperview()
        
        label2.anchor(nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        label2.anchorCenterXToSuperview()
    }
}
