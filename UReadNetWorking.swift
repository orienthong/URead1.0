//
//  UReadNetWorking.swift
//  uread
//
//  Created by Hao Dong on 9/17/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import Foundation
import Alamofire
import CryptoSwift

public let serverURL: String = "http://lab.jinkey.io/"

public func paramURLEncoding(apiName apiName: String) -> ParameterEncoding {
    return ParameterEncoding.Custom({ (request, params) -> (NSMutableURLRequest, NSError?) in
        let urlEncoding = Alamofire.ParameterEncoding.URLEncodedInURL
        let (urlRequest, error) = urlEncoding.encode(request, parameters: params)
        let mutableRequest = urlRequest.mutableCopy() as! NSMutableURLRequest
        mutableRequest.URL = NSURL(string: serverURL+apiName)
        mutableRequest.HTTPBody = urlRequest.URL?.query?.dataUsingEncoding(NSUTF8StringEncoding)
        return (mutableRequest, error)
    })
}

public enum Reason: CustomStringConvertible {
    case CouldNotParseJSON
    case PhoneIsExist
    case Other(NSError?)
    case unKnown
    case LoginByUnRegisteUser
    public var description: String {
        switch self {
        case .CouldNotParseJSON:
            return "Could not parse JSON"
        case .PhoneIsExist:
            return "phone is exist"
        case .LoginByUnRegisteUser:
            return "LoginByUnRegisteUser"
        case .Other(let error):
            return "\(error)"
        case .unKnown:
            return "unKnown error"
        }
    }
}
public typealias FailureHandler = (reason: Reason, errorMessage: String?) -> Void


public func checkIsExist(phone: String, failureHandler: FailureHandler?, completionHandler: Bool -> ()) {
    let params: Dictionary<String, AnyObject> = ["phone": phone]
    let paramUrlEncoding = paramURLEncoding(apiName: "check_is_exist")
    request(.POST, "\(serverURL)check_is_exist", parameters: params, encoding: paramUrlEncoding, headers: nil).responseString(completionHandler: { response in
        if let error = response.result.error {
            failureHandler?(reason: .Other(error), errorMessage: "unKnown")
            completionHandler(true)
            return
        } else {
            if let jsonData = response.result.value {
                let json = JSON.parse(jsonData)
                //print("CheckJSON:\(json)")
                if let errorCode = json["result"].int {
                    if errorCode == 1 {
                        //failureHandler?(reason: .PhoneIsExist, errorMessage: "PhoneIsExist")
                        completionHandler(true)
                        return
                    } else if errorCode == 2 {
                        failureHandler?(reason: .unKnown, errorMessage: "unKnown")
                        completionHandler(true)
                        return
                    } else {
                        completionHandler(false)
                        return
                    }
                }
            }
        }
    })
}

public func registerByMobile(phone: String, withAreaCode areaCode: String, password: String, name: String, failureHandler: FailureHandler?, completionHandler: LoginUser? -> Void) {
    
    checkIsExist(phone, failureHandler: failureHandler, completionHandler: {
        isExist in
        if isExist == true {
            print("phoneNumber is exist")
            return
        } else {
            failureHandler?(reason: .LoginByUnRegisteUser, errorMessage: "")
            print("can registe")
        }
    })
    
    print("Hey")
    let encodePassword = password.md5()
    let params: Dictionary<String, AnyObject> = ["phone": phone,"name": name ,"password": encodePassword]
    //print(_password)
    let paramUrlEncoding: ParameterEncoding = paramURLEncoding(apiName: "register")
    request(.POST, "\(serverURL)", parameters: params, encoding: paramUrlEncoding, headers: nil).responseString(completionHandler: {
        response in
        if let error = response.result.error {
            failureHandler?(reason: .Other(error), errorMessage: "unKnown")
            return
        }
        if let data = response.result.value {
            let json = JSON.parse(data)
            print(json)
            guard let userId = json["id"].string, let portrait = json["portrait"].string, let token = json["token"].string, let name = json["name"].string else {
                failureHandler?(reason: .CouldNotParseJSON, errorMessage: "")
                return
            }
            let loginUser = LoginUser(accessToken: token, userID: userId, username: name, portraitURL: portrait)
            completionHandler(loginUser)
        }
    })
    
}


public func loginByMobile(phone: String, withAreaCode areaCode: String, password: String, failureHandler: FailureHandler?, completion: LoginUser -> Void) {
    checkIsExist(phone, failureHandler: failureHandler, completionHandler: {
        isExist in
        if isExist == true {
            print("phoneNumber is exist")
            print("&************************")
            let encodePassword = password.md5()
            let params: Dictionary<String, AnyObject> = ["phone": phone, "password": encodePassword]
            let paramUrlEncoding: ParameterEncoding = paramURLEncoding(apiName: "login")
            request(.POST, "\(serverURL)", parameters: params, encoding: paramUrlEncoding, headers: nil).responseString() { response in
                if let error = response.result.error {
                    failureHandler?(reason: .Other(error), errorMessage: "网络错误")
                    return
                }
                if let data = response.result.value {
                    //print(data)
                    let json = JSON.parse(data)
                    //print("JSON: \(json)")
                    
                    guard let userId = json["id"].string, let portrait = json["portrait"].string, let token = json["token"].string, let name = json["name"].string else {
                        failureHandler?(reason: .CouldNotParseJSON, errorMessage: "密码错误")
                        return
                    }
                    let loginUser = LoginUser(accessToken: token, userID: userId, username: name, portraitURL: portrait)
                    completion(loginUser)
                }
            }
        } else {
            print("can login")
            failureHandler?(reason: .LoginByUnRegisteUser, errorMessage: "该手机号未注册，请前往注册")
        }
    })
}

public func loadingArticles() {
    
}
