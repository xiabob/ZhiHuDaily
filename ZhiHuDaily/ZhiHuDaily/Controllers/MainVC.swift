//
//  MainVC.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/17.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit


class MainVC: UIViewController {
    
    fileprivate lazy var barView: MainNavigationBar = {
        let view = MainNavigationBar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 60), scrollView: self.newsTableView)
        view.backgroundColor = kMainNavigationBarColor.withAlphaComponent(0)
        return view
    }()
    
    fileprivate lazy var bannerView: XBCycleView = {
        let view = XBCycleView(frame: CGRect(x: 0, y: -kBannerOffsetHeight, width: kScreenWidth, height: 220+kBannerOffsetHeight), imageArray: [])
        view.autoScrollTimeInterval = 4
        view.delegate = self
        return view
    }()
    
    fileprivate lazy var newsTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: self.bannerView.xb_bottom))
        headerView.backgroundColor = .clear
        //占位作用
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.clipsToBounds = false
        return tableView
    }()
    
    fileprivate var topBannerNews: [NewsModel] = []
    fileprivate var latestNews: [NewsModel] = []
    fileprivate var beforeNews: [[NewsModel]] = []
    
    fileprivate lazy var getLatestNewsDS: GetLatestNews = {
        let ds = GetLatestNews()
        return ds
    }()

    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        configViews()
        loadLatestNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    //MARK: - config views
    
    fileprivate func commonInit() {
        automaticallyAdjustsScrollViewInsets = false
    }
    
    fileprivate func configViews() {
        view.addSubview(newsTableView)
        view.addSubview(bannerView)
        view.addSubview(barView)
    }

    //MARK: - load data
    
    fileprivate func loadLatestNews() {
        getLatestNewsDS.loadData { [weak self](api) in
            guard let wself = self else {return}
            wself.topBannerNews = wself.getLatestNewsDS.topBannerNewsModel
            wself.latestNews = wself.getLatestNewsDS.normalNewsModel
            
            wself.refreshViews()
        }
    }

    fileprivate func refreshViews() {
        bannerView.imageModelArray = topBannerNews.map({ (model) -> XBCycleViewImageModel in
            return XBCycleViewImageModel(title: model.title, describe: nil, imageUrlString: model.imageUrl, localImage: nil)
        })
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}


//MARK: - UIScrollViewDelegate

fileprivate let kBannerOffsetHeight: CGFloat = 30
fileprivate let kScrollViewMaxOffset: CGFloat = 100
fileprivate let kBarStartOffset: CGFloat = 60
fileprivate let kBarScrollLength: CGFloat = 130
extension MainVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= -kScrollViewMaxOffset {
            scrollView.contentOffset = CGPoint(x: 0, y: -kScrollViewMaxOffset)
        }
        
        //轮播banner
        bannerView.height = bannerView.origineHeight - offsetY
        bannerView.y = -kBannerOffsetHeight
        
        //导航栏透明度
        var alpha: CGFloat = 0
        if offsetY <= kBarStartOffset {
            alpha = 0
        } else {
            alpha = min(CGFloat((offsetY-kBarStartOffset)/kBarScrollLength), CGFloat(1))
        }
        barView.backgroundColor = kMainNavigationBarColor.withAlphaComponent(alpha)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        bannerView.isAutoCycle = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        bannerView.isAutoCycle = true
    }
}

//MARK: - XBCycleViewDelegate
extension MainVC: XBCycleViewDelegate {
    func tapImage(_ cycleView: XBCycleView, currentImage: UIImage?, currentIndex: Int) {
        
    }
}
