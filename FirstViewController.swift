//
//  FirstViewController.swift
//  URead1.0
//
//  Created by Hao Dong on 9/19/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import UIKit
import ElasticTransition

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension FirstViewController: YALTabBarDelegate {
    func tabBarWillExpand(tabBar: YALFoldingTabBar!) {
        print("willExpand")
    }
    func tabBarDidExpand(tabBar: YALFoldingTabBar!) {
        print("didExpand")
    }
    func tabBarWillCollapse(tabBar: YALFoldingTabBar!) {
        print("willCollapse")
    }
    func tabBarDidCollapse(tabBar: YALFoldingTabBar!) {
        print("didCollapse")
    }
}
