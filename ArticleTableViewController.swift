//
//  ArticleTableViewController.swift
//  uread
//
//  Created by Hao Dong on 9/21/16.
//  Copyright © 2016 Hao Dong. All rights reserved.
//

import UIKit
import LocalAuthentication
import AlamofireImage
import RealmSwift
import ESPullToRefresh

enum RefreshArticleMethod {
    case PullToRefresh
    case LoadingMore
}

class ArticleTableViewController: UITableViewController {
    
    let articleKit = ArticleKit.sharedInstance
    let dbManager = DatabaseManager.sharedInstance
    
    var  page = 1
    var nextPage = 2
    
    var loadMoreFooterView: LoadMoreTableFooterView?
    var loadingMore: Bool = false
    var loadingMoreShowing: Bool = true
    
    var headers: [String] = []
    
    var latestOffset: CGFloat = 0
    var lastArticle: Int = 0
    
    
    
    func initRefreshControl() {
        let header = ESRefreshHeaderAnimator()
        let _ = self.tableView.es_addPullToRefresh(animator: header, handler: {
            [weak self] in
            self?.refresh()
        })
        self.tableView.es_addPullToRefresh { 
            [weak self] in
            self?.tableView.es_stopPullToRefresh(completion: true)
            
        }
    }
    func refresh() {
        
    }
    
    @IBAction func addInformationOrigin(sender: AnyObject) {
        let isLogin = UserKit.sharedInstance.isLoggedIn
        
        if (isLogin == false){
            let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginView")
            self.presentViewController(loginView, animated: true, completion: nil)
        }else {
            
        }
    }
    //MARK: - Controller Life
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.rowHeight = UITableViewAutomaticDimension
        initLoadMoreView()
        print(dbManager.getArticlesCount())
        getMyArticleList(.PullToRefresh)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = false
        
        
        // 添加下拉刷新组件
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.whiteColor()
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self!.navigationController?.navigationBarHidden = false
            self!.tabBarController?.tabBar.hidden = false
            self!.getMyArticleList(.PullToRefresh)
            self?.tableView.dg_stopLoading()
            self!.reloadDataWithAnimation()
            
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 69/255.0, green: 192/255.0, blue: 26/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        // 移除下拉刷新组件
        tableView.dg_removePullToRefresh()
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = nil
        
    }
    
    

    
    //MARK: -TableView DataSource && Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dbManager.getArticlesCount())
        return dbManager.getArticlesCount()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleCell", forIndexPath: indexPath) as! ArticleTableViewCell
        let article = dbManager.getArticles()[indexPath.row]
        cell.articleCoverImage.af_setImageWithURL(NSURL(string: article.cover_image)!, placeholderImage: nil)
        cell.articleTitle.text = article.title
        cell.articleDescription.text = article.article_description
        if article.origin.componentsSeparatedByString("$")[0] == "Jianshu" {
            cell.originImage.af_setImageWithURL(NSURL(string: "https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=2407750184,3145198057&fm=58")!, placeholderImage: nil)
        } else {
            cell.originImage.af_setImageWithURL(NSURL(string: "http://img01.sogoucdn.com/net/a/04/link?appid=100520031&url=http://mmbiz.qpic.cn/mmbiz/IicV1H6JEtPfyYAbDDkjZLOOoiaKWl3vMAyxPc0CdJuqt58fc7h45QeB0yHUjYSibzyOIIvMk8xibsWcEibMXias6EjQ/0?wx_fmt=jpeg")!, placeholderImage: nil)
        }
        cell.articleAuthor.text =  article.author
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // 打开目标窗口且隐藏tab，返回的时候重新显示tab
        let articleWebView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ArticleWebView") as! ArticleWebviewController
        let article = dbManager.getArticles()[indexPath.row]
        articleWebView.targetURL = article.link
        self.hidesBottomBarWhenPushed = true
        presentViewController(articleWebView, animated: true, completion: nil)
        self.hidesBottomBarWhenPushed = false
    }
    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        print("")
    }
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    func initLoadMoreView() {// 上拉加载更多的组建
        
        if loadMoreFooterView == nil {
            loadMoreFooterView = LoadMoreTableFooterView(frame: CGRectMake(0, tableView.contentSize.height, tableView.frame.size.width, tableView.frame.size.height))
            loadMoreFooterView!.delegate = self
            loadMoreFooterView!.backgroundColor = UIColor.clearColor()
            tableView.addSubview(loadMoreFooterView!)
        }
    }
    func reloadDataWithAnimation () {
        
        //tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for (index, cell) in cells.enumerate() {
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
            UIView.animateWithDuration(1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
        }
    }
    
    func getMyArticleList(method: RefreshArticleMethod) {
        print("method\(method)")
        if UserKit.sharedInstance.isLoggedIn {
            print("is Logged in")
            if method == .PullToRefresh {
                articleKit.loadArticles(ifLogin: true, method: .PullToRefresh, atPageIndex: String(page), completionHandler: { success, errorMessage in
                    if success {
                        self.page = 1
                    } else {
                        print(errorMessage)
                        showAlert("error", message: "")
                        print("error***************")
                    }
                })
            } else if method == .LoadingMore {
                articleKit.loadArticles(ifLogin: true, method: .LoadingMore, atPageIndex: String(page + 1), completionHandler: { success, errormessage in
                    if success {
                        self.page = self.page + 1
                    } else {
                        showAlert("error", message: "")
                        print(errormessage)
                    }
                })
            }
        } else {
            print(UserKit.sharedInstance.isLoggedIn)
            if method == .PullToRefresh {
                articleKit.loadArticles(ifLogin: false, method: .PullToRefresh, atPageIndex: String(page), completionHandler: { success, errormessage  in
                    if success {
                        self.page = 1
                    } else {
                        print(errormessage)
                    }
                })
            } else if method == .LoadingMore {
                articleKit.loadArticles(ifLogin: false, method: .LoadingMore, atPageIndex: String(page + 1), completionHandler: { success, errormessage in
                    if success {
                        self.page = self.page + 1
                    } else {
                        print(errormessage)
                    }
                })
            }
        }
    }
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView)
    {
        
        if (loadingMoreShowing) {
            
            loadMoreFooterView!.loadMoreScrollViewDidScroll(scrollView)
            
        }
        
    }
    
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (loadingMoreShowing) {
            loadMoreFooterView!.loadMoreScrollViewDidEndDragging(scrollView)
        }

        
    }

}
extension ArticleTableViewController: LoadMoreTableFooterViewDelegate {
    func loadMoreTableFooterDidTriggerRefresh(view: LoadMoreTableFooterView) {
        
        loadMoreFooterView!.setState(.LoadMoreLoading)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            
            self.getMyArticleList(.LoadingMore)
            self.dbManager.getArticles()
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.doneLoadingMoreTableViewData()
                
                print("下页：\(self.nextPage)")
                
                if self.nextPage == self.page {
                    showAlert("没有更多文章了",message: "")
                }else {
                    self.page = self.nextPage
                }
                
                self.tableView.reloadData()
                
                if self.lastArticle + 1 < self.dbManager.getArticlesCount(){
                    self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.lastArticle + 1,inSection: 0), atScrollPosition: .Bottom, animated: true)
                }
            })
        })
    }
    
    func loadMoreTableFooterDataSourceIsLoading(view: LoadMoreTableFooterView) -> Bool {
        return loadingMore
    }
    
    func doneLoadingMoreTableViewData() {
        loadingMore = false
        loadMoreFooterView!.loadMoreScrollViewDataSourceDidFinishedLoading(tableView)
    }

}
