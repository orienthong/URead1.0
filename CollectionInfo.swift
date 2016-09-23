//
//  CollectionInfo.swift
//  URead1.0
//
//  Created by Hao Dong on 9/20/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import RealmSwift

class CollectionInfo: Object {
    
    dynamic var collectionId = ""
    dynamic var title = ""
    dynamic var url = ""
    dynamic var coverImgUrl = ""
    dynamic var newUrl = ""
    dynamic var createTime = NSDate()
    
    override static func primaryKey() -> String? {
        return "collectionId"
    }
    
}