//
//  PatientInfoCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/21/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class PatientInfoCell: UICollectionViewCell, UITextFieldDelegate {
    
    var ehrVC : EHRListVC?
    var bmiInfoData : BMIModel?{
        didSet{
            if let data = bmiInfoData{
                bmiButton.setTitle("\(data.bmi!)", for: .normal)
                feetTextField.text = "\(data.feet!)"
                inchTextField.text = "\(data.inch!)"
                upperBloodTextField.text = "\(data.upperBloodPressure!)"
                lowerBloodTextField.text = "\(data.lowerBloodPressure!)"
                weightTextField.text = "\(data.weight!)"
            }
        }
    }
    
    let inchList = [0,1,2,3,4,5,6,7,8,9,10,11,12]
    
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
        tf.keyboardType = .numberPad
        tf.delegate = self
        return tf
    }()
    
    let feetLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.text = "ပေ"
        return lbl
    }()
    
    lazy var inchPicker: UIPickerView = {
        let p = UIPickerView()
        p.delegate = self
        p.dataSource = self
        return p
    }()
    
    lazy var inchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Inch"
        tf.borderStyle = .roundedRect
        //        tf.keyboardType = .numberPad
        tf.inputView = inchPicker
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
        tf.keyboardType = .numberPad
        tf.delegate = self
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
        tf.keyboardType = .numberPad
        tf.delegate = self
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
        tf.keyboardType = .numberPad
        tf.delegate = self
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
    
    lazy var bmiButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("0", for: .normal)
        btn.layer.cornerRadius = 6
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(bmitButtonClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func bmitButtonClick(){
        feetTextField.text = feetTextField.text == "" ? "0" : feetTextField.text
        inchTextField.text = inchTextField.text == "" ? "0" : inchTextField.text
        upperBloodTextField.text = upperBloodTextField.text == "" ? "0" : upperBloodTextField.text
        lowerBloodTextField.text = lowerBloodTextField.text == "" ? "0" : lowerBloodTextField.text
        weightTextField.text = weightTextField.text == "" ? "0" : weightTextField.text
        
        let bmiData = BMIModel()
        bmiData.feet = Int(feetTextField.text!)
        bmiData.inch = Int(inchTextField.text!)
        bmiData.upperBloodPressure = Int(upperBloodTextField.text!)
        bmiData.lowerBloodPressure = Int(lowerBloodTextField.text!)
        bmiData.weight = Int(weightTextField.text!)
        bmiData.calculateBMI()
        
        bmiButton.setTitle("\(bmiData.bmi!)", for: .normal)
        ehrVC?.bmiData = bmiData
    }
    
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if textField == feetTextField{
            return count < 2
        } else {
            return count <= 3
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PatientInfoCell: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return inchList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(inchList[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.inchTextField.text = "\(inchList[row])"
    }
}
