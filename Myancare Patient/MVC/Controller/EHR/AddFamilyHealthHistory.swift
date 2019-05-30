//
//  AddFamilyHealthHistory.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 5/6/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class AddFamilyHistory: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    var familyHistoryList = [Disease]()
    var ehrVC : EHRListVC?
    var relativeTypeList = ["မိဘများ", "အဘိုးအဘွားများ", "မောင်နှမ", "သားသမီး", "အခြား"]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        return cv
    }()
    
    let bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    let newDiseaseTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.MyanCareFont.type3
        tf.borderStyle = .roundedRect
        tf.placeholder = "အခြားအကြောင်းအရာထည့်ရန်"
        tf.font = UIFont.MyanCareFont.type3
        return tf
    }()
    
    let yearLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.text = "ရွေးပါ - "
        return lbl
    }()
    
    lazy var relativePicker: UIPickerView = {
        let p = UIPickerView()
        p.delegate = self
        p.dataSource = self
        p.selectedRow(inComponent: 0)
        return p
    }()
    
    lazy var yearPicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.addTarget(self, action: #selector(yearPickerChange), for: .valueChanged)
        return dp
    }()
    
    @objc func yearPickerChange(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        yearTextField.text = formatter.string(from: yearPicker.date)
        self.view.endEditing(true)
    }
    
    lazy var yearTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Relation"
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .done
        tf.font = UIFont.MyanCareFont.type4
        tf.inputView = relativePicker
        return tf
    }()
    
    lazy var addBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("အသစ်ထည့်", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button1
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 22
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func addBtnClick(){
        
        if yearTextField.text! != "" && newDiseaseTextField.text! != ""{
            let disease = Disease(_checked: true, _data: "\(yearTextField.text!)", _name: "\(newDiseaseTextField.text!)")
            familyHistoryList.insert(disease, at: 0)
            self.ehrVC?.familyHistory = self.familyHistoryList
            
            self.newDiseaseTextField.text = ""
            self.yearTextField.text = ""
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews(){
        self.title = "ခွဲစိတ်ကုသခဲ့မူများ"
        self.view.backgroundColor = .white
        
        view.addSubview(bgView)
        view.addSubview(collectionView)
        
        let v = view.safeAreaLayoutGuide
        bgView.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 2, rightConstant: 20, widthConstant: 0, heightConstant: 120)
        collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: bgView.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        bgView.addSubview(newDiseaseTextField)
        bgView.addSubview(yearLabel)
        bgView.addSubview(yearTextField)
        bgView.addSubview(addBtn)
        
        yearTextField.anchor(bgView.topAnchor, left: nil, bottom: nil, right: bgView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 100, heightConstant: 45)
        yearLabel.anchor(yearTextField.topAnchor, left: nil, bottom: yearTextField.bottomAnchor, right: yearTextField.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        newDiseaseTextField.anchor(bgView.topAnchor, left: bgView.leftAnchor, bottom: nil, right: yearLabel.leftAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 45)
        addBtn.anchor(yearTextField.bottomAnchor, left: nil, bottom: nil, right: bgView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 100, heightConstant: 44)
        
        collectionView.register(AddFamilyHistoryCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return familyHistoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AddFamilyHistoryCell
        if familyHistoryList.count > 0{
            cell.titleLabel.text = familyHistoryList[indexPath.row].name!
            cell.yearTextField.text = familyHistoryList[indexPath.row].data!
            cell.isChecked = familyHistoryList[indexPath.row].checked!
            cell.ehrVC = self.ehrVC
            cell.index = indexPath.row
            
            if cell.isChecked{
                cell.checkBox.image = #imageLiteral(resourceName: "icons8-checked_checkbox").withRenderingMode(.alwaysTemplate)
            } else {
                cell.checkBox.image = #imageLiteral(resourceName: "icons8-unchecked_checkbox").withRenderingMode(.alwaysTemplate)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 65)
    }
}

extension AddFamilyHistory: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return relativeTypeList.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return relativeTypeList[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.yearTextField.text = relativeTypeList[row]
        self.ehrVC?.familyHistory[row].data = yearTextField.text!
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil{
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.MyanCareFont.type1
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = relativeTypeList[row]
        return pickerLabel!
    }
}

class AddFamilyHistoryCell: UICollectionViewCell {
    
    var isChecked = false
    var index : Int?
    var ehrVC : EHRListVC?
    var relativeTypeList = ["မိဘများ", "အဘိုးအဘွားများ", "မောင်နှမ", "သားသမီး", "အခြား"]
    
    lazy var checkBox: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "icons8-unchecked_checkbox").withRenderingMode(.alwaysTemplate)
        img.tintColor = UIColor.MyanCareColor.darkGray
        img.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(checkBoxClick)))
        img.isUserInteractionEnabled = true
        return img
    }()
    
    @objc func checkBoxClick(){
        if isChecked{
            isChecked = false
            checkBox.image = #imageLiteral(resourceName: "icons8-unchecked_checkbox").withRenderingMode(.alwaysTemplate)
        } else {
            isChecked = true
            checkBox.image = #imageLiteral(resourceName: "icons8-checked_checkbox").withRenderingMode(.alwaysTemplate)
        }
        
        self.ehrVC?.familyHistory[index!].checked = isChecked
    }
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.text = "သွေးတိုး"
        lbl.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(checkBoxClick)))
        lbl.isUserInteractionEnabled = true
        return lbl
    }()
    
    let yearLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.text = "ရွေးပါ - "
        return lbl
    }()
    
    lazy var yearPicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.addTarget(self, action: #selector(yearPickerChange), for: .valueChanged)
        return dp
    }()
    
    @objc func yearPickerChange(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        yearTextField.text = formatter.string(from: yearPicker.date)
        self.endEditing(true)
    }
    
    lazy var relativePicker: UIPickerView = {
        let p = UIPickerView()
        p.delegate = self
        p.dataSource = self
        p.selectedRow(inComponent: 0)
        return p
    }()
    
    lazy var yearTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Relation"
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .done
        tf.inputView = relativePicker
        tf.font = UIFont.MyanCareFont.type3
        return tf
    }()
    
    func setupViews(){
        addSubview(checkBox)
        addSubview(titleLabel)
        addSubview(yearLabel)
        addSubview(yearTextField)
        
        checkBox.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        titleLabel.anchor(nil, left: checkBox.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        yearTextField.anchor(nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 100, heightConstant: 45)
        yearLabel.anchor(yearTextField.topAnchor, left: nil, bottom: yearTextField.bottomAnchor, right: yearTextField.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        checkBox.anchorCenterYToSuperview()
        titleLabel.anchorCenterYToSuperview()
        yearTextField.anchorCenterYToSuperview()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddFamilyHistoryCell: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return relativeTypeList.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return relativeTypeList[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.yearTextField.text = relativeTypeList[row]
        self.ehrVC?.familyHistory[index!].data = yearTextField.text!
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil{
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.MyanCareFont.type1
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = relativeTypeList[row]
        return pickerLabel!
    }
}


