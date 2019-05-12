//
//  ArticleListCell.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

///cell for article list
class ArticleCell: UICollectionViewCell {
    
    var articleVC:ArticleVC?
    var articleData: ArticleModel?{
        didSet{
            if let data = articleData{
                titlelabel.text = data.title!
                if let htmlString = data.short_description?.htmlToAttributedString{
                    introlabel.text = htmlString.string
                }
                
                let dispatchQueue = DispatchQueue.main
                dispatchQueue.async {
                    UIImage.loadImage(data.image_url!) { (image) in
                        self.articleImage.image = image
                    }
                }
            }
        }
    }
    
    let titlelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Article Title\nonemore"
        lbl.numberOfLines = 2
        lbl.font = UIFont.MyanCareFont.type1
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    let articleImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "no-image")
        img.backgroundColor = UIColor.MyanCareColor.lightGray
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let introlabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Greyhound divisively hello coldly wonderfully marginally far upon excluding."
        lbl.numberOfLines = 2
        lbl.font = UIFont.mmFontRegular(ofSize: 14)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    lazy var readBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Read".localized(), for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button1
//        btn.setTitleColor(UIColor.MyanCareColor.curiousBlue, for: .normal)
        btn.backgroundColor = UIColor.MyanCareColor.curiousBlue
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(readBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func readBtnClick(){
        let articleDetail = ArticleDetailVC()
        articleDetail.articleID = (articleData?.id)!
        articleDetail.articleData = articleData!
        articleVC?.navigationController?.pushViewController(articleDetail, animated: true)
    }
    
    lazy var bookMarkBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Bookmark".localized(), for: .normal)
        btn.titleLabel?.font = UIFont.MyanCareFont.button1
//        btn.setTitleColor(UIColor.MyanCareColor.curiousBlue, for: .normal)
        btn.backgroundColor = UIColor.MyanCareColor.curiousBlue
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        return btn
    }()
    
    let icon1: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "icons8-like")?.withRenderingMode(.alwaysTemplate)
        img.tintColor = UIColor.MyanCareColor.lightGray
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let icon2: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "icons8-share")?.withRenderingMode(.alwaysTemplate)
        img.tintColor = UIColor.MyanCareColor.lightGray
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        return view
    }()
    
    func setupViews(){
        
        addSubview(bgView)
        addSubview(titlelabel)
        addSubview(articleImage)
        addSubview(introlabel)
        addSubview(readBtn)
        addSubview(bookMarkBtn)
        addSubview(icon1)
        addSubview(icon2)
        
        bgView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 4, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        titlelabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        articleImage.anchor(titlelabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 200)
        introlabel.anchor(articleImage.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 14, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        readBtn.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 20, rightConstant: 0, widthConstant: 50, heightConstant: 25)
        bookMarkBtn.anchor(nil, left: readBtn.rightAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 20, rightConstant: 0, widthConstant: 100, heightConstant: 25)
        icon2.anchor(nil, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 20, widthConstant: 25, heightConstant: 25)
        icon1.anchor(nil, left: nil, bottom: bottomAnchor, right: icon2.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 10, widthConstant: 25, heightConstant: 25)
        
        
        //        layer.borderColor = UIColor.MyanCareColor.lightGray.cgColor
        //        layer.borderWidth = 0.5
        
        // set the shadow of the view's layer
        bgView.layer.backgroundColor = UIColor.white.cgColor
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize(width: 2, height: 2)
        bgView.layer.shadowOpacity = 0.2
        bgView.layer.shadowRadius = 4.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
