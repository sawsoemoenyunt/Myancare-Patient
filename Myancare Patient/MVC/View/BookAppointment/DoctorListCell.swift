//
//  DoctorListCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DoctorListCell: UICollectionViewCell{
    
    var docData: DoctorListModel?{
        didSet{
            if let data = docData{
                nameLabel.text = data.name!
                specializeLabel.text = data.specialization!
                addressLabel.text = data.online_status == true ? "Online" : "Offline"
                statusView.backgroundColor = data.online_status == true ? UIColor.MyanCareColor.green : UIColor.gray
                
                //load image
//                loadImage(data.image_url!)
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
                self.profileImage.image = image
            }
        }
    }
    
    let profileImage: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        img.image = UIImage.init(named: "pablo-profile")
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 32
        img.clipsToBounds = true
        return img
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Doctor Name"
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return lbl
    }()
    
    let specializeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Specialization"
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.textColor = UIColor.gray
        return lbl
    }()
    
    let addressLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Address"
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.textColor = UIColor.gray
        return lbl
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    lazy var statusView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.layer.cornerRadius = 7 // 14
        view.layer.masksToBounds = true
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
        specializeLabel.anchor(nameLabel.bottomAnchor, left: nameLabel.leftAnchor, bottom: nil, right: nameLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        addressLabel.anchor(specializeLabel.bottomAnchor, left: specializeLabel.leftAnchor, bottom: nil, right: specializeLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        lineView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0.5)
        
        addSubview(statusView)
        statusView.anchor(nil, left: nil, bottom: profileImage.bottomAnchor, right: profileImage.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 14, heightConstant: 14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



