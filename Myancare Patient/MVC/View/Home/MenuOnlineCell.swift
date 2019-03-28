//
//  MenuOnlineCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MenuOnlineCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout {
    
    var docType:DoctorType?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    var docList = [DoctorListModel]()
    
    var homeViewController: HomeViewController?
    let cellID = "cellID"
    
    lazy var collectionView: UICollectionView = {
        //layout of collectionview
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 4
        layout.scrollDirection = .horizontal
        
        //collectionview
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        
        //change content inset
        cv.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 4)
        
        return cv
    }()
    
    let conditionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "No Doctor found!"
        lbl.font = UIFont.mmFontRegular(ofSize: 11)
        lbl.textColor = UIColor.lightGray
        return lbl
    }()
    
    let labe1: UILabel = {
        let lbl = UILabel()
        lbl.text = "Online".localized()
        lbl.font = UIFont.MyanCareFont.type1
        lbl.textColor = UIColor(red:0.18, green:0.18, blue:0.18, alpha:1) //black
        return lbl
    }()
    
    lazy var labe2: UILabel = {
        let lbl = UILabel()
        lbl.text = "View all".localized()+" >"
        lbl.font = UIFont.MyanCareFont.type6
        lbl.isUserInteractionEnabled = true
        lbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(label2Click)))
        return lbl
    }()
    
    @objc func label2Click(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let docVC = DoctorListViewController(collectionViewLayout: layout)
        docVC.doctorType = docType!
        self.homeViewController?.navigationController?.pushViewController(docVC, animated: true)
    }
    
    func setupViews(){
        addSubview(labe1)
        addSubview(labe2)
        addSubview(collectionView)
        
        labe1.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        labe2.anchor(nil, left: nil, bottom: labe1.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        collectionView.anchor(labe2.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        collectionView.register(MenuOnlineButtonCell.self, forCellWithReuseIdentifier: cellID)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Menu Cell Extension for collectionview
extension MenuOnlineCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if docList.count == 0 {
            let notDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height))
            notDataLabel.text = "No doctor available!"
            notDataLabel.textColor = UIColor.MyanCareColor.darkGray
            notDataLabel.textAlignment = .center
            collectionView.backgroundView = notDataLabel
        }else{
            collectionView.backgroundView = UILabel()
        }
        return docList.count > 5 ? 5 : docList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MenuOnlineButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MenuOnlineButtonCell
        cell.docData = docList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 85, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let docDetailVC = DoctorDetailVC(collectionViewLayout: layout)
        docDetailVC.doctorID = docList[indexPath.row].id!
        self.homeViewController?.navigationController?.pushViewController(docDetailVC, animated: true)
    }
}

//Cell inside menucell
class MenuOnlineButtonCell: UICollectionViewCell {
    
    var docData:DoctorListModel?{
        didSet{
            if let data = docData{
                self.title.text = data.name!
                self.loadImage(data.image_url!)
            }
        }
    }
    
    func loadImage(_ urlString:String){
        let url = URL(string: "\(urlString)")!
        Alamofire.request(url).responseImage { response in
            debugPrint(response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                self.icon.image = image
            }
        }
    }
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "no-image")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let title: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dr.Name"
        lbl.textColor = UIColor(red:0.6, green:0.6, blue:0.6, alpha:1) //lihgt gray
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 11)
        return lbl
    }()
    
    func setupViews(){
        
        addSubview(icon)
        addSubview(title)
        
        title.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 2, bottomConstant: 14, rightConstant: 2, widthConstant: 0, heightConstant: 0)
        icon.anchor(nil, left: nil, bottom: title.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 66, heightConstant: 66)
        icon.anchorCenterXToSuperview()
        
        //circle icon
        icon.layer.cornerRadius = 33
        icon.clipsToBounds = true
        
        
        //background color
        self.backgroundColor = UIColor.white
        
    }
    
    override var isHighlighted: Bool{
        didSet{
            if isHighlighted{
                UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.transform = self.transform.scaledBy(x: 0.85, y: 0.85)
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                }, completion: nil)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


