//
//  JinkeyCustomMethod.swift
//  jinkeychat
//
//  Created by Jinkey on 16/4/24.
//  Copyright © 2016年 Jinkey. All rights reserved.
//

import Foundation
import RealmSwift

public class Jinkey {
    
    let realm = try! Realm()
    var articles: Results<ArticleInfo>
    var origins: Results<OriginInfo>
    var favors: Results<CollectionInfo>
    
    init () {
        
        articles = realm.objects(ArticleInfo)
        origins = realm.objects(OriginInfo)
        favors = realm.objects(CollectionInfo)
        
    }
    
    // ===============================================================================================
    // * -  * 界面设置类 的方法 =========================================================================
    // ===============================================================================================
    
    func initDefaultNavigationBarStyle(navigationView:UIViewController){
        // 按钮颜色
        navigationView.navigationController?.navigationBar.barTintColor = UIColor(red: 69/255, green: 192/255, blue: 26/255, alpha: 1)
        // 标题颜色
        navigationView.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        navigationView.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func themeColor() -> UIColor {
        return UIColor(red: 69/255, green: 192/255, blue: 26/255, alpha: 1)
    }
    
    // UIImage和UIColor的转换
    func createImageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage
    }
    
    // 查找父UINavigationController
    func findMyNavigationViewController(view:UIView)->UINavigationController?{
        var next:UIView? = view
        repeat{
            
            if let nextResponder = next?.nextResponder() where nextResponder.isKindOfClass(UINavigationController.self){
                return (nextResponder as! UINavigationController)
            }
            next = next?.superview
            
        }while next != nil
        
        return nil
    }
    
    func raiseLoginViewIfNotLogin(viewController: UIViewController) {
        
        if getCurrentUserId() == "" {
            // 获取目标页面
            let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginView")
            viewController.presentViewController(loginView, animated: true, completion: nil)
        }
        
    }
    // ===============================================================================================
    // * -  * 网络请求类 的方法 =========================================================================
    // ===============================================================================================
    
    // 从某个接口得到数据
    func getJSONFromAPIByPOST(url:String, data:String) -> AnyObject? {
        
        let getUserInformationURL: NSURL = NSURL(string: url)!
        let request = NSMutableURLRequest(URL: getUserInformationURL, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 5.0)
        let dataEncoded = data.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPMethod = "POST"
        request.HTTPBody = dataEncoded
        var response:NSURLResponse?
        var json:AnyObject?
        do{
            //发出请求
            let received:NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            print(data)
            json = try NSJSONSerialization.JSONObjectWithData(received!,
                                                              options:NSJSONReadingOptions.AllowFragments)
            
        }catch let error as NSError{
            //打印错误消息
            print(error.code)
            print(error.description)
        }
        
        return json
    }
    
    // 从jinkeyh.com得到数据
    func getJSONFromJinkeySiteByPOST(uri:String, data:String) -> AnyObject? {
        
        return self.getJSONFromAPIByPOST("http://lab.jinkeyh.com/\(uri)", data: data)
        
    }
    // 获取用户头像昵称
    func getUserInformationForId(userId:String) -> AnyObject? {
        
        return self.getJSONFromJinkeySiteByPOST("getUserInformation", data: "userId=\(userId)")
        
    }
    

    
    func escape(html: String) -> String{
        
        var result = html.stringByReplacingOccurrencesOfString("&", withString: "&amp;")
        result = result.stringByReplacingOccurrencesOfString("\"", withString: "&quot;")
        result = result.stringByReplacingOccurrencesOfString("'", withString: "&#39;")
        result = result.stringByReplacingOccurrencesOfString("<", withString: "&lt;")
        result = result.stringByReplacingOccurrencesOfString(">", withString: "&gt;")
        return result
        
    }
    
    func unescape(html: String) -> String{
        
        var result = html.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
        result = result.stringByReplacingOccurrencesOfString("&quot;", withString: "\"")
        result = result.stringByReplacingOccurrencesOfString("&#39;", withString: "'")
        result = result.stringByReplacingOccurrencesOfString("&lt;", withString: "<")
        result = result.stringByReplacingOccurrencesOfString("&gt;", withString: ">")
        return result
        
    }
    
    
    // ===============================================================================================
    // * -  * 数据处理类 的方法 =========================================================================
    // ===============================================================================================
    
    // 返回字符串的拼音首字母或者全部拼音
    func PYFirst(string:String?, _ allFirst:Bool=false)->String{
        var py="#"
        if let s = string {
            if s == "" {
                return py
            }
            let str = CFStringCreateMutableCopy(nil, 0, s)
            CFStringTransform(str, nil, kCFStringTransformToLatin, Bool(0))
            CFStringTransform(str, nil, kCFStringTransformStripCombiningMarks, Bool(0))
            py = ""
            if allFirst {
                for x in (str as String).componentsSeparatedByString(" ") {
                    py += PYFirst(x)
                }
            } else {
                py  = (str as NSString).substringToIndex(1).uppercaseString
            }
        }
        return py
    }
    
    // NSArray去重
    func noRepeatInsertToArray(array: NSArray, insertValue: String = "") -> NSArray {
        
        var set: Set<String> = []
        
        for each in array {
            
            set.insert(each as! String)
            
        }
        
        if insertValue != "" {
            
            set.insert(insertValue)
            
        }
        
        var temporaryArray: Array<String> = []
        
        for each in set {
            
            temporaryArray.append(each)
            
        }
        
        return NSArray(array: temporaryArray)
    }
    

    
    func defaultRealm() -> Realm {
        return realm
    }
    
    func getCurrentUserId() -> String {
        
        let userId = NSUserDefaults.standardUserDefaults().objectForKey("userId")
        if (userId == nil || (userId as! String) == "") {
            
            return ""
            
        }else {
            
            return NSUserDefaults.standardUserDefaults().objectForKey("userId") as! String
            
        }
        
        
    }
    
    func getCurrentTime() -> NSDate {
        
        return NSDate()
        
    }
 
}