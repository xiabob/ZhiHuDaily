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


class NewsDetailWebVC: UIViewController {
    
    var newsModel = NewsModel()
    
    fileprivate lazy var topBarView: NewsDetailTopBar = {
        let view = NewsDetailTopBar(frame: CGRect(x: 0, y: -kBarOffsetHeight, width: kScreenWidth, height: kBarOriginHeight+kBarOffsetHeight))
        return view
    }()
    
    fileprivate lazy var webView: UIWebView = {
        let view = UIWebView(frame: CGRect(x: 0, y: kStatusBarHeight, width: kScreenWidth, height: kScreenHeight-kStatusBarHeight))
        view.backgroundColor = UIColor.white
        view.delegate = self
        view.scrollView.delegate = self
        view.scrollView.clipsToBounds = false
        //修改scrollView的滚动速度，取值范围是[0,1)，超出会崩溃
        view.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        return view
    }()
    
    fileprivate lazy var getNewsDetailDS: GetNewsDetail = {
        let ds = GetNewsDetail()
        return ds
    }()
    
    fileprivate var statusBarStyle: UIStatusBarStyle = .lightContent {
        didSet {
            UIApplication.shared.setStatusBarStyle(statusBarStyle, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        configViews()
        loadNewsDetailData()
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
    
    fileprivate func configViews() {
        view.addSubview(webView)
        webView.scrollView.addSubview(topBarView)
    }

    func loadNewsDetailData() {
        getNewsDetailDS.newsID = newsModel.newsID
        getNewsDetailDS.loadData { [weak self](api) in
            guard let wself = self else {return}
            wself.newsModel.update(by: wself.getNewsDetailDS.model)
            let htmlString = "<html><head><link href=\(wself.newsModel.css) rel='stylesheet' type='text/css' /></head><body>\(wself.newsModel.body)</body></html>"
            wself.webView.loadHTMLString(htmlString, baseURL: nil)
            wself.topBarView.refreshViews(with: wself.newsModel)
        }
    }
    
    func loadPreNews() {
        
    }

}


//MARK: - UIScrollViewDelegate

fileprivate let kBarOffsetHeight: CGFloat = 50
fileprivate let kBarOriginHeight: CGFloat = 200
fileprivate let kScrollViewMaxOffset: CGFloat = 90
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

