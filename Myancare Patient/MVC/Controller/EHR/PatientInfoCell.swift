//
//  PatientInfoCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/21/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class PatientInfoCell: UICollectionViewCell {
    
    let heightLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.text = "အရပ်"
        return lbl
    }()
    
    lazy var feetTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Feet"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let feetLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.text = "ပေ"
        return lbl
    }()
    
    lazy var inchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Inch"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let inchLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.text = "လက်မ"
        return lbl
    }()
    
    let bloodPressureLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.text = "ပုံမှန်သွေးပေါင်ချိန်"
        return lbl
    }()
    
    lazy var upperBloodTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = ""
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let upLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.text = "အပေါ်"
        return lbl
    }()
    
    lazy var lowerBloodTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = ""
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let lowerLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.text = "အောက်"
        return lbl
    }()
    
    let weightLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.text = "အလေးချိန်"
        return lbl
    }()
    
    lazy var weightTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "lbs"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let poundLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.text = "ပေါင်"
        return lbl
    }()
    
    let bmiLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.black
        lbl.text = "BMI"
        return lbl
    }()
    
    let bmiButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("12", for: .normal)
        btn.layer.cornerRadius = 6
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    func setupViews(){
        addSubview(heightLabel)
        addSubview(feetTextField)
        addSubview(feetLabel)
        addSubview(inchTextField)
        addSubview(inchLabel)
        
        addSubview(bloodPressureLabel)
        addSubview(upperBloodTextField)
        addSubview(upLabel)
        addSubview(lowerBloodTextField)
        addSubview(lowerLabel)
        
        addSubview(weightLabel)
        addSubview(weightTextField)
        addSubview(poundLabel)
        
        addSubview(bmiLabel)
        addSubview(bmiButton)
        
        addSubview(lineView)
        
        heightLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        feetTextField.anchor(topAnchor, left: heightLabel.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 40)
        feetLabel.anchor(feetTextField.topAnchor, left: feetTextField.rightAnchor, bottom: feetTextField.bottomAnchor, right: nil, topConstant: 0, leftConstant: 2, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        inchTextField.anchor(topAnchor, left: feetLabel.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 40)
        inchLabel.anchor(inchTextField.topAnchor, left: inchTextField.rightAnchor, bottom: inchTextField.bottomAnchor, right: nil, topConstant: 0, leftConstant: 2, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        bloodPressureLabel.anchor(feetTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        upperBloodTextField.anchor(feetTextField.bottomAnchor, left: bloodPressureLabel.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 40)
        upLabel.anchor(upperBloodTextField.topAnchor, left: upperBloodTextField.rightAnchor, bottom: upperBloodTextField.bottomAnchor, right: nil, topConstant: 0, leftConstant: 2, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        lowerBloodTextField.anchor(feetTextField.bottomAnchor, left: upLabel.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 40)
        lowerLabel.anchor(lowerBloodTextField.topAnchor, left: lowerBloodTextField.rightAnchor, bottom: lowerBloodTextField.bottomAnchor, right: nil, topConstant: 0, leftConstant: 2, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        weightLabel.anchor(upperBloodTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        weightTextField.anchor(upperBloodTextField.bottomAnchor, left: weightLabel.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 40)
        poundLabel.anchor(weightTextField.topAnchor, left: weightTextField.rightAnchor, bottom: weightTextField.bottomAnchor, right: nil, topConstant: 0, leftConstant: 2, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        bmiLabel.anchor(weightTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        bmiButton.anchor(weightTextField.bottomAnchor, left: bmiLabel.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 50)
        
        lineView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0.5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
