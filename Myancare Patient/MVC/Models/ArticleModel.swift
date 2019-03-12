//
//  ArticleModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class ArticleModel
{
    var articleID : String?
    var title: String?
    var description_long : String?
    var description_short : String?
    var imageUrl : String?
    var viewCount : String?
    var postedTime : String?
    var likesCount : String?
    var cateName : String?
    var commentsCount : String?
    var slug : String?
    var cateID : String?
    var isLikeByMe : Bool?
    var isBookmark : Bool?
    
    var postedBy : String?
    
    var categoryId : String?
    var categoryName : String?
    var categoryImage : String?
    var categoryFullName : String?
    
    init() {
        articleID = ""
        title = ""
        description_long = ""
        description_short = ""
        cateID = ""
        imageUrl = ""
        viewCount = ""
        postedTime = ""
        likesCount = ""
        cateName = ""
        commentsCount = ""
        postedBy = ""
        slug = ""
        
        isBookmark = false
        
        categoryId = ""
        categoryName = ""
        categoryImage = ""
        categoryFullName = ""
    }
    
    deinit {
        print("Article Model deinit")
    }
    
    func updateCateModel(usingDictionary dictionary:[String:Any]) -> Void
    {
        if let cateID = dictionary["id"] as? String
        {
            categoryId = cateID
        }
        if let cateName = dictionary["name"] as? String
        {
            categoryName = cateName
        }
        if let cateImg = dictionary["image_url"] as? String
        {
            categoryImage = cateImg
        }
        if let catFullName = dictionary["title"] as? String
        {
            categoryFullName = catFullName
        }
    }
    
    func getLIkeParamDictionary() -> [String : Any]
    {
        let dictLogin = [
            "article_id" : articleID!
            ] as [String : Any]
        
        return dictLogin
    }
    
    func updateModel(usingDictionary dictionary:[String:Any]) -> Void
    {
        if let id = dictionary["id"] as? String
        {
            articleID = id
        }
        
        if let picture = dictionary["title"] as? String
        {
            title = picture
        }
        
        if let desc = dictionary["short_description"] as? String
        {
            description_short = desc
        }
        
        isLikeByMe = false
        
//        if let likeBy = dictionary["likes"] as? [String]
//        {
//            isLikeByMe = false
//
////            for likeStr in likeBy
////            {
////                if likeStr == UtilityClass.getUserIdData()
////                {
////                    isLikeByMe = true
////                }
////            }
//        }
        
        isBookmark = false
        
//        if let bookmarkk = dictionary["bookmarks"] as? [String]
//        {
//            isBookmark = false
//
////            for likeStr in bookmarkk
////            {
////                if likeStr == UtilityClass.getUserIdData()
////                {
////                    isBookmark = true
////                }
////            }
//        }
        
        if let cate = dictionary["categories"] as? [String:Any]
        {
            let cateNam = cate["name"]
            cateName = cateNam as? String
        }
        
        if let catID = dictionary["categories"] as? [String:Any]
        {
            let cateNam = catID["id"]
            cateID = cateNam as? String
        }
        
        if let name = dictionary["description"] as? String
        {
            description_long = name
        }
        
//        if let slug1 = dictionary["slug"] as? String
//        {
////            slug = baseURLStringArticleShare + "article/" + slug1
//        }
        
        if let postBy = dictionary["postby"] as? String
        {
            postedBy = postBy
        }
        
        if let isinvited = dictionary["publishing_date"] as? Int
        {
            postedTime  = String(isinvited)
        }
        
        if let commentVal = dictionary["comment_count"] as? NSInteger
        {
            commentsCount = String(commentVal)
        }
        
        if let viewVal = dictionary["view_count"] as? NSInteger
        {
            viewCount = String(viewVal)
        }
        
        if let likeVal = dictionary["like_count"] as? NSInteger
        {
            likesCount = String(likeVal)
        }
        
        if let img = dictionary["image_url"] as? String
        {
            imageUrl = String(img)
        }
    }
}

