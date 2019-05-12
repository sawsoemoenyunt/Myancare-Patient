//
//  ShareBookVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/11/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit


//share medical book view controller
class ShareBookVC: UIViewController{
    
    var doctorID = ""
    
    let icon: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(named: "u4160")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = .gray
        return img
    }()
    
    let sharelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "SHARE MEDICAL BOOK"
        lbl.numberOfLines = 0
        lbl.font = UIFont.MyanCareFont.title
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.textAlignment = .center
        return lbl
    }()
    
    let infolabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "ယခုရက်ချိန်းယူသောဆရာဝန်အား သင်သိမ်းဆည်း ထားသောဆေးမှတ်တမ်းများကိုပြသ၍ဆွေးနွေးဖို့ လိုအပ်ပါက ၄င်းမှတ်တမ်းများကိုရွေးချယ်ပါ"
        lbl.numberOfLines = 0
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var chooseBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Select medical record".localized(), for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(handleChooseBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleChooseBtnClick(){
        let selectBookVC = SelectBookVC()
        selectBookVC.doctorID = self.doctorID
        self.navigationController?.pushViewController(selectBookVC, animated: true)
    }
    
    lazy var skipBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Skip".localized(), for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.yellow
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(skipBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func skipBtnClick(){
        UtilityClass.switchToHomeViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func setupViews(){
        view.backgroundColor = .white
        
        view.addSubview(icon)
        view.addSubview(sharelabel)
        view.addSubview(infolabel)
        view.addSubview(chooseBtn)
        view.addSubview(skipBtn)
        
        let v = view.safeAreaLayoutGuide
        skipBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        chooseBtn.anchor(nil, left: v.leftAnchor, bottom: skipBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 10, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        
        sharelabel.anchorCenterSuperview()
        icon.anchor(nil, left: nil, bottom: sharelabel.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 135, heightConstant: 135)
        icon.anchorCenterXToSuperview()
        infolabel.anchor(sharelabel.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
    }
}

