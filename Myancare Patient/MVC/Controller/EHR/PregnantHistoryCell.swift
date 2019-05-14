//
//  PregnantHistoryCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 5/6/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class PrefnantHistoryCell: UICollectionViewCell, UITextFieldDelegate {
    
    var isSwitchOn = false
    var ehrVC : EHRListVC?
    var dataList: [Disease]?{
        didSet{
            if let data = dataList{
                if data.count == 2{
                    
                    label1.text = data[0].name!
                    childrenLabel.text = data[1].name!
                    
                    isSwitchOn = data[0].checked!
                    answerSwitch.isOn = isSwitchOn
                    childrenAmountTextField.text = "\(data[1].data!)"
                }
            }
        }
    }
    
    let titlelabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type1
        lbl.textColor = UIColor.black
        lbl.numberOfLines = 2
        lbl.text = "သားဖွား၊ မီးယပ်ရာဇဝင်"
        return lbl
    }()
    
    let label1: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.text = "လက်ရှိကိုယ်ဝန်ဆောင်နေပါသလား?"
        return lbl
    }()
    
    lazy var answerSwitch: UISwitch = {
        let sw = UISwitch()
        sw.addTarget(self, action: #selector(switchValueChange), for: .valueChanged)
        return sw
    }()
    
    @objc func switchValueChange(){
        if isSwitchOn{
            isSwitchOn = false
        } else {
            isSwitchOn = true
        }
        
        if ehrVC?.pregnantHistory.count == 2{
            ehrVC?.pregnantHistory[0].checked = isSwitchOn
        }
    }
    
    let childrenLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.text = "သားသမီးဦးရေ (ရှိပါက)"
        return lbl
    }()
    
    lazy var childrenAmountTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .done
        tf.keyboardType = .numberPad
        tf.placeholder = "Total children"
        tf.delegate = self
        return tf
    }()
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if ehrVC?.pregnantHistory.count == 2{
            if childrenAmountTextField.text! != ""{
                ehrVC?.pregnantHistory[1].data = childrenAmountTextField.text!
            } else {
                ehrVC?.pregnantHistory[1].data = "0"
            }
        }
    }
    
    func setupViews(){
        addSubview(titlelabel)
        addSubview(label1)
        addSubview(answerSwitch)
        addSubview(childrenLabel)
        addSubview(childrenAmountTextField)
        
        titlelabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        answerSwitch.anchor(titlelabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        label1.anchor(answerSwitch.topAnchor, left: leftAnchor, bottom: answerSwitch.bottomAnchor, right: answerSwitch.leftAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        childrenAmountTextField.anchor(answerSwitch.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 120, heightConstant: 45)
        childrenLabel.anchor(childrenAmountTextField.topAnchor, left: leftAnchor, bottom: childrenAmountTextField.bottomAnchor, right: childrenAmountTextField.leftAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

