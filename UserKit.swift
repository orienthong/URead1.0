//
//  UserKit.swift
//  URead1.0
//
//  Created by Hao Dong on 9/17/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import RealmSwift


// Models



public struct LoginUser: CustomStringConvertible {
    public let accessToken: String
    public let userID: String
    public let username: String?
    public let portraitURL: String?
    
    public var description: String {
        return "LoginUser(accessToken: \(accessToken), userID: \(userID), username: \(username),  avatarURLString: \(portraitURL))"
    }
}

public func saveTokenAndUserInfoOfLoginUser(loginUser: LoginUser) {
    let userDefault = NSUserDefaults.standardUserDefaults()
    userDefault.setObject(loginUser.accessToken, forKey: v1AccessTokenKey)
    userDefault.setObject(loginUser.portraitURL, forKey: portraitURLKey)
    userDefault.setObject(loginUser.userID, forKey: userIDKey)
    userDefault.setObject(loginUser.username, forKey: userNameKey)
    
}
