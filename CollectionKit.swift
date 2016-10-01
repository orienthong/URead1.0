//
//  CollectionKit.swift
//  uread
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
    func getCollectionForJSONAndInsertRealm(completionHandler: (Bool, NSError?) -> Void) {
        guard let userId = UserKit.sharedInstance.UserId else {
            completionHandler(false, NSError(domain: "未登陆", code: 1, userInfo: nil))
            return
        }
        let params: Dictionary<String, AnyObject> = ["userId": userId]
        let paramsURLEncoding = paramURLEncoding(apiName: "get_collection_list")
        request(.POST, "\(serverURL)get_collection_list", parameters: params, encoding: paramsURLEncoding, headers: nil).responseString { response in
            if let data = response.result.value {
                let json = JSON.parse(data)
                self.parseResult(json, completionHandler: completionHandler)
            } else {
                completionHandler(false, response.result.error)
            }
            
        }
    }
    func parseResult(data: JSON, completionHandler: (Bool, NSError?) -> Void) {
        let result = data["result"].string!
        guard result == "0" else {
            print("读取错误")
            return
        }
        let contents = data[Contants.getCollectionList.collectionList].array!
        for content in contents {
            let collection = CollectionInfo()
            guard let collectionId = content[Contants.getCollectionList.collectionId].string,
            let title = content[Contants.getCollectionList.title].string,
            let url = content[Contants.getCollectionList.url].string,
            let coverImage = content[Contants.getCollectionList.coverImgUrl].string,
            let createtime = content[Contants.getCollectionList.createTime].number else {
                completionHandler(false, NSError(domain: "could not parse json", code: 1, userInfo: nil))
                    return
            }
            let createTime = NSDate(timeIntervalSince1970: Double(createtime))
            collection.collectionId = collectionId
            collection.title = title
            collection.url = url
            collection.coverImgUrl = coverImage
            collection.createTime = createTime
            dbManager.addCollections([collection])
            completionHandler(true, nil)
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