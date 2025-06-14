//
//  ArticleDetailCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

///article detail cell
class ArticleDetailCell: UICollectionViewCell {
    
    var articleData: ArticleModel?{
        didSet{
            if let data = articleData{
                titlelabel.text = data.title!
                infoLabel.text = data.short_description!
//                UIImage.loadImage(data.image_url!) { (image) in
//                    self.articleImage.image = image
//                    return
//                }
                self.articleImage.loadImage(urlString: data.image_url!)
                if let htmlString = data.short_description?.htmlToAttributedString{
                    infoLabel.text = htmlString.string
                }
            }
        }
    }
    
    let titlelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.numberOfLines = 4
        lbl.font = UIFont.mmFontBold(ofSize: 20)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let articleImage: CachedImageView = {
        let img = CachedImageView()
        img.image = UIImage(named: "no-image")
        img.backgroundColor = UIColor.MyanCareColor.lightGray
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    lazy var likeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(" 10"+"Likes".localized(), for: .normal)
        btn.setImage(UIImage(named: "icons8-like")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 14)
        btn.setTitleColor(UIColor.MyanCareColor.darkGray, for: .normal)
        btn.tintColor = UIColor.MyanCareColor.darkGray
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.isEnabled = true
        return btn
    }()
    
    lazy var bookmarkBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(" "+"Bookmark".localized(), for: .normal)
        btn.setImage(UIImage(named: "icons8-bookmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 14)
        btn.tintColor = UIColor.MyanCareColor.darkGray
        btn.setTitleColor(UIColor.MyanCareColor.darkGray, for: .normal)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.isEnabled = true
        return btn
    }()
    
    lazy var shareBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(" "+"Share".localized(), for: .normal)
        btn.setImage(UIImage(named: "icons8-share")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 14)
        btn.tintColor = UIColor.MyanCareColor.darkGray
        btn.setTitleColor(UIColor.MyanCareColor.darkGray, for: .normal)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.isEnabled = true
        return btn
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.MyanCareFont.type3
        lbl.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit,sed do eiusmod tempor incididunt.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit,sed do eiusmod tempor incididunt.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit,sed do eiusmod tempor incididunt."
        lbl.numberOfLines = 0
        return lbl
    }()
    
    func setupViews(){
        addSubview(titlelabel)
        addSubview(articleImage)
//        addSubview(likeBtn)
//        addSubview(bookmarkBtn)
//        addSubview(shareBtn)
        addSubview(lineView)
        addSubview(infoLabel)
        
        titlelabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        articleImage.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 250)
//        likeBtn.anchor(articleImage.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 4, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: self.bounds.width/3 - 18, heightConstant: 40)
//        bookmarkBtn.anchor(articleImage.bottomAnchor, left: likeBtn.rightAnchor, bottom: nil, right: nil, topConstant: 4, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: self.bounds.width/3 - 18, heightConstant: 40)
//        shareBtn.anchor(articleImage.bottomAnchor, left: bookmarkBtn.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: self.bounds.width/3 - 18, heightConstant: 40)
        lineView.anchor(articleImage.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        infoLabel.anchor(lineView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
