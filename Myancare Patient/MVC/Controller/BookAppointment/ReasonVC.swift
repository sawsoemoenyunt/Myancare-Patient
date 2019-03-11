//
//  ReasonVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/2/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class ReasonVC: UIViewController {
    
    let cellID = "cellID"
    var imageList = [UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage()]
    var imagePicker = UIImagePickerController()
    var selectedIndex = 0
    
    let labelReason: UILabel = {
        let lbl = UILabel()
        lbl.text = "Type reason for visit :"
        lbl.numberOfLines = 0
        lbl.font = UIFont.mmFontBold(ofSize: 20)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let reasonTextView: UITextView = {
        let tv = UITextView()
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.layer.borderWidth = 1
        return tv
    }()
    
    let lineView: UIView = {
       let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let labelPhoto: UILabel = {
        let lbl = UILabel()
        lbl.text = "Add photo to show Doctor :"
        lbl.numberOfLines = 0
        lbl.font = UIFont.mmFontBold(ofSize: 20)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        return cv
    }()
    
    lazy var confrimBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("NEXT", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(confrimBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func confrimBtnClick(){
        self.navigationController?.pushViewController(InvoiceViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        collectionView.register(ReasonImageCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func setupViews(){
        
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(hidKeyBoard)))
        
        view.backgroundColor = .white
        view.addSubview(labelReason)
        view.addSubview(reasonTextView)
        view.addSubview(lineView)
        view.addSubview(labelPhoto)
        view.addSubview(collectionView)
        view.addSubview(confrimBtn)
        
        //setup constraints
        labelReason.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        confrimBtn.anchor(nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        reasonTextView.anchor(labelReason.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 200)
        lineView.anchor(reasonTextView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        labelPhoto.anchor(lineView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        collectionView.anchor(labelPhoto.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: confrimBtn.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 10, rightConstant: 20, widthConstant: 0, heightConstant: 0)
    }
    
    @objc func hidKeyBoard(){
        self.view.endEditing(true)
    }
}

extension ReasonVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ReasonImageCell
        cell.selectedImage.image = imageList[indexPath.row]
        cell.reasonVC = self
        cell.index = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4 - 4, height: collectionView.frame.width/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        print("cell clicked")
    }
}

extension ReasonVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func chooseImage(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageList[selectedIndex] = image
        
        self.dismiss(animated: true) {
            self.collectionView.reloadData()
        }
    }
}

class ReasonImageCell: UICollectionViewCell {
    
    var reasonVC : ReasonVC?
    var index: Int?
    
    let selectedImage: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.gray
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    lazy var icon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "icons8-add")?.withRenderingMode(.alwaysTemplate)
        img.tintColor = UIColor.white
        img.contentMode = .scaleAspectFill
        img.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(iconClick)))
        img.isUserInteractionEnabled = true
        return img
    }()
    
    @objc func iconClick(){
        reasonVC?.selectedIndex = index!
        reasonVC?.chooseImage()
    }
    
    func setupViews(){
        addSubview(selectedImage)
        addSubview(icon)
        
        selectedImage.fillSuperview()
        icon.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        icon.anchorCenterSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
