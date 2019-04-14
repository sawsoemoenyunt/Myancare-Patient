//
//  PatientRecordBookVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/14/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

import Alamofire
import NVActivityIndicatorView

class PatientRecordBookVC: UIViewController, NVActivityIndicatorViewable {
    
    let cellID = "cellID"
    var isPaging = true
    var recordBooks = [MedicalRecordBookModel]()
    var popupTopConstraint:NSLayoutConstraint?
    var isUpdate = false
    var patientID = ""
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 70, right: 0)
        return cv
    }()
    
    lazy var refreshControl1 : UIRefreshControl = {
        let  rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshDoctorData), for: .valueChanged)
        return rc
    }()
    
    @objc func refreshDoctorData() {
        recordBooks.removeAll()
        isPaging = true
        self.getAllMedicalRecords()
        self.refreshControl1.endRefreshing()
    }
    
    lazy var addBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("+", for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button2
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.orange
        btn.layer.cornerRadius = 28 //56
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func addBtnClick(){
        isUpdate = false
        popupdatelabel.text = "Add Book Cover"
        showPopUpView(true)
    }
    
    let popuptitlelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Add Book Cover"
        lbl.font = UIFont.MyanCareFont.type2
        lbl.textColor = UIColor.MyanCareColor.darkGray
        return lbl
    }()
    
    let popupdocNamelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Doctor name"
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    lazy var docNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Doctor Name"
        tf.borderStyle = .roundedRect
        tf.delegate = self
        return tf
    }()
    
    let popupreasonlabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Description"
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    lazy var reasonTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Description"
        tf.borderStyle = .roundedRect
        tf.delegate = self
        return tf
    }()
    
    let popupdatelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Date"
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    lazy var dateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Date"
        tf.borderStyle = .roundedRect
        tf.delegate = self
        tf.isUserInteractionEnabled = false
        return tf
    }()
    
    lazy var popupBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        return view
    }()
    
    lazy var popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("CONFIRM", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.orange
        //        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(handleConfirmBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleConfirmBtnClick(){
        showPopUpView(false)
        hideKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupPopupView()
        popupBackgroundView.isHidden = true
        
        getAllMedicalRecords()
    }
    
    func setupViews(){
        self.title = "Record Book"
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        view.addSubview(addBtn)
        
        let v = view.safeAreaLayoutGuide
        collectionView.anchor(v.topAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        addBtn.anchor(nil, left: nil, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 20, widthConstant: 56, heightConstant: 56)
        
        collectionView.register(PatientMedicalRecordCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.refreshControl = refreshControl1
        //hide addbtn for now
        addBtn.isHidden = true
    }
    
    func setupPopupView(){
        popupBackgroundView.tag = 100
        
        view.addSubview(popupBackgroundView)
        popupBackgroundView.fillSuperview()
        
        popupBackgroundView.addSubview(popupView)
        popupView.tag = 101
        popupTopConstraint = popupView.anchorWithReturnAnchors(popupBackgroundView.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, topConstant: -340, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: view.bounds.width-40, heightConstant: 340)[0]
        popupView.anchorCenterXToSuperview()
        
        popupView.addSubview(popuptitlelabel)
        popupView.addSubview(popupdocNamelabel)
        popupView.addSubview(docNameTextField)
        popupView.addSubview(popupreasonlabel)
        popupView.addSubview(reasonTextField)
        popupView.addSubview(popupdatelabel)
        popupView.addSubview(dateTextField)
        popupView.addSubview(confirmBtn)
        
        let p = popupView
        popuptitlelabel.anchor(p.topAnchor, left: p.leftAnchor, bottom: nil, right: p.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        popupdocNamelabel.anchor(popuptitlelabel.bottomAnchor, left: p.leftAnchor, bottom: nil, right: p.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        docNameTextField.anchor(popupdocNamelabel.bottomAnchor, left: p.leftAnchor, bottom: nil, right: p.rightAnchor, topConstant: 4, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 34)
        popupreasonlabel.anchor(docNameTextField.bottomAnchor, left: p.leftAnchor, bottom: nil, right: p.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        reasonTextField.anchor(popupreasonlabel.bottomAnchor, left: p.leftAnchor, bottom: nil, right: p.rightAnchor, topConstant: 4, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 34)
        popupdatelabel.anchor(reasonTextField.bottomAnchor, left: p.leftAnchor, bottom: nil, right: p.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        dateTextField.anchor(popupdatelabel.bottomAnchor, left: p.leftAnchor, bottom: nil, right: p.rightAnchor, topConstant: 4, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 34)
        confirmBtn.anchor(dateTextField.bottomAnchor, left: p.leftAnchor, bottom: p.bottomAnchor, right: p.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        popupView.layer.cornerRadius = 5
        popupView.layer.masksToBounds = true
    }
    
    func showPopUpView(_ isShow:Bool){
        if isShow {
            popupBackgroundView.isHidden = false
            animatePopView(constant: 40)
        } else {
            popupBackgroundView.isHidden = true
            animatePopView(constant: -340)
        }
    }
    
    func animatePopView(constant:CGFloat){
        popupTopConstraint?.constant = constant
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

///handle collectionview delegate and datasource
extension PatientRecordBookVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let galleryVC = PhotoGalleryVC()
        galleryVC.medicalRecordBook = recordBooks[indexPath.row]
        self.navigationController?.pushViewController(galleryVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recordBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PatientMedicalRecordCell
        
        if recordBooks.count > 0 {
            cell.recordData = recordBooks[indexPath.row]
            cell.medicalRecordVC = self
            
            if isPaging && indexPath.row == recordBooks.count - 1{
                self.getAllMedicalRecords()
            }
        }
        
        //hide edit btn for now
        cell.editBtn.isHidden = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 85)
    }
}

///handle textfield properties and functions
extension PatientRecordBookVC: UITextFieldDelegate{
    
    func hideKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        animatePopView(constant: 40)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == reasonTextField {
            animatePopView(constant: 20)
        }
        return true
    }
}

///fetch medical records from server
extension PatientRecordBookVC{
    
    func getAllMedicalRecords(){
        
        if recordBooks.count == 0{
            self.startAnimating()
        }
        
        let skip = recordBooks.count
        let limit = 10
        
        let url = EndPoints.getMedicalRecordBooksByPatientID(patientID, limit, skip).path
        let heads = ["Authorization":"\(jwtTkn)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                
                if responseStatus == 200{
                    if let responseArray = response.result.value as? NSArray{
                        for responseData in responseArray{
                            if let dataDict = responseData as? [String:Any]{
                                let book = MedicalRecordBookModel()
                                book.updateModelUsingDict(dataDict)
                                
                                self.recordBooks.append(book)
                            }
                        }
                        self.isPaging = responseArray.count > 0 ? true : false
                        self.collectionView.reloadData()
                    }
                    
                } else {
                    print("Data not found!")
                }
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
}

import UIKit

class PatientMedicalRecordCell: UICollectionViewCell {
    
    var medicalRecordVC: PatientRecordBookVC?
    var recordData : MedicalRecordBookModel?{
        didSet{
            if let data = recordData{
                docNamelabel.text = data.doctor_name!
                dateLabel.text = data.hospital_name!
                infolabel.text  = data.description!
            }
        }
    }
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.image = UIImage.init(named: "book")
        return img
    }()
    
    let docNamelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dr.Thomas"
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "12-Feb-2019"
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let infolabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dr.Thomas"
        lbl.font = UIFont.MyanCareFont.type4
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let verticalLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.MyanCareColor.lightGray
        return view
    }()
    
    let checkBox: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.layer.borderColor = UIColor.MyanCareColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()
    
    lazy var editBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "icons8-edit_property"), for: .normal)
        btn.addTarget(self, action: #selector(editBtnclick), for: .touchUpInside)
        return btn
    }()
    
    @objc func editBtnclick() {
        medicalRecordVC?.isUpdate = true
        medicalRecordVC?.popuptitlelabel.text = "Edit Book Cover"
        medicalRecordVC?.docNameTextField.text = recordData?.doctor_name
        medicalRecordVC?.reasonTextField.text = recordData?.description
        medicalRecordVC?.showPopUpView(true)
    }
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    func setupViews(){
        
        addSubview(bgView)
        bgView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 2, leftConstant: 20, bottomConstant: 2, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        bgView.addSubview(icon)
        bgView.addSubview(docNamelabel)
        bgView.addSubview(dateLabel)
        bgView.addSubview(infolabel)
        bgView.addSubview(verticalLine)
        bgView.addSubview(editBtn)
        
        
        verticalLine.anchor(bgView.topAnchor, left: nil, bottom: bgView.bottomAnchor, right: bgView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 50, widthConstant: 0.1, heightConstant: 0)
        editBtn.anchor(nil, left: nil, bottom: nil, right: bgView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 25, heightConstant: 25)
        editBtn.anchorCenterYToSuperview()
        icon.anchor(nil, left: bgView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 69, heightConstant: 69)
        icon.anchorCenterYToSuperview()
        docNamelabel.anchor(icon.topAnchor, left: icon.rightAnchor, bottom: nil, right: verticalLine.leftAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        dateLabel.anchor(docNamelabel.bottomAnchor, left: icon.rightAnchor, bottom: nil, right: verticalLine.leftAnchor, topConstant: 4, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        infolabel.anchor(dateLabel.bottomAnchor, left: icon.rightAnchor, bottom: nil, right: verticalLine.leftAnchor, topConstant: 4, leftConstant: 10, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2.0
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



