//
//  OriginKit.swift
//  URead1.0
//
//  Created by Hao Dong on 9/21/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import RealmSwift

class OriginKit {
    private let realm = try! Realm()
    private var origins: Results<OriginInfo>
    
    static let sharedInstance = OriginKit()
    
    private init() {
        
        origins = realm.objects(OriginInfo)
        
    }
    
    // 获取所有信息源
    func getOrigins() -> Results<OriginInfo> {
        
        return origins
        
    }
    
    // 筛选符合要求的信息源
    func getOriginsByfilter(filter: NSPredicate) -> Results<OriginInfo> {
        
        return origins.filter(filter)
        
    }
    
    
    // 获取本地信息源总数
    func getOriginsCount() -> Int {
        
        return origins.count
        
    }
    
    // 插入一些信息源
    func insertOriginsIntoReaml(origins: [OriginInfo]) {
        
        do{
            
            try realm.write{
                
                realm.add(origins, update: true)
                
            }
            
        }catch let error as NSError{
            
            print("写入出错 \(error)")
            
        }
        
    }
    
    // 清空信息源数据
    func clearOrigins() {
        
        do{
            try realm.write{
                
                realm.delete(origins)
                
            }
        }catch{
            
            print("删除出错")
            
        }
        
    }
    
    // 从服务器拉取文章并写入数据库
//    func getOriginsForJSONAndInsertRealm() {
//        
//        clearOrigins()
//        
//        let json = Jinkey().getJSONFromJinkeySiteByPOST("get_my_account_list", data: "userId=\(Jinkey().getCurrentUserId())")
//        
//        
//        if json != nil {
//            
//            let result = json!.objectForKey("result") as! String
//            let description = json!.objectForKey("description") as! String
//            print(result)
//            if result == "0" {
//                let accountList = json!.objectForKey("accountList") as! NSArray
//                
//                for account in accountList {
//                    
//                    let accountJSON = account as! NSDictionary
//                    
//                    let origin = OriginInfo(value: [
//                        
//                        "originId":                 accountJSON["originId"] as! String,
//                        "originPortrait":           accountJSON["originPortrait"] as! String,
//                        "originName":               accountJSON["originName"] as! String,
//                        "originIdentification":     accountJSON["originIdentification"] as! String,
//                        "originDescription":        accountJSON["originDescription"] as! String,
//                        "originLink":               "",
//                        "originType":               accountJSON["originType"] as! String,
//                        "originInitial":            Jinkey().PYFirst(accountJSON["originName"] as! String)
//                        
//                        ])
//                    
//                    insertOriginsIntoReaml([origin])
//                    
//                }
//                
//                
//            }else {
//                
//                SwiftSpinner.showWithDuration(1.5, title: "\(description)")
//                
//            }
//        }
//        
//    }
}