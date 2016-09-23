//
//  ArticleKit.swift
//  URead1.0
//
//  Created by Hao Dong on 9/21/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import Alamofire
import MJRefresh

class ArticleKit {
    
    let dbManager = DatabaseManager.sharedInstance
    
    static let sharedInstance = ArticleKit()
    
    func loadArticles(ifLogin login: Bool, method: RefreshArticleMethod, atPageIndex pageIndex: String = "1", completionHandler: (Bool, String?) -> Void){
        
        if method == RefreshArticleMethod.LoadingMore {
            if login {
                let userId = UserKit.sharedInstance.UserId!
                let params: Dictionary<String, AnyObject> = ["userId": userId, "pageIndex": pageIndex]
                print(userId)
                let paramsURLEncoding = paramURLEncoding(apiName: "get_history_articles")
                request(.POST, "\(serverURL)get_history_articles", parameters: params, encoding: paramsURLEncoding, headers: nil).responseString { response in
                    if let data = response.result.value {
                        let json = JSON.parse(data)
                        if let contents = json["content"].array {
                            print("hha")
                            print(contents)
                            guard contents.count > 0 else {
                                completionHandler(false, "没有更多消息了")
                                return
                            }
                            self.parseArticles(contents)
                            completionHandler(true, nil)
                        } else {
                            completionHandler(false, json["description"].string!)
                        }
                    } else {
                        completionHandler(false, response.result.error?.domain)
                    }
                }
            } else {
                let params: Dictionary<String, AnyObject> = ["pageIndex": pageIndex]
                let paramsURLEncoding = paramURLEncoding(apiName: "get_public_articles")
                request(.POST, "\(serverURL)get_public_articles", parameters: params, encoding: paramsURLEncoding, headers: nil).responseString { response in
                    if let data = response.result.value {
                        let json = JSON.parse(data)
                        if let contents = json["content"].array {
                            guard contents.count > 0 else {
                                completionHandler(false, "没有更多文章")
                                return
                            }
                            self.parseArticles(contents)
                            completionHandler(true, nil)
                        } else {
                            completionHandler(false, "\(json["description"].string!)")
                        }
                    } else {
                        completionHandler(false, response.result.error?.domain)
                    }
                }
            }
        } else {
            if login {
                let userId = UserKit.sharedInstance.UserId!
                let params: Dictionary<String, AnyObject> = ["userId": userId, "pageIndex": pageIndex]
                let paramsURLEncoding = paramURLEncoding(apiName: "get_history_articles")
                request(.POST, "\(serverURL)get_history_articles", parameters: params, encoding: paramsURLEncoding, headers: nil).responseString { response in
                    if let data = response.result.value {
                        let json = JSON.parse(data)
                        if let contents = json["content"].array {
                            self.dbManager.deleteArticles()
                            guard contents.count > 0 else {
                                completionHandler(false, "没有更多文章")
                                return
                            }
                            self.parseArticles(contents)
                            completionHandler(true, nil)
                        } else {
                            completionHandler(false, json["description"].string!)
                        }
                    } else {
                        completionHandler(false, response.result.error?.domain)
                    }
                }
            } else {
                let params: Dictionary<String, AnyObject> = ["pageIndex": pageIndex]
                let paramsURLEncoding = paramURLEncoding(apiName: "get_public_articles")
                request(.POST, "\(serverURL)get_public_articles", parameters: params, encoding: paramsURLEncoding, headers: nil).responseString { response in
                    if let data = response.result.value {
                        let json = JSON.parse(data)
                        if let contents = json["content"].array {
                            self.dbManager.deleteArticles()
                            guard contents.count > 0 else {
                                completionHandler(false, "没有更多文章")
                                return
                            }
                            self.parseArticles(contents)
                            completionHandler(true, nil)
                        } else {
                            completionHandler(false, "\(json["description"].string!)")
                        }
                    } else {
                        completionHandler(false, "\(response.result.error?.domain)")
                    }
                }
            }
        }
    }
    func parseArticles(jsonArr: [JSON]) {
        for articleJson in jsonArr {
            if let article = parseArticle(articleJson) {
                dbManager.addArticle(article)
            } else {
                print("Article (with id \(articleJson["id"].string)) missing items!")
            }
        }
    }
    func parseArticle(json: JSON) -> ArticleInfo? {
        let originIdentification = (json["articleAuthor"].string)
        let author_object = OriginKit.sharedInstance.getOriginsByfilter(NSPredicate(format: "originIdentification = %@", originIdentification!))
        let author: String!
        if author_object.count != 0 {
            author = author_object[0].originName
        }else {
            author = originIdentification
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if
            let articleId = json["id"].string,
            let articleTitle = json["articleTitle"].string,
            let author = author,
            let cover_image = json["articleCoverImg"].string,
            let article_description = json["articleDescription"].string,
            let publish_time = dateFormatter.dateFromString(json["articleTime"].string!),
            let link = json["articleOriginUrl"].string,
            let origin = json["articleOrigin"].string {
            let article = ArticleInfo()
            article.id = articleId
            article.title = articleTitle
            article.author = author
            article.cover_image = cover_image
            article.article_description = article_description
            article.publish_time = publish_time
            article.link = link
            article.origin = origin
            return article
        } else {
            return nil
        }
    }
}