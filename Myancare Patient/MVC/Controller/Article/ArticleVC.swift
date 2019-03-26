//
//  ArticleVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/8/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire

class ArticleVC: UIViewController {
    
    let cellIDCategory = "cellIDCategory"
    let cellID = "cellID"
    var articles = [ArticleModel]()
    
    lazy var categoryListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1) //ligh gray
        cv.showsVerticalScrollIndicator = false
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
        if collectionView == articleCollectionView{
            print("item selected")
            self.navigationController?.pushViewController(ArticleDetailVC(), animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == articleCollectionView ? 10 : 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if collectionView == articleCollectionView {
            let colCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ArticleCell
            colCell.articleVC = self
            colCell.articleImage.image = UIImage.init(named: "article")
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
            cellSize = CGSize(width: collectionView.bounds.width, height: 400)
        } else {
            cellSize = CGSize(width: collectionView.bounds.width/4 - 18, height: collectionView.bounds.height)
        }
        return cellSize
    }
    
}

extension ArticleVC{
    func loadArticles(){
        let skip = ""
        let liimit = ""
        let url = ""
        let params = ["":""]
        let heads = ["":""]
        Alamofire.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                print("success")
                if let responeData = response.result.value as? NSArray{
                    for articleData in responeData{
                        if let articleJson = articleData as? [String:Any]{
                            let article = ArticleModel()
                            article.updateArticleModel(articleJson)
                            
                            self.articles.append(article)
                        }
                    }
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}
