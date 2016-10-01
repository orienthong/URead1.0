//
//  UnlickInfo.swift
//  uread
//
//  Created by Hao Dong on 9/20/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import RealmSwift

class UnlickInfo: Object {
   
    dynamic var articleId = ""
    dynamic var title = ""
    dynamic var url = ""
    dynamic var createTime = NSDate()
    
    override static func primaryKey() -> String? {
        return "articleId"
    }
    
}