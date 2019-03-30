//
//  ArticleModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class ArticleModel{
    var categories : String?
    var title : String?
    var title_my : String?
    var short_description : String?
    var short_description_my : String?
    var image_url : String?
    var postby : String?
    var publishing_date : String?
    var slug : String?
    var description : String?
    var description_my : String?
    var id : String?
    
    init() {
        categories = ""
        title = ""
        title_my = ""
        short_description = ""
        short_description_my = ""
        image_url = ""
        postby = ""
        publishing_date = ""
        slug = ""
        description = ""
        description_my = ""
        id = ""
    }
    
    func updateArticleModel(_ articleDict:[String:Any]){
        
        if let categories1 = articleDict["categories"] as? String{
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
        
        if let description_my1 = articleDict["description_my"] as? String{
            description_my = description_my1
        }
        
        if let short_description1 = articleDict["description"] as? String{
            short_description = short_description1
        }
        
        if let description_my1 = articleDict["description_my"] as? String{
            description_my = description_my1
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
        
        if let id1 = articleDict["id"] as? String{
            id = id1
        }
    }
}
