//
//  OriginKit.swift
//  uread
//
//  Created by Hao Dong on 9/21/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

class OriginKit {
    
    let dbManager = DatabaseManager.sharedInstance

    static let sharedInstance = OriginKit()
    
        func loadOriginlist(completionHandler: (Bool, NSError?) -> Void) {
        guard let userID = UserKit.sharedInstance.UserId else {
            completionHandler(false, NSError(domain: "未登录", code: 1, userInfo: nil))
            return
        }
        let parameters = [
            "userId": userID
        ]
        let parameterEncoding = paramURLEncoding(apiName: "get_my_origin_list")
        request(.POST, "\(serverURL)get_my_origin_list", parameters: parameters, encoding: parameterEncoding, headers: nil).responseString {
            response in
            if let data = response.result.value {
                let json = JSON.parse(data)
                if json["result"].string! == "0" {
                    self.parseOriginList(json["originList"].array!, completionHandler: completionHandler)
                } else {
                    completionHandler(false, NSError(domain: "result return 1", code: 1, userInfo: nil))
                }
            } else {
                completionHandler(false,response.result.error!)
            }
        }
    }
    func parseOriginList(originList: [JSON], completionHandler: (Bool, NSError?) -> Void){
        guard originList.count > 0 else {
            completionHandler(false, NSError(domain: "没有关注列表", code: 1, userInfo: nil))
            return
        }
        for content in originList {
            guard let originPortrait = content[Contants.getMyOriginList.originPortrait].string, let originId = content[Contants.getMyOriginList.originId].string, let originIdentification = content[Contants.getMyOriginList.originIdentification].string, let originName = content[Contants.getMyOriginList.originName].string, let originType = content[Contants.getMyOriginList.originType].string, let originDescription = content[Contants.getMyOriginList.originDescription].string else {
                completionHandler(false, NSError(domain: "Could not parseOriginList", code: 1, userInfo: nil))
                return
            }
            let origin = OriginInfo()
            origin.originDescription = originDescription
            origin.originId = originId
            origin.originIdentification = originIdentification
            origin.originName = originName
            origin.originType = originType
            origin.originPortrait = originPortrait
            dbManager.insertOriginsIntoReaml([origin])
        }
    }
}