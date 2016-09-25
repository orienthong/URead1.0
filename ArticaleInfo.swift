//
//  ArticaleInfo.swift
//  URead1.0
//
//  Created by Hao Dong on 9/20/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import RealmSwift

class ArticleInfo: Object {
    
    dynamic var id = ""
    dynamic var title = ""
    dynamic var author: String? = nil
    dynamic var cover_image = ""
    dynamic var article_description: String = ""
    dynamic var publish_time = NSDate()
    dynamic var link = ""
    dynamic var origin = ""
    dynamic var like = 0
    dynamic var unlike = 0
    dynamic var stay_time = 0
    dynamic var read_depth = 0
    dynamic var read_times = 0
    
    
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
