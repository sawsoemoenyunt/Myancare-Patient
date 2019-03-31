//
//  AddReminderVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/31/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class AddReminderVC: UIViewController {
    
    let cellID = "cellID"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        return cv
    }()
    
    lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("SAVE", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.isEnabled = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        
        self.title = "Add New Reminder"
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        view.addSubview(saveBtn)
        
        let v = view.safeAreaLayoutGuide
        saveBtn.anchor(nil, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 4, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: saveBtn.topAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 00, widthConstant: 0, heightConstant: 0)
        
        collectionView.register(AddNewReminderCell.self, forCellWithReuseIdentifier: cellID)
    }
}

extension AddReminderVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AddNewReminderCell
        cell.addreminderVC = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height + 100)
    }
}

class AddNewReminderCell: UICollectionViewCell, UITextFieldDelegate {
    
    var addreminderVC: AddReminderVC?
    
    let reasonlabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Reason to take Drug"
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    lazy var reasonTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Reason to take Drug"
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .next
        tf.delegate = self
        return tf
    }()
    
    let drugslabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Drugs"
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    let drugsTextView: UITextView = {
        let tv = UITextView()
        tv.layer.borderColor = UIColor.MyanCareColor.lightGray.cgColor
        tv.layer.borderWidth = 0.5
        return tv
    }()
    
    let startdatelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Start Day"
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    lazy var startdateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Start Day"
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .next
        tf.delegate = self
        tf.inputView = startdatePicker
        return tf
    }()
    
    lazy var startdatePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        dp.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        return dp
    }()
    
    @objc func dateChange(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        startdateTextField.text = formatter.string(from: startdatePicker.date)
        hideKeyboard()
    }
    
    let enddatelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "End Day"
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    lazy var enddateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "End day"
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .next
        tf.delegate = self
        tf.inputView = enddatePicker
        return tf
    }()
    
    lazy var enddatePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        dp.addTarget(self, action: #selector(enddateChange), for: .valueChanged)
        return dp
    }()
    
    @objc func enddateChange(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        enddateTextField.text = formatter.string(from: enddatePicker.date)
        hideKeyboard()
    }
    
    lazy var repeatlabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Repeating Day/Hour ❯"
        lbl.font = UIFont.MyanCareFont.type1
        lbl.textColor = UIColor.MyanCareColor.darkGray
        lbl.isUserInteractionEnabled = true
        lbl.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(showRepeatingVC)))
        return lbl
    }()
    
    @objc func showRepeatingVC(){
        addreminderVC?.navigationController?.pushViewController(RepeatingVC(), animated: true)
    }
    
    func hideKeyboard(){
        self.endEditing(true)
    }
    
    func setupViews(){
        addSubview(reasonlabel)
        addSubview(reasonTextField)
        addSubview(drugslabel)
        addSubview(drugsTextView)
        addSubview(startdatelabel)
        addSubview(startdateTextField)
        addSubview(enddatelabel)
        addSubview(enddateTextField)
        addSubview(repeatlabel)
        
        reasonlabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        reasonTextField.anchor(reasonlabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        
        drugslabel.anchor(reasonTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        drugsTextView.anchor(drugslabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 100)
        
        startdateTextField.anchor(drugsTextView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 60, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: self.frame.width/2-10, heightConstant: 50)
        startdatelabel.anchor(nil, left: leftAnchor, bottom: startdateTextField.topAnchor, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        enddateTextField.anchor(drugsTextView.bottomAnchor, left: startdateTextField.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 60, leftConstant: 8, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        enddatelabel.anchor(nil, left: enddateTextField.leftAnchor, bottom: enddateTextField.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        repeatlabel.anchor(startdateTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
