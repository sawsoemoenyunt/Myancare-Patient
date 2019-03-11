//
//  ArticleVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/8/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class ArticleVC: UIViewController {
    
    let cellIDCategory = "cellIDCategory"
    let cellID = "cellID"
    
    lazy var categoryListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1) //ligh gray
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return cv
    }()
    
    lazy var articleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = UIColor.groupTableViewBackground
        cv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews(){
        self.title = "Articles"
        view.backgroundColor = UIColor.white
        
        articleCollectionView.register(ArticleCell.self, forCellWithReuseIdentifier: cellID)
        categoryListView.register(ArticleCategoryCell.self, forCellWithReuseIdentifier: cellIDCategory)
        
        view.addSubview(categoryListView)
        view.addSubview(articleCollectionView)
        
        let v = view.safeAreaLayoutGuide
        categoryListView.anchor(v.topAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 77)
        articleCollectionView.anchor(categoryListView.bottomAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor, topConstant: 1, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}

extension ArticleVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(ArticleDetailVC(), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == articleCollectionView ? 10 : 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if collectionView == articleCollectionView {
            let colCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ArticleCell
            colCell.articleVC = self
            cell = colCell
        } else {
            let colCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIDCategory, for: indexPath) as! ArticleCategoryCell
            cell = colCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize = CGSize(width: 0, height: 0)
        if collectionView == articleCollectionView {
            cellSize = CGSize(width: collectionView.bounds.width, height: 380)
        } else {
            cellSize = CGSize(width: collectionView.bounds.width/4 - 18, height: collectionView.bounds.height)
        }
        return cellSize
    }
    
}

//cell for article category list
class ArticleCategoryCell: UICollectionViewCell {
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .gray
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    func setupViews(){
        addSubview(icon)
        icon.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 4, bottomConstant: 10, rightConstant: 4, widthConstant: 0, heightConstant: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

///cell for article list
class ArticleCell: UICollectionViewCell {
    
    var articleVC:ArticleVC?
    
    let titlelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Article Title\nonemore"
        lbl.numberOfLines = 2
        lbl.font = UIFont.mmFontBold(ofSize: 20)
        lbl.textColor = UIColor.black
        return lbl
    }()
    
    lazy var articleImage: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.MyanCareColor.lightGray
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
//        img.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(imageClick)))
        img.isUserInteractionEnabled = false
        return img
    }()
    
    @objc func imageClick(){
        articleVC?.navigationController?.pushViewController(ArticleDetailVC(), animated: true)
    }
    
    let introlabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Greyhound divisively hello coldly wonderfully marginally far upon excluding."
        lbl.numberOfLines = 2
        lbl.font = UIFont.mmFontRegular(ofSize: 14)
        lbl.textColor = UIColor.black
        lbl.isUserInteractionEnabled = false
        return lbl
    }()
    
    lazy var readBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("READ", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 16)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var bookMarkBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("BOOKMARK", for: .normal)
        btn.titleLabel?.font = UIFont.mmFontBold(ofSize: 16)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.MyanCareColor.green
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        return btn
    }()
    
    let icon1: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .gray
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let icon2: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .gray
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
        icon2.anchor(nil, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 20, widthConstant: 30, heightConstant: 30)
        icon1.anchor(nil, left: nil, bottom: bottomAnchor, right: icon2.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 10, widthConstant: 30, heightConstant: 30)
        
        
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
