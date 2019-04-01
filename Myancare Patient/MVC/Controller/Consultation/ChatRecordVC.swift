//
//  ChatRecordVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ChatRecordVC: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellId"
    var roomID = ""
    var docName = ""
    var chatRecords = [ChatRecordModel]()
    var isPaging = true
    
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
        cell.textView.text = message
        cell.bubbleViewConstraints[4].constant = estimateFrameForText(text: message).width + 32
        let senderType = chatRecords[indexPath.row].userRole?.lowercased() == "patient" ? true : false
        UIImage.loadImage(chatRecords[indexPath.row].userImage!) { (image) in
            cell.profileImageView.image = image
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
        let message = chatRecords[indexPath.row].message!
        
        height = estimateFrameForText(text: message).height + 20
        
        return CGSize(width: view.frame.width, height: height)
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
        
        containerView.addSubview(inputTextField)
        containerView.addSubview(sendButton)
        inputTextField.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 2, leftConstant: 20, bottomConstant: 0, rightConstant: 70, widthConstant: 0, heightConstant: 50)
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
                
                if chatRecords.count > 0{
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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

