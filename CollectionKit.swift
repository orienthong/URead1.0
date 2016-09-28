//
//  CollectionKit.swift
//  URead1.0
//
//  Created by Hao Dong on 9/21/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import Alamofire


class CollectionKit {
    
    let dbManager = DatabaseManager.sharedInstance
    
    static let sharedInstance = CollectionKit()
    
    // 从服务器拉取文章并写入数据库
    func getCollectionForJSONAndInsertRealm(completionHandler: (Bool) -> Void) {
        let userId = UserKit.sharedInstance.UserId!
        let params: Dictionary<String, AnyObject> = ["userId": userId, "pageIndex": "1"]
        let paramsURLEncoding = paramURLEncoding(apiName: "get_collection_list")
        request(.POST, "\(serverURL)get_collection_list", parameters: params, encoding: paramsURLEncoding, headers: nil).responseString { response in
            if let data = response.result.value {
                let json = JSON.parse(data)
                self.parseResult(json)
                completionHandler(true)
            } else {
                completionHandler(false)
            }
            
        }
    }
    func parseResult(data: JSON) {
        let result = data["result"].string!
        guard result == "0" else {
            print("读取错误")
            return
        }
        let contents = data["contents"].array!
        for content in contents {
            let collection = CollectionInfo()
            let collectionId = content["collectionId"].string!
            let title = content["title"].string!
            let url = content["url"].string!
            let coverImage = content["coverImgUrl"].string!
            let newUrl = content["newUrl"].string!
            let createTime = NSDate(timeIntervalSince1970: Double(content["createTime"].number!))
            collection.collectionId = collectionId
            collection.title = title
            collection.url = url
            collection.coverImgUrl = coverImage
            collection.newUrl = newUrl
            collection.createTime = createTime
            dbManager.addCollections([collection])
        }
    }
    
    func collectArticle(withArticleUrl articleUrl: String, articleTitle: String,coverImageUrl: String, completionHandler: (Bool, NSError?) -> Void) {
        let parameters = [
            "userId": UserKit.sharedInstance.UserId!,
            "url": articleUrl,
            "title": articleTitle,
            "coverImgUrl": coverImageUrl
        ]
        let parameterEncoding = paramURLEncoding(apiName: "add_collection")
        request(.POST, "\(serverURL)add_collection", parameters: parameters, encoding: parameterEncoding, headers: nil).responseString {
            response in
            if let data = response.result.value {
                let json = JSON.parse(data)
                if json["result"].string! == "0" {
                    let collection = CollectionInfo()
                    collection.collectionId = json["collectionId"].string!
                    collection.newUrl = json["newUrl"].string!
                    collection.createTime = NSDate(timeIntervalSince1970: Double(json["createTime"].number!))
                    collection.coverImgUrl = coverImageUrl
                    collection.title = articleTitle
                    collection.url = articleUrl
                    self.dbManager.addCollections([collection])
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, NSError(domain: "result return 1", code: 1, userInfo: nil))
                }
            } else {
                completionHandler(false,response.result.error!)
            }
        }
    }
    
    func deleteCollection(withArticleId articleId: String, userId: String, completionHandler: (Bool, NSError?) -> Void) {
        let parameters = [
            "userId": userId,
            "collectionId": articleId,
            ]
        let parameEncoding = paramURLEncoding(apiName: "delete_collection")
        request(.POST, "\(serverURL)delete_collection", parameters: parameters, encoding: parameEncoding, headers: nil).responseString {
            response in
            if let data = response.result.value {
                let json = JSON.parse(data)
                if json["result"].string! == "0" {
                    let collection = self.dbManager.getCollectionsByfilter(NSPredicate(format: "collectionId = %@", articleId))
                    self.dbManager.deleteCollections(collection)
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, NSError(domain: "result return 1", code: 1, userInfo: nil))
                }
            } else {
                completionHandler(false, response.result.error!)
            }
        }
    }
    
}