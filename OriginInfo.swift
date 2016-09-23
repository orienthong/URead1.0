//
//  OriginInfo.swift
//  URead1.0
//
//  Created by Hao Dong on 9/20/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import RealmSwift

class OriginInfo: Object {
    
    dynamic var originId = ""
    dynamic var originPortrait = ""
    dynamic var originName = ""
    dynamic var originIdentification = ""
    dynamic var originDescription = ""
    dynamic var originType = ""
    dynamic var originInitial = ""
    
    override static func primaryKey() -> String? {
        return "originId"
    }
}
