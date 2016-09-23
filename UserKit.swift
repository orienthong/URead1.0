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

class UserKit {
    static let sharedInstance = UserKit()
    
    let dbManager = DatabaseManager.sharedInstance
    
    var UserId: String? {
        get {
            if let UserId = NSUserDefaults.standardUserDefaults().stringForKey(userIDKey) {
                if UserId == "" {
                    return nil
                }
                return UserId
            } else {
                return nil
            }
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: userIDKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    
    var isLoggedIn: Bool {
        return UserId != nil
    }
    
    func logout() {
        self.UserId = nil
    }
    
}

