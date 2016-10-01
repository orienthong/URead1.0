//
//  DatabaseManager.swift
//  uread
//
//  Created by Hao Dong on 9/20/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {
    let realm = try! Realm()
    var articles: Results<ArticleInfo>
    var origins: Results<OriginInfo>
    var collections: Results<CollectionInfo>
    var unlikes: Results<UnlickInfo>
    
    static let sharedInstance = DatabaseManager()
    
    init () {
        articles = realm.objects(ArticleInfo)
        origins = realm.objects(OriginInfo)
        collections = realm.objects(CollectionInfo)
        unlikes = realm.objects(UnlickInfo)
    }
    
    //MARK: -ArticleKit
    func addArticle(article: ArticleInfo) {
        try! realm.write({
            realm.add(article, update: true)
        })
        print("Add article \(article.title)")
    }
    /**
     
    */
    func getArticles() -> Results<ArticleInfo> {
        return articles
    }
    func getArticlesCount() -> Int {
        return articles.count
    }
    func deleteArticles() {
        
        try! realm.write {
            realm.delete(articles)
            
        }
    }
    func getArticlesByfilter(filter: NSPredicate) -> Results<ArticleInfo> {
        return articles.filter(filter)
    }
    
    //MARK: -CollectionKit
    // 获取所有文章
    func getCollections() -> Results<CollectionInfo> {
        return collections
    }
    // 筛选符合要求的文章
    func getCollectionsByfilter(filter: NSPredicate) -> Results<CollectionInfo> {
        return collections.filter(filter)
    }
    // 获取本地文章总数
    func getCollectionsCount() -> Int {
        return collections.count
    }
    func addCollections(collections: [CollectionInfo]) {
        try! realm.write {
            realm.add(collections, update: true)
        }
    }
    func deleteCollections(collections: Results<CollectionInfo>) {
        try! realm.write {
            print(collections)
            realm.delete(collections)
            print("delete")
        }
    }
    func clearCollections() {
        try! realm.write {
            realm.delete(collections)
        }
    }
    // 查询某篇文章是否已经收藏
    func chechIsCollection(collectionId: String) -> Bool{
        if collections.filter("collectionId = %@", collectionId).count == 0 {
            return false
        }else {
            return true
        }
        
    }
    //MARK: -UnlikeKit
    // 获取所有文章
    func getUnlikes() -> Results<UnlickInfo> {
        return unlikes
    }
    // 筛选符合要求的文章
    func getUnlikesByfilter(filter: NSPredicate) -> Results<UnlickInfo> {
        return unlikes.filter(filter)
    }
    
    
    // 获取本地文章总数
    func getUnlikesCount() -> Int {
        return unlikes.count
    }
    
    // 插入一些文章
    func addUnlikesArticles(collections: [UnlickInfo]) {
            try! realm.write{
                realm.add(collections, update: true)
            }
    }
    
    // 删除一些文章
    func deleteUnlikes(_unlikes: Results<UnlickInfo>) {
        try! realm.write{
            print(_unlikes)
            realm.delete(_unlikes)
            print("deleted")
        }
    }
    // 清空文章数据
    func clearUnlikes() {
        try! realm.write {
            realm.delete(unlikes)
        }
    }
    // 查询某篇文章是否已经收藏
    func chechIsUnlike(url: String) -> Bool{
        if unlikes.filter("url = %@", url).count == 0 {
            return false
        }else {
            return true
        }
    }
    //MARK: -OriginKit
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

}