//
//  DatabaseManager.swift
//  URead1.0
//
//  Created by Hao Dong on 9/17/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {
    let realm: Realm!
    
    static let sharedInstance = DatabaseManager()
    
    private init() {
        let config = Realm.Configuration(schemaVersion: 17, migrationBlock: {
             migration, oldSchemaVersion in
            migration.deleteData("Uread")
            })
        realm = try! Realm(configuration: config)
    }
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    
}