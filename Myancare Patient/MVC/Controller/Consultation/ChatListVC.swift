//
//  ChatListVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ChatListVC: UIViewController {
    
    let cellID = "cellID"
    var roomList = [ChatRoomModel]()
    var isPaging = true
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return cv
    }()
    
    lazy var refreshControl1 : UIRefreshControl = {
        let  rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return rc
    }()
    
    @objc func refreshData() {
        
        roomList.removeAll()
        isPaging = true
        self.getRooms()
        self.refreshControl1.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: Notification.Name.didReceiveDataForChatRoomList, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        refreshData()
    }
    
    func setupViews(){
        self.title = "Chats"
        view.backgroundColor = UIColor.white
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        
        collectionView.refreshControl = refreshControl1
        collectionView.register(ChatListCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func getRooms(){
        let skip = roomList.count > 0 ? roomList.count : 0
        let limit = 10
        SocketManagerHandler.sharedInstance().emitChatRooms(skip: skip, limit: limit)
        
    }
    
    @objc func onDidReceiveData(_ notification:Notification){
        if let data = notification.userInfo as? [String:[ChatRoomModel]]{
            for (key, dataArr) in data{
                print("\(key)")
                for room in dataArr{
                    roomList.append(room)
                }
                self.collectionView.reloadData()
                self.isPaging = dataArr.count > 0 ? true : false
            }
        }
    }
}

extension ChatListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatListCell
        cell.roomData = roomList[indexPath.row]
        
        if isPaging && indexPath.row == roomList.count - 1 {
            self.getRooms()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 89)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if roomList.count > 0{
            let chatRoom = ChatRecordVC.init(collectionViewLayout: UICollectionViewFlowLayout())
            chatRoom.roomID = roomList[indexPath.row].id!
            chatRoom.docName = roomList[indexPath.row].doctor_name!
            self.navigationController?.pushViewController(chatRoom, animated: true)
        }
    }
}

class ChatListCell: UICollectionViewCell {
    
    var roomData: ChatRoomModel?{
        didSet{
            if let data = roomData{
                nameLabel.text = data.doctor_name!
                specializeLabel.text = data.last_message!
                addressLabel.text = data.timeAgo!
                
                UIImage.loadImage(data.doctor_imageUrl!) { (image) in
                    self.profileImage.image = image
                }
                
            }
        }
    }
    
    let profileImage: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        img.image = UIImage.init(named: "no-image")
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 32
        img.clipsToBounds = true
        return img
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Doctor Name"
        lbl.font = UIFont.MyanCareFont.type2
        return lbl
    }()
    
    let specializeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "This is last message"
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.gray
        return lbl
    }()
    
    let addressLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "5 min ago"
        lbl.font = UIFont.MyanCareFont.type3
        lbl.textColor = UIColor.gray
        lbl.textAlignment = .right
        return lbl
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    func setupViews(){
        
        self.backgroundColor = .white
        
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(specializeLabel)
        addSubview(addressLabel)
        addSubview(lineView)
        
        
        profileImage.anchor(nil, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 64, heightConstant: 64)
        profileImage.anchorCenterYToSuperview()
        nameLabel.anchor(profileImage.topAnchor, left: profileImage.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        addressLabel.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        specializeLabel.anchor(nameLabel.bottomAnchor, left: nameLabel.leftAnchor, bottom: nil, right: addressLabel.leftAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        lineView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0.5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
