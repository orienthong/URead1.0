//
//  User.swift
//  URead1.0
//
//  Created by Hao Dong on 9/17/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var token: String = ""
    dynamic var portraitURL: String = ""
    
    override class func primaryKey() -> String {
        return "id"
    }
    
}