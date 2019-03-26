//
//  ArticleModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class ArticleModel{
    var createdAt : String?
    var updatedAt : String?
    var categories : NSArray?
    var title : String?
    var title_my : String?
    var short_description : String?
    var short_description_my : String?
    var image_url : String?
    var postby : String?
    var publishing_date : String?
    var slug : String?
    
    init() {
        createdAt = ""
        updatedAt = ""
        categories = NSArray()
        title = ""
        title_my = ""
        short_description = ""
        short_description_my = ""
        image_url = ""
        postby = ""
        publishing_date = ""
        slug = ""
    }
    
    func updateArticleModel(_ articleDict:[String:Any]){
        if let createdAt1 = articleDict["createdAt"] as? String{
            createdAt = createdAt1
        }
        
        if let updatedAt1 = articleDict["updatedAt"] as? String{
            updatedAt = updatedAt1
        }
        
        if let categories1 = articleDict["categories"] as? NSArray{
            categories = categories1
        }
        
        if let title1 = articleDict["title"] as? String{
            title = title1
        }
        
        if let title_my1 = articleDict["title_my"] as? String{
            title_my = title_my1
        }
        
        if let short_description1 = articleDict["short_description"] as? String{
            short_description = short_description1
        }
        
        if let short_description_my1 = articleDict["short_description_my"] as? String{
            short_description_my = short_description_my1
        }
        
        if let image_url1 = articleDict["image_url"] as? String{
            image_url = image_url1
        }
        
        if let postby1 = articleDict["postby"] as? String{
            postby = postby1
        }
        
        if let publishing_date1 = articleDict["publishing_date"] as? String{
            publishing_date = publishing_date1
        }
        
        if let slug1 = articleDict["slug"] as? String{
            slug = slug1
        }
    }
}

//class ArticleModel
//{
//    var articleID : String?
//    var title: String?
//    var description_long : String?
//    var description_short : String?
//    var imageUrl : String?
//    var viewCount : String?
//    var postedTime : String?
//    var likesCount : String?
//    var cateName : String?
//    var commentsCount : String?
//    var slug : String?
//    var cateID : String?
//    var isLikeByMe : Bool?
//    var isBookmark : Bool?
//
//    var postedBy : String?
//
//    var categoryId : String?
//    var categoryName : String?
//    var categoryImage : String?
//    var categoryFullName : String?
//
//    init() {
//        articleID = ""
//        title = ""
//        description_long = ""
//        description_short = ""
//        cateID = ""
//        imageUrl = ""
//        viewCount = ""
//        postedTime = ""
//        likesCount = ""
//        cateName = ""
//        commentsCount = ""
//        postedBy = ""
//        slug = ""
//
//        isBookmark = false
//
//        categoryId = ""
//        categoryName = ""
//        categoryImage = ""
//        categoryFullName = ""
//    }
//
//    deinit {
//        print("Article Model deinit")
//    }
//
//    func updateCateModel(usingDictionary dictionary:[String:Any]) -> Void
//    {
//        if let cateID = dictionary["id"] as? String
//        {
//            categoryId = cateID
//        }
//        if let cateName = dictionary["name"] as? String
//        {
//            categoryName = cateName
//        }
//        if let cateImg = dictionary["image_url"] as? String
//        {
//            categoryImage = cateImg
//        }
//        if let catFullName = dictionary["title"] as? String
//        {
//            categoryFullName = catFullName
//        }
//    }
//
//    func getLIkeParamDictionary() -> [String : Any]
//    {
//        let dictLogin = [
//            "article_id" : articleID!
//            ] as [String : Any]
//
//        return dictLogin
//    }
//
//    func updateModel(usingDictionary dictionary:[String:Any]) -> Void
//    {
//        if let id = dictionary["id"] as? String
//        {
//            articleID = id
//        }
//
//        if let picture = dictionary["title"] as? String
//        {
//            title = picture
//        }
//
//        if let desc = dictionary["short_description"] as? String
//        {
//            description_short = desc
//        }
//
//        isLikeByMe = false
//
////        if let likeBy = dictionary["likes"] as? [String]
////        {
////            isLikeByMe = false
////
//////            for likeStr in likeBy
//////            {
//////                if likeStr == UtilityClass.getUserIdData()
//////                {
//////                    isLikeByMe = true
//////                }
//////            }
////        }
//
//        isBookmark = false
//
////        if let bookmarkk = dictionary["bookmarks"] as? [String]
////        {
////            isBookmark = false
////
//////            for likeStr in bookmarkk
//////            {
//////                if likeStr == UtilityClass.getUserIdData()
//////                {
//////                    isBookmark = true
//////                }
//////            }
////        }
//
//        if let cate = dictionary["categories"] as? [String:Any]
//        {
//            let cateNam = cate["name"]
//            cateName = cateNam as? String
//        }
//
//        if let catID = dictionary["categories"] as? [String:Any]
//        {
//            let cateNam = catID["id"]
//            cateID = cateNam as? String
//        }
//
//        if let name = dictionary["description"] as? String
//        {
//            description_long = name
//        }
//
////        if let slug1 = dictionary["slug"] as? String
////        {
//////            slug = baseURLStringArticleShare + "article/" + slug1
////        }
//
//        if let postBy = dictionary["postby"] as? String
//        {
//            postedBy = postBy
//        }
//
//        if let isinvited = dictionary["publishing_date"] as? Int
//        {
//            postedTime  = String(isinvited)
//        }
//
//        if let commentVal = dictionary["comment_count"] as? NSInteger
//        {
//            commentsCount = String(commentVal)
//        }
//
//        if let viewVal = dictionary["view_count"] as? NSInteger
//        {
//            viewCount = String(viewVal)
//        }
//
//        if let likeVal = dictionary["like_count"] as? NSInteger
//        {
//            likesCount = String(likeVal)
//        }
//
//        if let img = dictionary["image_url"] as? String
//        {
//            imageUrl = String(img)
//        }
//    }
//}
//
