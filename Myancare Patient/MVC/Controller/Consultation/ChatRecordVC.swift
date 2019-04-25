//
//  ChatRecordVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import AlamofireImage
import NVActivityIndicatorView

class ChatRecordVC: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {
    
    let cellID = "cellId"
    var roomID = ""
    var docName = ""
    var chatRecords = [ChatRecordModel]()
    var isPaging = true
    var uploadImage = UIImage()
    var imageKey = ""
    var imageUrl = ""
    var isFirstTimeLoad = true
    
    let reminderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let reminderLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "days Remaining"
        lbl.font = UIFont.MyanCareFont.type8
        return lbl
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var inputTextField: UITextField = {
        let inputTextField = UITextField()
        inputTextField.placeholder = "Enter messages.."
        inputTextField.delegate = self
        inputTextField.returnKeyType = .send
        inputTextField.borderStyle = .roundedRect
        return inputTextField
    }()
    
    lazy var sendButton: UIButton = {
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return sendButton
    }()
    
    lazy var imageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "icons8-picture")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = UIColor.MyanCareColor.darkGray
        btn.addTarget(self, action: #selector(handleImageBtnClick), for: .touchUpInside)
        return btn
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var refreshControl1 : UIRefreshControl = {
        let  rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return rc
    }()
    
    @objc func refreshData() {
        
        chatRecords.removeAll()
        isPaging = true
        self.getChatRecords()
        self.refreshControl1.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = docName
        view.backgroundColor = UIColor.white
        self.navigationItem.largeTitleDisplayMode = .never
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 78, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatRecordCell.self, forCellWithReuseIdentifier: cellID)
        
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: Notification.Name.didReceiveDataForChatRecord, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveDataForNewMessage(_:)), name: Notification.Name.didReceiveDataForNewChatMessage, object: nil)
        getChatRecords()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatRecords.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatRecordCell
        let message = chatRecords[indexPath.row].message!
        print(message)
        cell.textView.text = message
        
        let senderType = chatRecords[indexPath.row].userRole?.lowercased() == "patient" ? true : false
        UIImage.loadImage(chatRecords[indexPath.row].userImage!) { (image) in
            cell.profileImageView.image = image
        }
        
        if chatRecords[indexPath.row].image_type == 0{
            cell.bubbleViewConstraints[4].constant = estimateFrameForText(text: message).width + 32
            cell.imageView.isHidden = true
            cell.textView.isHidden = false
        } else {
            cell.bubbleViewConstraints[4].constant = 230
            cell.imageView.isHidden = false
            cell.textView.isHidden = true
            
            UIImage.loadImage(chatRecords[indexPath.row].image_url!) { (image) in
                cell.imageView.image = image
            }
        }
        
        setupCell(cell: cell, message: message, isSender: senderType)
        
        if isPaging && indexPath.row == chatRecords.count - 1{
            getChatRecords()
        }
        
        return cell
    }
    
    private func setupCell(cell: ChatRecordCell, message: String, isSender: Bool) {
        if isSender{
            cell.bubbleView.backgroundColor = UIColor.MyanCareColor.lightGray
            cell.textView.textColor = .black
            cell.bubbleViewConstraints[1].isActive = false
            cell.bubbleViewConstraints[3].isActive = true
            cell.profileImageView.isHidden = true
        } else {
            cell.bubbleView.backgroundColor = UIColor.MyanCareColor.green
            cell.textView.textColor = .white
            cell.bubbleViewConstraints[1].isActive = true
            cell.bubbleViewConstraints[3].isActive = false
            cell.profileImageView.isHidden = false
        }
        //reverse cell
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        var width: CGFloat = collectionView.frame.width
        let message = chatRecords[indexPath.row].message!
        
        height = estimateFrameForText(text: message).height + 20
        
        if chatRecords[indexPath.row].image_type == 1{
            width = collectionView.frame.width
            height = 200
        }
        
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if chatRecords[indexPath.row].image_type! == 1{
            let zoomVC = ChatImageZoomVC()
            zoomVC.imageUrl = chatRecords[indexPath.row].image_url!
            self.view.endEditing(true)
            self.navigationController?.pushViewController(zoomVC, animated: true)
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        collectionView?.collectionViewLayout.invalidateLayout()
        
    }
    
    private func estimateFrameForText(text: String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.MyanCareFont.type4], context: nil)
    }
    
    func setupViews() {
        
        view.addSubview(containerView)
        
        containerView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 70)
        
        containerView.addSubview(imageButton)
        containerView.addSubview(inputTextField)
        containerView.addSubview(sendButton)
        
        inputTextField.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 2, leftConstant: 60, bottomConstant: 0, rightConstant: 70, widthConstant: 0, heightConstant: 50)
        imageButton.anchor(inputTextField.topAnchor, left: containerView.leftAnchor, bottom: inputTextField.bottomAnchor, right: inputTextField.leftAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        sendButton.anchor(inputTextField.topAnchor, left: nil, bottom: inputTextField.bottomAnchor, right: containerView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 20, widthConstant: 40, heightConstant: 40)
        
        //reverse collectionview
        collectionView.showsVerticalScrollIndicator = false
        collectionView.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
    }
    
    @objc func handleSend() {
        if inputTextField.text != ""{
            SocketManagerHandler.sharedInstance().emitChatMessage(roomID: roomID, messageString: inputTextField.text!, imageType: 0)
        }
        self.inputTextField.text = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    @objc func handleImageBtnClick(){
        showSourceOption()
    }

}

extension ChatRecordVC{
    func getChatRecords(){
        let skip = chatRecords.count
        let limit = 20
        
        SocketManagerHandler.sharedInstance().emitChatRecords(roomID: roomID, skip: skip, limit: limit)
    }
    
    @objc func onDidReceiveData(_ notification:Notification){
        if let data = notification.userInfo as? [String:[ChatRecordModel]]{
            for (key, dataArr) in data{
                print("\(key)")
                for record in dataArr{
                    self.chatRecords.append(record)
                }
                self.collectionView.reloadData()
                
                if chatRecords.count > 0 && isFirstTimeLoad{
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    isFirstTimeLoad = false
                }
                self.isPaging = dataArr.count > 0 ? true : false
            }
        }
    }
    
    @objc func onDidReceiveDataForNewMessage(_ notification:Notification){
        if let data = notification.userInfo as? [String:ChatRecordModel]{
            for (key, message) in data{
                print("\(key)")
                self.chatRecords.insert(message, at: 0)
                self.collectionView.reloadData()
                
                if chatRecords.count > 0{
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }
        }
    }
}

extension ChatRecordVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func showSourceOption(){
        let actionSheet = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let cameraBtn = UIAlertAction(title: "From Camera", style: .default) { (action) in
            self.chooseImage(type: .camera)
        }
        let galleryBtn = UIAlertAction(title: "From Gallery", style: .default) { (action) in
            self.chooseImage(type: .savedPhotosAlbum)
        }
        
        actionSheet.addAction(cameraBtn)
        actionSheet.addAction(galleryBtn)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func chooseImage(type:UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = type;
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage]{
            selectedImageFromPicker = editedImage as? UIImage
        } else if let originalImage = info[.originalImage]{
            selectedImageFromPicker = originalImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadImage = selectedImage
            self.getImageUploadLinkFromServer()
        }
        
        self.dismiss(animated: true) {
            self.collectionView.reloadData()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getImageUploadLinkFromServer(){
        let url = EndPoints.imagesUpload.path
//        let url = URL(string: "http://159.65.10.176:5000/api/images/upload")!
        let heads = ["Authorization":"\(jwtTkn)"]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                
                if responseStatus == 400{
                    print("Failed to get image upload link")
                    
                } else if responseStatus == 200{
                    if let result = response.result.value as? NSDictionary{
                        if let key = result.object(forKey: "key") as? String{
                            self.imageKey = key
                        }
                        if let url = result.object(forKey: "url") as? String{
                            self.imageUrl = url
                        }
                        
                        if self.imageUrl != "" && self.imageKey != ""{
                            self.uploadImageToS3(self.imageUrl)
                            
                        } else {
                            print("image url was nil")
                        }
                    }
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func uploadImageToS3(_ urlString:String){
        
        self.startAnimating()
        
        let url = urlString
        guard let imageData = uploadImage.jpegData(compressionQuality: 0.7) else {
            return
        }
        
        let heads = ["Content-Type":"image/jpeg"]
        
        Alamofire.upload(imageData, to: URL(string: url)!, method: .put, headers: heads).response { (response) in
            
            let responseStatus = response.response?.statusCode
            
            switch responseStatus{
            case 200:
                print("Image uploaded to s3 success...")
                SocketManagerHandler.sharedInstance().emitChatMessage(roomID: self.roomID, messageString: self.imageKey, imageType: 1)
                print(self.imageUrl)
            default:
                print("Failed uploading Image to s3...")
            }
            self.stopAnimating()
        }
        
    }
}

class ChatImageZoomVC: UIViewController, UIScrollViewDelegate {
    
    var imageUrl = ""
    
    lazy var imageView: UIImageView = {
       let img = UIImageView()
        img.backgroundColor = .gray
        img.image = UIImage(named: "no-image")
        img.clipsToBounds = false
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var scrollView: UIScrollView = {
        let sc = UIScrollView()
        sc.delegate = self
        sc.alwaysBounceVertical = false
        sc.alwaysBounceHorizontal = false
        sc.showsVerticalScrollIndicator = false
        sc.showsHorizontalScrollIndicator = false
        sc.maximumZoomScale = 10.0
        sc.minimumZoomScale = 1.0
        sc.zoomScale = 1.0
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        let imageSize = view.frame.width
        scrollView.addSubview(imageView)
        imageView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: imageSize, heightConstant: imageSize-30)
        imageView.anchorCenterXToSuperview()
        imageView.anchorCenterYToSuperview(constant: -30)
        
        if imageUrl != ""{
            loadImage()
        }
    }
    
    func loadImage(){
        UIImage.loadImage(imageUrl) { (image) in
            self.imageView.image = image
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
