//
//  SecondViewController.swift
//  URead1.0
//
//  Created by Hao Dong on 9/19/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import ElasticTransition
import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let targetURL = "http://mp.weixin.qq.com/s?__biz=MjM5ODg1NDI4OA==&mid=2651338681&idx=1&sn=bd5e6e20494b9d97cd00cecf7c77fec6&scene=4#wechat_redirect"
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: targetURL)!))
        webView.scrollView.bounces = false
        webView.opaque = false
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension SecondViewController: YALTabBarDelegate {
    
}
