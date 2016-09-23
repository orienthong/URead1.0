//
//  AppDelegate.swift
//  URead1.0
//
//  Created by Hao Dong on 16/9/15.
//  Copyright © 2016年 Hao Dong. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setUpButton()
        SMSSDK.registerApp("10ca1ca54efa2", withSecret: "fe6e4cc786a6fa2093a7860cc9161997")
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config
         
        return true
    }
    func setUpButton() {
        if let tabBarController = window?.rootViewController as? YALFoldingTabBarController {
            let firstItem = YALTabBarItem(itemImage: UIImage(named: "nearby_icon"), leftItemImage: nil, rightItemImage: nil)
            let secondItem = YALTabBarItem(itemImage: UIImage(named: "edit_icon"), leftItemImage: UIImage(named: "edit_icon"), rightItemImage: nil)
            tabBarController.leftBarItems = [firstItem!, secondItem!]
            
            let thirdItem = YALTabBarItem(itemImage: UIImage(named: "chats_icon"), leftItemImage: UIImage(named: "search_icon"), rightItemImage: UIImage(named: "new_chat_icon"))
            let forthItem = YALTabBarItem(itemImage: UIImage(named: "Contacts"), leftItemImage: nil, rightItemImage: nil)
            
            tabBarController.rightBarItems = [thirdItem!, forthItem!]
            
            tabBarController.centerButtonImage = UIImage(named: "plus_icon")
            
            
            tabBarController.selectedIndex = 2
            
            //Customize tabBarView
            
            tabBarController.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight
            tabBarController.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset
            tabBarController.tabBarView.backgroundColor = UIColor(red: 94.0/255.0, green: 91.0/255.0, blue: 149.0/255.0, alpha: 0.5)
            tabBarController.tabBarView.tabBarColor = UIColor(red: 72.0/255.0, green: 211.0/255.0, blue: 178.0/255.0, alpha: 0.5)
            tabBarController.tabBarViewHeight = YALTabBarViewDefaultHeight
            tabBarController.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets
            tabBarController.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

