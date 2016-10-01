//
//  Contants.swift
//  uread
//
//  Created by Hao Dong on 24/09/2016.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import UIKit

struct Contants {
    let serverUrl = "http://lab.jinkey.io/"
    
    struct response {
        static let result = "result"
        static let description = "description"
        static let id = "id"
        static let portrait = "portrait"
        static let name = "name"
        static let token = "token"
        static let originList = "originList"
        
        
    }
    struct getOriginList {
        static let apiName = "get_origin_list"
        static let keyword = "keyword"
        static let result = "result"
        static let description = "description"
        static let originlist = "originList"
        static let portrait = "portrait"
        static let name = "name"
        static let origin = "origin"
        static let account = "account"
        static let fake_link = "fake_link"
    }
    struct getSpecialOrigin {
        static let apiName = "get_special_origin"
        static let keyword = "keyword"
        static let result = "result"
        static let description = "description"
        static let origin = "origin"
    }
    struct getMyOriginList {
        static let apiName = "get_my_origin_list"
        static let userId = "userId"
        static let result = "result"
        static let description = "description"
        static let originList = "originList"
        static let originPortrait = "originPortrait"
        static let originId = "originId"
        static let originIdentification = "originIdentification"
        static let originName = "originName"
        static let originType = "originType"
        static let originDescription = "originDescription"
    }
    struct getPublicArticles {
        static let apiName = "get_public_articles"
        static let pageIndex = "pageIndex"
        static let result = "result"
        static let description = "description"
        static let content = "content"
        static let articleTime = "articleTime"
        static let articleTag = "articleTag"
        static let id = "id"
        static let articleAuthor = "articleAuthor"
        static let articleOrigin = "articleOrigin"
        static let articleTitle = "articleTitle"
        static let originId = "originId"
        static let articleCoverImg = "articleCoverImg"
        static let articleOriginUrl = "articleOriginUrl"
        static let interesting = "interesting"
        static let articleDescription = "articleDescription"
    }
    struct getHistoryArticles {
        static let apiName = "get_history_articles"
        static let userId = "userId"
        static let pageIndex = "pageIndex"
        static let result = "result"
        static let description = "description"
        static let content = "content"
        static let articleTime = "articleTime"
        static let articleTag = "articleTag"
        static let id = "id"
        static let articleAuthor = "articleAuthor"
        static let articleOrigin = "articleOrigin"
        static let articleTitle = "articleTitle"
        static let originId = "originId"
        static let articleCoverImg = "articleCoverImg"
        static let articleOriginUrl = "articleOriginUrl"
        static let interesting = "interesting"
        static let articleDescription = "articleDescription"
    }
    struct unlikeArticle {
        static let apiName = "unlike_article"
        static let userId = "userId"
        static let articleId = "articleId"
        static let originId = "originId"
    }
    struct cancelUnlikeArticle {
        static let apiName =  "cancel_unlike_article"
        static let userId = "userId"
        static let articleId = "articleId"
        static let originId = "originId"
        static let result = "result"
        static let description = "description"
    }
    struct getAllUnlikeArticles {
        static let apiName = "get_all_unlike_articles"
        static let userId = "userId"
        static let result = "result"
        static let description = "description"
        static let unlikeList = "unlikeList"
        static let articleUrl = "articleUrl"
        static let interesting = "insteresting"
        static let articleDescription = "articleDesctiption"
        static let articleAuthor = "articleAuthor"
        static let articleTime = "articleTime"
        static let articleCoverImg = "articleCoverImg"
        static let articleTitle = "articleTitle"
        static let articleOrigin = "articleOrigin"
        static let articleId = "articleId"
        static let articleTag = "articleTag"
        static let originId = "originId"
    }
    struct getCollectionList {
        static let apiName = "get_collection_list"
        static let userId = "userId"
        static let result = "result"
        static let description = "description"
        static let collectionList = "collectionList"
        static let coverImgUrl = "coverImgUrl"
        static let newUrl = "newUrl"
        static let collectionId = "collectionId"
        static let url = "url"
        static let title = "title"
        static let createTime = "createTime"
    }
    
}