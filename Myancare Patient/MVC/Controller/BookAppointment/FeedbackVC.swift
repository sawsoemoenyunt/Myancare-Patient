//
//  FeedbackVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/22/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class FeedbackVC: UIViewController, NVActivityIndicatorViewable {
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.subtitle1
        return lbl
    }()
    
    let star1: UIImageView = {
       let img = UIImageView()
        img.backgroundColor = UIColor.gray
        img.contentMode = .scaleAspectFill
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(star1Click)))
        return img
    }()
    
    @objc func star1Click(){
        
    }
    
    let feedbackTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.MyanCareFont.type4
        return tv
    }()
    
    lazy var submitBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("SUBMIT", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupViews(){
        
    }
}


