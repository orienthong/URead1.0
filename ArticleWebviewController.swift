//
//  ArticleWebviewControllerViewController.swift
//  jinkeychat
//
//  Created by Jinkey on 16/6/7.
//  Copyright © 2016年 Jinkey. All rights reserved.
//

import UIKit
import Alamofire
import CryptoSwift


class ArticleWebviewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    let dbManager = DatabaseManager.sharedInstance
    
    @IBOutlet weak var favorButton: DOFavoriteButton!
    
    @IBOutlet weak var unlikeButton: DOFavoriteButton!
    
    @IBOutlet weak var shareButton: DOFavoriteButton!
    
    @IBOutlet weak var buttomBlurView: UIImageView!

    var targetURL = "http://mp.weixin.qq.com/s?__biz=MjM5ODg1NDI4OA==&mid=2651338681&idx=1&sn=bd5e6e20494b9d97cd00cecf7c77fec6&scene=4#wechat_redirect"
    
    // 进度条控件
    var progressView: UIProgressView!
    // 控制进度条走动频率
    var theBool: Bool?
    // 创建计时器
    var myTimer: NSTimer?
    
    var userDefault = NSUserDefaults.standardUserDefaults()
    
    let menu = UIMenuController.sharedMenuController()
    
    var image_url: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpButton()
        setUI()
        setUpWebView()
        webView.loadRequest(NSURLRequest(URL: NSURL(string:targetURL)!))
    }
    
    override func viewWillAppear(animated: Bool) {
        showMenu()
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        // 页面消失的时候移除进度条并恢复状态栏样式
        progressView.removeFromSuperview()
        self.navigationController?.navigationBar.alpha = 1.0
        
        // 移除长按弹出菜单
        UIMenuController.sharedMenuController().menuItems = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -WebViewDelegate
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        funcToCallWhenStartLoadingYourWebview()
        return true
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        
        // 加载完网页就隐藏进度条，并显示网页标题
        self.navigationItem.title = getTtile()
        self.theBool = true
        image_url = getCoverImageURL()
        title = getTtile()
        
    }
    //MARK: CustomMethod
    func setUpButton(){
        unlikeButton.addTarget(self, action: #selector(ArticleWebviewController.unlikeButtonTapped(_:)), forControlEvents: .TouchUpInside)
        favorButton.addTarget(self, action: #selector(ArticleWebviewController.favorButtonTapped(_:)), forControlEvents: .TouchUpInside)
        shareButton.addTarget(self, action: #selector(ArticleWebviewController.shareButtonTapped(_:)), forControlEvents: .TouchUpInside)
        
        if dbManager.chechIsCollection(targetURL.md5()){
            favorButton.select()
        }
        if dbManager.chechIsUnlike(targetURL){
            unlikeButton.select()
        }
        
    }
    func setUI() {
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.alpha = 0.9
        
        let progressBarHeight: CGFloat = 2.0
        let navigationBarBounds = self.navigationController?.navigationBar.bounds
        let barFrame = CGRect(x: 0, y: navigationBarBounds!.size.height - progressBarHeight, width: navigationBarBounds!.width, height: progressBarHeight)
        progressView = UIProgressView(frame: barFrame)
        progressView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
        
        self.navigationController!.navigationBar.addSubview(progressView)
    }
    func setUpWebView() {
        webView.delegate = self
        webView.scrollView.bounces = false
        webView.opaque = false
        webView.backgroundColor = UIColor.clearColor()
    }
    func getTtile() -> String{
        return webView.stringByEvaluatingJavaScriptFromString("document.title")! 
    }
    func getCoverImageURL() -> String {
        return webView.stringByEvaluatingJavaScriptFromString("document.getElementById('js_content').getElementsByTagName('img')[0].src")!
    }
    func showMenu() {
        // 自定义长按弹出菜单
        let menuItem1 = UIMenuItem(title: "搜索", action: #selector(self.searchText))
        let menuItem2 = UIMenuItem(title: "收藏", action: #selector(self.shareText))
        menu.menuItems = [menuItem1, menuItem2]
        menu.setMenuVisible(false, animated: true)
    }
    func funcToCallWhenStartLoadingYourWebview() {
        
        // 开始加载网页就显示进度条，设置进度为0且慢慢累加进度，开始计时器
        self.navigationItem.title = "正在加载..."
        self.progressView.hidden = false
        progressView.progress = 0
        theBool = false
        myTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(ArticleWebviewController.timerCallback), userInfo: nil, repeats: true)
        
    }
    func timerCallback() {
        if (self.theBool!) {
            if self.progressView.progress >= 1 {
                self.progressView.hidden = true
                self.myTimer!.invalidate()
            } else {
                progressView.setProgress(progressView.progress + 0.1, animated: true)
            }
        } else {
            progressView.setProgress(progressView.progress + 0.005, animated: false)
            if self.progressView.progress >= 0.95 {
                progressView.setProgress(0.95, animated: false)
            }
        }
    }
    
    //MARK: -Button Tapped Method
    func unlikeButtonTapped(sender: DOFavoriteButton) {
        var isNeedToDeleteCollection: Bool = true
        if sender.selected {
            sender.deselect()
            cancelUnlike()
        } else {
            sender.select()
            if favorButton.selected {
                favorButton.deselect()
                isNeedToDeleteCollection = true
            }else {
                isNeedToDeleteCollection = false
            }
            guard let userId = UserKit.sharedInstance.UserId else {
                showAlert("请登录", message: "")
                return
            }
            let articleId = dbManager.getArticlesByfilter(NSPredicate(format: "link = %@", targetURL))[0].id
            let originId = dbManager.getArticlesByfilter(NSPredicate(format: "link = %@", targetURL))[0].origin
            let title = getTtile()
            UnlikeKit.sharedInstance.SetUnlikeArticle(withArticleId: articleId, userId: userId, originId: originId,articleTitle: title, completionHandler: { success, error in
                if success {
                    if isNeedToDeleteCollection {
                        self.deleteCollection()
                    }
                } else {
                    sender.deselect()
                    if isNeedToDeleteCollection {
                        self.favorButton.select()
                    }
                    showAlert("error", message: (error?.domain)!)
                }
            })
        }
        
    }
    // 这里是收藏按钮的点击事件
    func favorButtonTapped(sender: DOFavoriteButton) {
        guard UserKit.sharedInstance.isLoggedIn else {
            showAlert("请登录", message: "")
            return
        }
        if sender.selected {
            sender.deselect()
            deleteCollection()
        } else {
            sender.select()
            sender.userInteractionEnabled = false
            CollectionKit.sharedInstance.collectArticle(withArticleUrl: targetURL, articleTitle: getTtile(), coverImageUrl: getCoverImageURL(), completionHandler: { success, error in
                if success {
                    self.unlikeButton.deselect()
                } else {
                    sender.deselect()
                    showAlert("error", message: (error?.domain)!)
                }
            })
            sender.userInteractionEnabled = true
        }
    }
    // 这里是分享按钮的事件
    func shareButtonTapped(sender: DOFavoriteButton) {
        
        sender.select()
        
        var img: UIImage!
        
        if image_url != "" {
            img = UIImage(data: NSData(contentsOfURL: NSURL(string: image_url)!)!)
        }else {
            img = UIImage(named: "userImage")
        }
        
        let title = getTtile()
        
        let activityViewController = UIActivityViewController(activityItems:
            [title,NSURL(string: targetURL)!,img!], applicationActivities: nil)
        let excludeActivities = [
            UIActivityTypePostToTwitter,
            UIActivityTypeMessage,
            UIActivityTypeMail,
            UIActivityTypePrint,
            UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo,
            UIActivityTypeAirDrop]
        
        activityViewController.excludedActivityTypes = excludeActivities
        
        activityViewController.completionWithItemsHandler = {(activityType:String?, completed:Bool, returnedItems:[AnyObject]?, activityError:NSError?) -> Void in
            
            if completed {
                showAlert("分享成功", message: "")
            }
            activityViewController.completionWithItemsHandler = nil
        }
        presentViewController(activityViewController, animated: true,
                              completion: nil)
        
        Async.background {
            NSThread.sleepForTimeInterval(1.5)
            }.main{
                sender.deselect()
        }
    }
    //取消不喜欢
    func cancelUnlike() {
        unlikeButton.userInteractionEnabled = false
        guard UserKit.sharedInstance.isLoggedIn else {
            showAlert("请登录", message: "")
            return
        }
        let userId = UserKit.sharedInstance.UserId!
        let articleId = dbManager.getUnlikesByfilter(NSPredicate(format: "url = %@", targetURL))[0].articleId
        let originId = dbManager.getArticlesByfilter(NSPredicate(format: "link = %@", targetURL))[0].origin
        UnlikeKit.sharedInstance.cancleUnlikeArticle(withArticleUrl: targetURL, articleId: articleId, userId: userId, originId: originId, completionHandler: { success, error in
            if success {
                showAlert("成功取消unlike", message: "")
            } else {
                self.unlikeButton.select()
                showAlert("error", message: "\(error!.domain)")
            }
        })
        unlikeButton.userInteractionEnabled = true
        
    }
    //取消收藏
    func deleteCollection() {
        favorButton.userInteractionEnabled = false
        CollectionKit.sharedInstance.deleteCollection(withArticleId: targetURL.md5(), userId: UserKit.sharedInstance.UserId!, completionHandler: {
            succes, error in
            if succes {
                showAlert("取消收藏成功", message: "")
            } else {
                self.favorButton.select()
                showAlert("失败", message: "\(error?.domain)")
            }
        })
        favorButton.userInteractionEnabled = true
    }
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(self.searchText) || action == #selector(self.shareText) || action == #selector(NSObject.copy(_:)){
            return true
        }else if action == #selector(NSObject.selectAll(_:)) || action == Selector("define:") || action == #selector(NSObject.selectAll(_:)) || action == Selector("share:") {
            return false
        }else {
            return false
        }
    }
    
    func searchText() {
        let searchText = webView.stringByEvaluatingJavaScriptFromString("window.getSelection().toString()")
        let nav = self.navigationController
        if searchText != nil {
            let articleWebView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArticleWebView") as! ArticleWebviewController
            articleWebView.targetURL = "https://www.baidu.com/s?wd=\(searchText!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)&ie=utf-8"
            nav?.hidesBottomBarWhenPushed = true
            menu.setMenuVisible(false, animated: true)
            nav?.pushViewController(articleWebView, animated: true)
        }
        
    }
    func shareText() {
        menu.setMenuVisible(false, animated: true)
        showAlert("收藏成功", message: "")
    }
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
}

