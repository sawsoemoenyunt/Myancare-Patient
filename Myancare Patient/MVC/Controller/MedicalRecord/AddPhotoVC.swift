//
//  AddPhotoVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/11/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class AddPhotoVC: UIViewController {
    
    var recordBookID = ""
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "hand-camera")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let photolabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "ADD PHOTO"
        lbl.numberOfLines = 0
        lbl.font = UIFont.MyanCareFont.title
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.textAlignment = .center
        return lbl
    }()
    
    let infolabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "သင်ရဲ့ဆေးမှတ်တမ်းများကို ဓါတ်ပုံရိုက်ယူ၍\nထည့်သွင်းသိမ်းဆည်းထားနိုင်ပါသည်။"
        lbl.numberOfLines = 0
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var chooseBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("SELECT PHOTO", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(handleChooseBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleChooseBtnClick(){
        
    }
    
    lazy var skipBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("CHOOSE LATER", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.setTitleColor(UIColor.MyanCareColor.green, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.MyanCareColor.green.cgColor
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        //        btn.addTarget(self, action: #selector(confrimBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func skipBtnClick(){
        self.navigationController?.pushViewController(PhotoGalleryVC(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        view.backgroundColor = .white
        
        view.addSubview(icon)
//        view.addSubview(photolabel)
//        view.addSubview(infolabel)
        view.addSubview(chooseBtn)
        view.addSubview(skipBtn)
        
        let v = view.safeAreaLayoutGuide
        chooseBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        skipBtn.anchor(nil, left: v.leftAnchor, bottom: chooseBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 10, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        
//        photolabel.anchorCenterSuperview()
        icon.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width, heightConstant: 300)
        icon.anchorCenterSuperview()
//        infolabel.anchor(photolabel.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
    }
}
