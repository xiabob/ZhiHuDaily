//
//  NewsDetailWebVC.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/22.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import WebKit
import MJRefresh

enum NewsPositionInNewsList {
    case first, middle, last, alone
}

protocol NewsDetailWebVCDataSource: NSObjectProtocol {
    func newsDetail(webVC: NewsDetailWebVC, newsPositionFrom newsID: Int) -> NewsPositionInNewsList
    func newsDetail(webVC: NewsDetailWebVC, preNewsIDFrom currentNewsID: Int) -> Int
    func newsDetail(webVC: NewsDetailWebVC, nextNewsIDFrom currentNewsID: Int) -> Int
    func newsDetail(webVC: NewsDetailWebVC, newsHasReaded currentNewsID: Int)
}

class NewsDetailWebVC: UIViewController {
    //MARK: - data var
    
    weak var dataSource: NewsDetailWebVCDataSource?
    var newsModel = NewsModel()
    var newsPosition: NewsPositionInNewsList {
        return dataSource?.newsDetail(webVC: self, newsPositionFrom: newsID) ?? .alone
    }
    fileprivate var preNewsID: Int {
        return dataSource?.newsDetail(webVC: self, preNewsIDFrom: newsID) ?? 0
    }
    fileprivate var nextNewsID: Int {
        return dataSource?.newsDetail(webVC: self, nextNewsIDFrom: newsID) ?? 0
    }
    fileprivate var newsID = 0 {
        didSet {
            loadHeader.positionFlag = newsPosition
            loadFooter.positionFlag = newsPosition
        }
    }
    
    //MARK: - view var
    fileprivate lazy var topBarView: NewsDetailTopBar = {
        let view = NewsDetailTopBar(frame: CGRect(x: 0, y: -kBarOffsetHeight, width: kScreenWidth, height: kBarOriginHeight+kBarOffsetHeight))
        return view
    }()
    
    fileprivate lazy var loadHeader: NewsDetailLoadHeader = { [unowned self] in
        let rect = CGRect(x: 0, y: -70, width: kScreenWidth, height: 30)
        let view = NewsDetailLoadHeader(frame: rect)
        view.positionFlag = self.newsPosition
        view.loadComplete = {self.loadPreNews()}
        return view
    }()
    
    fileprivate lazy var loadFooter: NewsDetailLoadFooter = {
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: 30)
        let view = NewsDetailLoadFooter(frame: rect)
        view.positionFlag = self.newsPosition
        view.loadComplete = {self.loadNextNews()}
        return view
    }()
    
    fileprivate lazy var bottomToolBar: NewsDetailBottomToolBar = {
        let view = NewsDetailBottomToolBar(frame: CGRect(x: 0, y: kScreenHeight-kTabBarHeight, width: kScreenWidth, height: kTabBarHeight))
        view.delegate = self
        return view
    }()
    
    fileprivate lazy var webView: UIWebView = { [unowned self] in
        let view = UIWebView(frame: CGRect(x: 0, y: kStatusBarHeight, width: kScreenWidth, height: kScreenHeight-kStatusBarHeight-kTabBarHeight))
        view.backgroundColor = UIColor.white
        view.delegate = self
        view.scrollView.delegate = self
        view.scrollView.clipsToBounds = false
        view.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        return view
    }()
    
    fileprivate lazy var getNewsDetailDS: GetNewsDetail = {
        let ds = GetNewsDetail()
        return ds
    }()
    
    fileprivate lazy var getNewsExtraDS: GetNewsExtraInfos = {
        let ds = GetNewsExtraInfos()
        return ds
    }()
    
    fileprivate lazy var voteNews: VoteNews = {
        let ds = VoteNews()
        return ds
    }()
    
    fileprivate var statusBarStyle: UIStatusBarStyle = .lightContent {
        didSet {
            UIApplication.shared.setStatusBarStyle(statusBarStyle, animated: true)
        }
    }
    
    
    //MARK: - init
    
    init(from model: NewsModel) {
        super.init(nibName: nil, bundle: nil)
        newsModel = model
        newsID = newsModel.newsID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        configViews()
        loadNewsDetailData()
    }
    
    deinit {
        loadHeader.removeObserver()
        loadFooter.removeObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
    }
    
    fileprivate func commonInit() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        fd_prefersNavigationBarHidden = true
    }
    
    //MARK: - set views and load
    
    fileprivate func configViews() {
        view.addSubview(webView)
        view.addSubview(bottomToolBar)
        webView.scrollView.addSubview(topBarView)
        webView.scrollView.addSubview(loadHeader)
        webView.scrollView.addSubview(loadFooter)
    }

    func loadNewsDetailData() {
        loadDetailDataLocal()
        loadExtraData()
    }
    
    fileprivate func loadDetailDataLocal() {
        //reset webview
        webView.loadHTMLString("", baseURL: nil)
        
        getNewsDetailDS.newsID = newsID
        getNewsDetailDS.loadDataFromLocal { [weak self](api) in
            guard let wself = self else {return}
            wself.newsModel = wself.getNewsDetailDS.model ?? wself.newsModel
            let htmlString = "<html><head><link href=\(wself.newsModel.css) rel='stylesheet' type='text/css' /></head><body>\(wself.newsModel.body)</body></html>"
            wself.webView.loadHTMLString(htmlString, baseURL: nil)
            wself.topBarView.refreshViews(with: wself.newsModel)
            
            wself.loadDetailDataOnline()
        }
    }
    
    fileprivate func loadDetailDataOnline() {
        getNewsDetailDS.newsID = newsID
        getNewsDetailDS.loadData { [weak self](api) in
            guard let wself = self else {return}
            wself.newsModel = wself.getNewsDetailDS.model ?? wself.newsModel
            let htmlString = "<html><head><link href=\(wself.newsModel.css) rel='stylesheet' type='text/css' /></head><body>\(wself.newsModel.body)</body></html>"
            wself.webView.loadHTMLString(htmlString, baseURL: nil)
            wself.topBarView.refreshViews(with: wself.newsModel)
            wself.dataSource?.newsDetail(webVC: wself, newsHasReaded: wself.newsID)
        }
    }
    
    fileprivate func loadExtraData() {
        getNewsExtraDS.newsID = newsID
        getNewsExtraDS.loadData { [weak self](api) in
            guard let wself = self else {return}
            wself.bottomToolBar.refreshViews(with: wself.getNewsExtraDS.model, andNewsPosition: wself.newsPosition)
        }
    }
    
    func loadPreNews() {
        let originSuperView = view.superview
        originSuperView?.addSubview(bottomToolBar)
        let snapshotImageView = UIImageView(image: view.snapshotImage())
        snapshotImageView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight)
        let maskView = UIView(frame: CGRect(x: 0, y: -kScreenHeight, width: kScreenWidth, height: kScreenHeight*2))
        maskView.addSubview(view)
        maskView.addSubview(snapshotImageView)
        originSuperView?.insertSubview(maskView, belowSubview: bottomToolBar)
        newsID = preNewsID
        loadNewsDetailData()
        UIView.animate(withDuration: 0.35, animations: {
            maskView.xb_top = 0
        }) { (finished) in
            maskView.removeFromSuperview()
            originSuperView?.addSubview(self.view)
            self.view.addSubview(self.bottomToolBar)
        }
    }

    func loadNextNews() {
        let originSuperView = view.superview
        originSuperView?.addSubview(bottomToolBar)
        let snapshotImageView = UIImageView(image: view.snapshotImage())
        snapshotImageView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        let maskView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight*2))
        view.xb_top = kScreenHeight
        maskView.addSubview(view)
        maskView.addSubview(snapshotImageView)
        originSuperView?.insertSubview(maskView, belowSubview: bottomToolBar)
        newsID = nextNewsID
        loadNewsDetailData()
        UIView.animate(withDuration: 0.35, animations: {
            maskView.xb_top = -kScreenHeight
        }) { (finished) in
            maskView.removeFromSuperview()
            self.view.xb_top = 0
            originSuperView?.addSubview(self.view)
            self.view.addSubview(self.bottomToolBar)
        }
    }
}


//MARK: - UIScrollViewDelegate

fileprivate let kBarOffsetHeight: CGFloat = 50
fileprivate let kBarOriginHeight: CGFloat = 200
fileprivate let kScrollViewMaxOffset: CGFloat = 80
fileprivate let kBarStartOffset: CGFloat = 60
fileprivate let kBarScrollLength: CGFloat = 130
extension NewsDetailWebVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= -kScrollViewMaxOffset {
            scrollView.contentOffset = CGPoint(x: 0, y: -kScrollViewMaxOffset)
        } 
        
        //设置顶部topBarView
        topBarView.xb_height = max(kBarOriginHeight + kBarOffsetHeight - offsetY, 0)
        topBarView.xb_top = -kBarOffsetHeight + offsetY
        
        //设置状态栏的状态
        if offsetY >= kBarOriginHeight + kStatusBarHeight {
            statusBarStyle = .default
            webView.scrollView.clipsToBounds = true
        } else {
            statusBarStyle = .lightContent
            webView.scrollView.clipsToBounds = false
        }
    }

}


//MARK: - UIWebViewDelegate
extension NewsDetailWebVC: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var url = request.url?.absoluteString ?? ""
        if url.hasPrefix("http://www.zhihu.com") {
            url = url.replacingOccurrences(of: "http", with: "zhihu")
            if let zhihuUrl = URL(string: url) {
                UIApplication.shared.openURL(zhihuUrl)
            }
            return false
        } else if url.hasPrefix("https://www.zhihu.com") {
            url = url.replacingOccurrences(of: "https", with: "zhihu")
            if let zhihuUrl = URL(string: url) {
                UIApplication.shared.openURL(zhihuUrl)
            }
            return false
        } else {
            
        }
        
        return true
    }
}


//MARK: - NewsDetailBottomToolBarDelegate

extension NewsDetailWebVC: NewsDetailBottomToolBarDelegate {
    func bottomToolBar(_ toolBar: NewsDetailBottomToolBar, didClickBackButton button: UIButton) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func bottomToolBar(_ toolBar: NewsDetailBottomToolBar, didClickNextButton button: UIButton) {
        loadNextNews()
    }
    
    func bottomToolBar(_ toolBar: NewsDetailBottomToolBar, didClickVoteButton button: UIButton) {
        voteNews.newsID = newsID
        voteNews.loadData { [weak self](api) in
            self?.loadExtraData()
        }
    }
    
    func bottomToolBar(_ toolBar: NewsDetailBottomToolBar, didClickShareButton button: UIButton) {
        
    }
    
    func bottomToolBar(_ toolBar: NewsDetailBottomToolBar, didClickCommentButton button: UIButton) {
        
    }
}

