//
//  UnlikeKit.swift
//  uread
//
//  Created by Hao Dong on 9/21/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import Alamofire

class UnlikeKit {
    let dbManager = DatabaseManager.sharedInstance
    
    static let sharedInstance = UnlikeKit()
    
    func getUnlikeForJSONAndInsertRealm(completionHandler: (Bool, NSError?) -> Void) {
        let userId = UserKit.sharedInstance.UserId!
        let params: Dictionary<String, AnyObject> = ["userId": userId]
        let paramsURLEncoding = paramURLEncoding(apiName: "get_all_unlike_articles")
        request(.POST, "\(serverURL)get_all_unlike_articles", parameters: params, encoding: paramsURLEncoding, headers: nil).responseString { response in
            if let data = response.result.value {
                let json = JSON.parse(data)
                self.parseResult(json, completionHandler: completionHandler)
            } else {
                completionHandler(false, response.result.error)
            }
            
        }
    }
    func SetUnlikeArticle(withArticleId articleId: String, userId: String, originId: String, articleTitle: String,completionHandler: (Bool, NSError?) -> Void) {
        let parameters = [
            "userId": userId,
            "articleId": articleId,
            "originId":originId
        ]
        let paramsURLEncoding = paramURLEncoding(apiName: "unlike_article")
        request(.POST, "\(serverURL)unlike_article", parameters: parameters, encoding: paramsURLEncoding, headers: nil).responseString { response in
            if let data = response.result.value {
                let json = JSON.parse(data)
                if json["result"].string! == "0" {
                    let unLickArticle = UnlickInfo()
                    unLickArticle.articleId = articleId
                    unLickArticle.createTime = NSDate()
                    unLickArticle.title = articleTitle
                    self.dbManager.addUnlikesArticles([unLickArticle])
                    completionHandler(true,nil)
                } else {
                    completionHandler(false,NSError(domain: "result return 1", code: 1, userInfo: nil))
                }
            } else {
                completionHandler(false,response.result.error!)
            }
        }
    }
    func cancleUnlikeArticle(withArticleUrl articleUrl: String, articleId: String, userId: String, originId: String, completionHandler:(Bool, NSError?) -> Void) {
        let parameters = [
            "userId": userId,
            "articleId": articleId,
            "originId": originId
        ]
        let paramesURLEncoding = paramURLEncoding(apiName: "cancel_unlike_article")
        request(.POST, "\(serverURL)cancel_unlike_article", parameters: parameters, encoding: paramesURLEncoding, headers: nil).responseString { response in
            if let data = response.result.value {
                let json = JSON.parse(data)
                if json["result"].string! == "0" {
                    let unlike = self.dbManager.getUnlikesByfilter(NSPredicate(format: "url = %@", articleUrl))
                    self.dbManager.deleteUnlikes(unlike)
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, NSError(domain: "result return 1", code: 1, userInfo: nil))
                }
            } else {
                completionHandler(false, response.result.error!)
            }
        }
    }
    func parseResult(json: JSON, completionHandler: (Bool, NSError?) -> Void) {
        let result = json["result"].string!
        guard result == "0" else {
            return
        }
        //let description = json["description"].string!
        let unlikeList = json[Contants.getAllUnlikeArticles.unlikeList].array!
        print(unlikeList.count)
        for unlike in unlikeList {
            guard let articleId = unlike[Contants.getAllUnlikeArticles.articleId].string,
            let title = unlike[Contants.getAllUnlikeArticles.articleTitle].string,
            let url = unlike[Contants.getAllUnlikeArticles.articleUrl].string else {
                completionHandler(false, NSError(domain: "could not parse json", code: 1, userInfo: nil))
                return
            }
            let createTime = NSDate()
            let unlikeArticle = UnlickInfo()
            unlikeArticle.articleId = articleId
            unlikeArticle.title = title
            unlikeArticle.url = url
            unlikeArticle.createTime = createTime
            dbManager.addUnlikesArticles([unlikeArticle])
        }
        completionHandler(true, nil)
    }
    
}