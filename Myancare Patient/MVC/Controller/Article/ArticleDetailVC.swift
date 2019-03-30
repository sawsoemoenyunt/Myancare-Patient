//
//  ArticleDetailVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/8/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ArticleDetailVC: UIViewController {
    
    let cellID = "cellID"
    var articleID = ""
    var articleData = ArticleModel()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.allowsMultipleSelection = true
        cv.backgroundColor = UIColor.groupTableViewBackground
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        getArticleData()
    }
    
    func setupViews(){
        self.title = "\(articleData.title!)"
        self.view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        
        collectionView.register(ArticleDetailCell.self, forCellWithReuseIdentifier: cellID)
    }
}

extension ArticleDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ArticleDetailCell
        cell.articleData = articleData
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedHeight = self.view.calculateHeightofTextView(dummyText: articleData.description!, fontSize: 16, viewWdith: collectionView.bounds.width)
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height + estimatedHeight)
    }
}

extension ArticleDetailVC{
    func getArticleData(){
        let url = EndPoints.getArticleByID(articleID).path
        let heads = ["Authentication" : "\(jwtTkn)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            
            switch response.result{
            case .success:
                print("Success")
                let responseStatus = response.response?.statusCode
                print("Response status : \(responseStatus ?? 0)")
                
                if responseStatus == 400 || responseStatus == 404 || responseStatus == 403{
                    print("data not found")
                    
                } else if responseStatus == 200 {
                    if let responseDict = response.result.value as? [String:Any]{
                        self.articleData.updateArticleModel(responseDict)
                        self.collectionView.reloadData()
                    }
                }
                
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}
