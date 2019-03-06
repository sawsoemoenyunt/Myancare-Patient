//
//  VioceCallVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/5/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class VoiceCallVC: UIViewController {
    
    let doctorImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = UIColor.gray
        img.layer.cornerRadius = 60 //size 120
        img.clipsToBounds = true
        return img
    }()
    
    let doctornamelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dr.Kaung Mon"
        lbl.font = UIFont.mmFontBold(ofSize: 22)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let callinglabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Calling..."
        lbl.font = UIFont.mmFontBold(ofSize: 18)
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var hangupBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("X", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.red
        btn.layer.cornerRadius = 35 //70
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(hangupBtnClick), for: .touchUpInside)
        return btn
    }()
    
    var hangupButtonLeftConstraint:NSLayoutConstraint?
    var muteButtonRightConstraint:NSLayoutConstraint?
    var timer = Timer()
    
    @objc func hangupBtnClick(){
        timer.invalidate()
        callinglabel.text = "Call Ended "+callinglabel.text!
    }
    
    var min = 0
    var sec = 0
    @objc func timerAction(){
        sec = sec + 1
        
        if sec == 60 {
            min = min + 1
            sec = 0
        }
        
        let minuteString = String(min).count == 1 ? "0\(min)" : String(min)
        let secondString = String(sec).count == 1 ? "0\(sec)" : String(sec)
        callinglabel.text = minuteString+" : "+secondString
    }
    
    func animateViews(){
        
        hangupButtonLeftConstraint?.constant = 30
        muteButtonRightConstraint?.constant = -30
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    lazy var muteBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("M", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.gray
        btn.layer.cornerRadius = 35 //70
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var speakerBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("S", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 35 //70
        btn.clipsToBounds = true
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(animateButtons), userInfo: nil, repeats: false)
        
    }
    
    @objc func animateButtons(){
        //timer start
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        //remove first hangupbutton constraint
        view.viewWithTag(100)?.removeFromSuperview()
        view.viewWithTag(101)?.removeFromSuperview()
        view.viewWithTag(102)?.removeFromSuperview()
        
        //add more button
        view.addSubview(muteBtn)
        view.addSubview(speakerBtn)
        view.addSubview(hangupBtn)
        
        let v = view.safeAreaLayoutGuide
        speakerBtn.anchor(nil, left: nil, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 40, rightConstant: 0, widthConstant: 70, heightConstant: 70)
        speakerBtn.anchorCenterXToSuperview()
        hangupButtonLeftConstraint = hangupBtn.anchorWithReturnAnchors(nil, left: speakerBtn.rightAnchor, bottom: speakerBtn.bottomAnchor, right: nil, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 56, heightConstant: 56)[0]
        hangupBtn.layer.cornerRadius = 28
        muteButtonRightConstraint = muteBtn.anchorWithReturnAnchors(nil, left: nil, bottom: speakerBtn.bottomAnchor, right: speakerBtn.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 30, widthConstant: 70, heightConstant: 70)[1]
        
        hangupButtonLeftConstraint?.constant = -100
        muteButtonRightConstraint?.constant = 100
        animateViews()
    }
    
    func setupViews(){
        
        view.backgroundColor = .white
        view.addSubview(doctorImage)
        view.addSubview(doctornamelabel)
        view.addSubview(callinglabel)
        speakerBtn.tag = 102
        view.addSubview(speakerBtn)
        muteBtn.tag = 101
        view.addSubview(muteBtn)
        hangupBtn.tag = 100
        view.addSubview(hangupBtn)
        
        
        let v = view.safeAreaLayoutGuide
        doctorImage.anchor(v.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 120)
        doctorImage.anchorCenterXToSuperview()
        doctornamelabel.anchor(doctorImage.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        callinglabel.anchor(doctornamelabel.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 30, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        muteBtn.anchor(nil, left: nil, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 40, rightConstant: 0, widthConstant: 56, heightConstant: 56)
        muteBtn.layer.cornerRadius = 28
        muteBtn.anchorCenterXToSuperview()
        speakerBtn.anchor(nil, left: nil, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 40, rightConstant: 0, widthConstant: 56, heightConstant: 56)
        speakerBtn.anchorCenterXToSuperview()
        speakerBtn.layer.cornerRadius = 28
        hangupBtn.anchor(nil, left: nil, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 40, rightConstant: 0, widthConstant: 70, heightConstant: 70)
        hangupBtn.anchorCenterXToSuperview()
    }
}
