//
//  RecordBookVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/11/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class RecordBookVC: UIViewController, NVActivityIndicatorViewable {
    
    let cellID = "cellID"
    var isPaging = true
    var recordBooks = [MedicalRecordBookModel]()
    var popupTopConstraint:NSLayoutConstraint?
    var isUpdate = false
    
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
        rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return rc
    }()
    
    @objc func refreshData() {
        recordBooks.removeAll()
        isPaging = true
        self.getAllMedicalRecords()
        self.refreshControl1.endRefreshing()
    }
    
    lazy var typeSegment:UISegmentedControl = {
        let sg = UISegmentedControl(items: ["All Record".localized(),"My Record".localized()])
        //        sg.setImage( #imageLiteral(resourceName: "icons8-magazine"), forSegmentAt: 0)
        //        sg.setImage( #imageLiteral(resourceName: "icons8-more_filled"), forSegmentAt: 1)
        //        sg.setImage( #imageLiteral(resourceName: "icons8-appointment_reminders"), forSegmentAt: 2)
        sg.tintColor = UIColor(red:0.51, green:0.75, blue:0.35, alpha:1)
        sg.backgroundColor = .clear
        sg.selectedSegmentIndex = 0
        sg.layer.cornerRadius = 17
        sg.clipsToBounds = true
        sg.layer.borderWidth = 2
        sg.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        sg.layer.borderColor = UIColor(red:0.51, green:0.75, blue:0.35, alpha:1).cgColor
        sg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.MyanCareColor.green, NSAttributedString.Key.font:UIFont.MyanCareFont.type6], for: .normal)
        sg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font:UIFont.MyanCareFont.type6], for: .selected)
        sg.addTarget(self, action: #selector(handleSegment), for: .valueChanged)
        return sg
    }()
    
    @objc func handleSegment(){
        
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
        popuptitlelabel.text = "Add Book Cover"
        docNameTextField.text = ""
        reasonTextField.text = ""
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
        let todayDate = Date()
        let dFormatter = DateFormatter()
        dFormatter.dateFormat = "yyyy-MM-dd"
        
        let tf = UITextField()
        tf.placeholder = "Date"
        tf.text = "\(dFormatter.string(from: todayDate))"
        tf.borderStyle = .roundedRect
        tf.delegate = self
        tf.isEnabled = false
        return tf
    }()
    
    lazy var popupBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(popupBackgroundTap)))
        return view
    }()
    
    @objc func popupBackgroundTap(){
        showPopUpView(false)
    }
    
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
        
        let docName = docNameTextField.text
        let description = reasonTextField.text
        
        if docName != "" && description != "" {
            self.uploadNewMedicalRecordBook()
            showPopUpView(false)
            hideKeyboard()
        } else {
            self.showAlert(title: "Information required", message: "Please fill all form")
        }
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
        
        view.addSubview(typeSegment)
        view.addSubview(collectionView)
        view.addSubview(addBtn)
        
        let v = view.safeAreaLayoutGuide
        typeSegment.anchor(v.topAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 34)
        collectionView.anchor(typeSegment.bottomAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        addBtn.anchor(nil, left: nil, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 20, widthConstant: 56, heightConstant: 56)
        
        collectionView.register(MedicalRecordCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.refreshControl = refreshControl1
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
    
    func showConfirmActionSheet(_ bookID:String){
        let actionSheet = UIAlertController(title: "Please confirm to delete a medical record book", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmBtn = UIAlertAction(title: "Confirm", style: .default) { (action) in
            self.deleteMedicalRecordBook(bookID)
        }
        
        actionSheet.addAction(confirmBtn)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

///handle collectionview delegate and datasource
extension RecordBookVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let medicalRecord = recordBooks[indexPath.row]
        
        if medicalRecord.doctor_id == ""{
            let addPhotoVC = AddPhotoVC()
            addPhotoVC.recordBook = medicalRecord
            self.navigationController?.pushViewController(addPhotoVC, animated: true)
            
        } else {
            let galleryVC = PhotoGalleryVC()
            galleryVC.medicalRecordBook = medicalRecord
            self.navigationController?.pushViewController(galleryVC, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recordBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MedicalRecordCell

        if recordBooks.count > 0 {
            cell.recordData = recordBooks[indexPath.row]
            cell.medicalRecordVC = self
            
            if isPaging && indexPath.row == recordBooks.count - 1{
                self.getAllMedicalRecords()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 85)
    }
}

///handle textfield properties and functions
extension RecordBookVC: UITextFieldDelegate{
    
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
extension RecordBookVC{
    
    func deleteMedicalRecordBook(_ bookID:String){
        self.startAnimating()
        
        let url = EndPoints.deleteMedicalRecordBook(bookID).path
        let heads = ["Authorization":"\(jwtTkn)"]
        
        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                if responseStatus == 200 || responseStatus == 201{
                    self.refreshData()
                }
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
    func uploadNewMedicalRecordBook(){
        
        self.startAnimating()
        
        let url = EndPoints.addMedicalRecordBook.path
        let heads = ["Authorization":"\(jwtTkn)"]
        let params = ["doctor_name": docNameTextField.text!,
                      "description": reasonTextField.text!]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                if responseStatus == 201 || responseStatus == 200{
                    self.showPopUpView(false)
                    self.refreshData()
                } else {
                    self.showAlert(title: "An error occured", message: "Failed to add new medical record book")
                }
            case .failure(let error):
                print("\(error)")
            }
            self.stopAnimating()
        }
    }
    
    func getAllMedicalRecords(){
        
        if recordBooks.count == 0{
            self.startAnimating()
        }
        
        let skip = recordBooks.count
        let limit = 10
        
        let url = EndPoints.getMedicalRecordBooks(skip, limit).path
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
