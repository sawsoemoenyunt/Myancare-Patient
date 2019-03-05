//
//  VideoCallVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/5/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class VideoCallVC: UIViewController {
    
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
        lbl.text = "Ringing..."
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
    
    let localView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let remoteView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var hangupButtonLeftConstraint:NSLayoutConstraint?
    var muteButtonRightConstraint:NSLayoutConstraint?
    var doctorImageTopConstraint: NSLayoutConstraint?
    var localViewHeightConstraint: NSLayoutConstraint?
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
        btn.layer.cornerRadius = 23 //46
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var speakerBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("S", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 23 //46
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var cameraFlipBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("CF", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.gray
        btn.layer.cornerRadius = 23 //46
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var someBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("SC", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.gray
        btn.layer.cornerRadius = 23 //46
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(localViewOnOff), for: .touchUpInside)
        return btn
    }()
    
    var localViewIsOn = true
    @objc func localViewOnOff(){
        if localViewIsOn {
            localViewHeightConstraint?.constant = 0
            localViewIsOn = false
            someBtn.setTitle("HC", for: .normal)
        } else {
            localViewHeightConstraint?.constant = 190
            localViewIsOn = true
            someBtn.setTitle("SC", for: .normal)
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    let centerView: UIView = {
       let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(secondLayout), userInfo: nil, repeats: false)
        
    }
    
    func setupViews(){
        
        view.backgroundColor = .white
        doctorImage.tag = 103
        view.addSubview(doctorImage)
        doctornamelabel.tag = 102
        view.addSubview(doctornamelabel)
        callinglabel.tag = 101
        view.addSubview(callinglabel)
        hangupBtn.tag = 100
        view.addSubview(hangupBtn)
        
        
        let v = view.safeAreaLayoutGuide
        doctorImageTopConstraint = doctorImage.anchorWithReturnAnchors(v.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 120)[0]
        doctorImage.anchorCenterXToSuperview()
        doctornamelabel.anchor(doctorImage.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        callinglabel.anchor(doctornamelabel.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 30, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        hangupBtn.anchor(nil, left: nil, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 40, rightConstant: 0, widthConstant: 70, heightConstant: 70)
        hangupBtn.anchorCenterXToSuperview()
    }
    
    @objc func secondLayout(){
        
        doctorImageTopConstraint?.constant = 100
        
        //animate view
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { (true) in
            //after animation
        }
        
        //remove firt added views
        view.viewWithTag(100)?.removeFromSuperview()
        view.viewWithTag(101)?.removeFromSuperview()
        view.viewWithTag(102)?.removeFromSuperview()
        view.viewWithTag(103)?.removeFromSuperview()
        
        //add subviews
        view.addSubview(remoteView)
        view.addSubview(localView)
        view.addSubview(doctornamelabel)
        view.addSubview(callinglabel)
        view.addSubview(hangupBtn)
        view.addSubview(muteBtn)
        view.addSubview(speakerBtn)
        view.addSubview(someBtn)
        view.addSubview(cameraFlipBtn)
        view.addSubview(centerView)
        
        let v = view.safeAreaLayoutGuide
        
        remoteView.fillSuperview()
        cameraFlipBtn.anchor(v.topAnchor, left: nil, bottom: nil, right: v.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 46, heightConstant: 46)
        someBtn.anchor(v.topAnchor, left: nil, bottom: nil, right: cameraFlipBtn.leftAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 30, widthConstant: 46, heightConstant: 46)
        muteBtn.anchor(v.topAnchor, left: v.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 46, heightConstant: 46)
        localViewHeightConstraint = localView.anchorWithReturnAnchors(cameraFlipBtn.bottomAnchor, left: nil, bottom: nil, right: v.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 140, heightConstant: 190).last
        callinglabel.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 130, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        doctornamelabel.anchor(nil, left: v.leftAnchor, bottom: callinglabel.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 20, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        centerView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 10, heightConstant: 1)
        centerView.anchorCenterXToSuperview()
        hangupBtn.anchor(nil, left: centerView.rightAnchor, bottom: v.bottomAnchor, right: nil, topConstant: 0, leftConstant: 30, bottomConstant: 30, rightConstant: 0, widthConstant: 56, heightConstant: 56)
        hangupBtn.layer.cornerRadius = 28
        speakerBtn.anchor(nil, left: nil, bottom: v.bottomAnchor, right: centerView.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 30, rightConstant: 30, widthConstant: 56, heightConstant: 56)
        speakerBtn.layer.cornerRadius = 28
        
        self.view.alpha = 0
        //animate subviews
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.alpha = 1
        }, completion: nil)
        
        //start timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
}

