//
//  UreadUserDefault.swift
//  uread
//
//  Created by Hao Dong on 9/17/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import RealmSwift
import CoreSpotlight
import UIKit

public let v1AccessTokenKey = "v1AccessTokenKey"
public let userIDKey = "userID"
public let userNameKey = "userName"
public let portraitURLKey = "portraitURL"

//public struct Listener<T>: Hashable {
//    
//    let name: String
//    
//    public typealias Action = T -> Void
//    let action: Action
//    
//    public var hashValue: Int {
//        return name.hashValue
//    }
//}
//
//public func ==<T>(lhs: Listener<T>, rhs: Listener<T>) -> Bool {
//    return lhs.name == rhs.name
//}
//
//
//final public class Listenable<T> {
//    
//    public var value: T {
//        didSet {
//            setterAction(value)
//            
//            for listener in listenerSet {
//                listener.action(value)
//            }
//        }
//    }
//    
//    public typealias SetterAction = T -> Void
//    var setterAction: SetterAction
//    
//    var listenerSet = Set<Listener<T>>()
//    
//    public func bindListener(name: String, action: Listener<T>.Action) {
//        let listener = Listener(name: name, action: action)
//        
//        listenerSet.insert(listener)
//    }
//    
//    public func bindAndFireListener(name: String, action: Listener<T>.Action) {
//        bindListener(name, action: action)
//        
//        action(value)
//    }
//    
//    public func removeListenerWithName(name: String) {
//        for listener in listenerSet {
//            if listener.name == name {
//                listenerSet.remove(listener)
//                break
//            }
//        }
//    }
//    
//    public func removeAllListeners() {
//        listenerSet.removeAll(keepCapacity: false)
//    }
//    
//    public init(_ v: T, setterAction action: SetterAction) {
//        value = v
//        setterAction = action
//    }
//}


final public class UreadUserDefaults {
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    public static var isLogined: Bool {
        if let _ = defaults.stringForKey(v1AccessTokenKey) {
            return true
        } else {
            return false
        }
    }
    
    
//    public static var v1AccessToken: Listenable<String?> = {
//        let v1AccessToken = defaults?.stringForKey(v1AccessTokenKey)
//        return Listenable<String?>(v1AccessToken) {
//            v1AccessToken in
//            defaults?.setObject(v1AccessToken, forKey: v1AccessTokenKey)
//            
//        }
//    }()
//    
//    public static var userID: Listenable<String?> = {
//        let userID = defaults?.stringForKey(userIDKey)
//        return Listenable<String?>(userID) { userID in
//            defaults?.setObject(userID, forKey: userIDKey)
//        }
//    }()
//    
//    public static var userName: Listenable<String?> = {
//        let userName = defaults?.stringForKey(userNameKey)
//        return Listenable<String?>(userName) { userName in
//            defaults?.setObject(userName, forKey: userNameKey)
//            
//            guard let realm = try? Realm() else {
//                return
//            }
//            
//            
//        }
//    }()
//    
    
}
