//
//  LanguageViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/24/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Localize_Swift

class LanguageViewController: UIViewController {
    
    //icon
    let icon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "icons8-language_filled")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    //select language label
    let label: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.mmFontBold(ofSize: 28)
        lbl.textColor = UIColor.MyanCareColor.gray
        lbl.text = "Select Language".localized()
        lbl.textAlignment = .center
        return lbl
    }()
    
    //select language label
    let label2: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = UIColor.MyanCareColor.lightGray
        lbl.text = "Copyright 2019 All rights reserved by\nMyanCare\nVersion 3.0"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    //custom button choosing language : Myanmar
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
    
    //Handle mmBtn action : set localization to Myanmar
    @objc func mmBtnClick(){
        Localize.setCurrentLanguage("my")
        pushToNextView()
    }
    
    //custom button choosing language : English
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
    
    //Handle engBtn action : set localization to English
    @objc func engBtnClick(){
        Localize.setCurrentLanguage("eng")
        pushToNextView()
    }
    
    func pushToNextView(){
       //show loginview
        UtilityClass.changeRootViewController(with: UINavigationController(rootViewController: LoginViewController()))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
    }
    
    //function for setupviews
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
