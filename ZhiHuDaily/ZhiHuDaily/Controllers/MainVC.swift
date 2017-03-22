//
//  MainVC.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/17.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import MJRefresh

class MainVC: UIViewController {
    fileprivate lazy var statusBackgroundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kStatusBarHeight))
        view.backgroundColor = kMainNavigationBarColor.withAlphaComponent(0)
        return view
    }()
    
    fileprivate lazy var barView: MainNavigationBar = {
        let view = MainNavigationBar(frame: CGRect(x: 0, y: kStatusBarHeight, width: kScreenWidth, height: 40), scrollView: self.newsTableView)
        view.backgroundColor = kMainNavigationBarColor.withAlphaComponent(0)
        view.delegate = self
        return view
    }()
    
    fileprivate lazy var bannerView: XBCycleView = {
        let view = XBCycleView(frame: CGRect(x: 0, y: -kBannerOffsetHeight, width: kScreenWidth, height: 200+kBannerOffsetHeight), imageArray: [])
        view.autoScrollTimeInterval = 4
        view.delegate = self
        return view
    }()
    
    fileprivate lazy var refreshFooter: MJRefreshAutoNormalFooter = {
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadBeforeNews))
        footer?.isRefreshingTitleHidden = true
        footer?.setTitle("", for: .idle)
        return footer!
    }()
    
    fileprivate lazy var newsTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: kStatusBarHeight, width: kScreenWidth, height: kScreenHeight-kStatusBarHeight), style: .plain)
        tableView.register(NewsCell.self, forCellReuseIdentifier: NSStringFromClass(NewsCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: self.bannerView.xb_bottom))
        headerView.backgroundColor = .clear
        //占位作用
        tableView.tableHeaderView = headerView //在设置代理之前设置header，就会出现tableview底部多了一块空区域
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.clipsToBounds = false
        tableView.mj_footer = self.refreshFooter
        return tableView
    }()
    
    fileprivate var topBannerNews: [NewsModel] = []
    fileprivate var normalNews: [[NewsModel]] = []
    fileprivate var firsetSectionHeaderOffset: CGFloat = 0
    
    fileprivate lazy var getLatestNewsDS: GetLatestNews = {
        let ds = GetLatestNews()
        return ds
    }()
    fileprivate lazy var getBeforeNewsDS: GetBeforeNews = {
        let ds = GetBeforeNews()
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
        view.backgroundColor = UIColor.white
    }
    
    fileprivate func configViews() {
        view.addSubview(newsTableView)
        //添加到newsTableView上是为了方便处理在bannerView上的下拉操作
        newsTableView.addSubview(bannerView)
        view.addSubview(barView)
        view.addSubview(statusBackgroundView)
    }

    //MARK: - load data
    
    fileprivate func loadLatestNews() {
        getLatestNewsDS.loadData { [weak self](api) in
            guard let wself = self else {return}
            wself.topBannerNews = wself.getLatestNewsDS.topBannerNewsModel
            if wself.normalNews.count > 0 {
                wself.normalNews[0] = wself.getLatestNewsDS.normalNewsModel
            } else {
                wself.normalNews.append(wself.getLatestNewsDS.normalNewsModel)
            }
            
            wself.refreshViews()
        }
    }
    
    fileprivate func reloadLatestNews(completeBlock: (()->())? = nil) {
        getLatestNewsDS.loadData { [weak self](api) in
            guard let wself = self else {return}
            wself.topBannerNews = wself.getLatestNewsDS.topBannerNewsModel
            if wself.normalNews.count > 0 {
                wself.normalNews[0] = wself.getLatestNewsDS.normalNewsModel
            } else {
                wself.normalNews.append(wself.getLatestNewsDS.normalNewsModel)
            }
            
            completeBlock?()
            wself.refreshViews()
        }
    }
    
    func loadBeforeNews() {
        //若果需要查询 11 月 18 日的消息，before 后的数字应为 20131119
        guard let model = normalNews.last?.first else {return}
        getBeforeNewsDS.beforeDate = model.rawDate
        getBeforeNewsDS.loadData { [weak self](api) in
            guard let wself = self else {return}
            if wself.getBeforeNewsDS.normalNewsModel.count > 0 {
                wself.normalNews.append(wself.getBeforeNewsDS.normalNewsModel)
            }
            wself.newsTableView.reloadData()
            wself.refreshFooter.endRefreshing()
        }
    }

    fileprivate func refreshViews() {
        bannerView.imageModelArray = topBannerNews.map({ (model) -> XBCycleViewImageModel in
            return XBCycleViewImageModel(title: model.title, describe: nil, imageUrlString: model.imageUrl, localImage: nil)
        })
        newsTableView.reloadData()
        
        let count = CGFloat(normalNews.first?.count ?? 0)
        let cellHeight = normalNews.first?.first?.newsCellHeight ?? 0
        firsetSectionHeaderOffset = newsTableView.tableHeaderView!.xb_height + count * cellHeight
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return normalNews.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return normalNews[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(NewsCell.self), for: indexPath) as! NewsCell
        let model = normalNews[indexPath.section][indexPath.row]
        cell.refreshViews(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {return nil}
        
        let height = self.tableView(tableView, heightForHeaderInSection: section)
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.xb_width, height: height))
        label.backgroundColor = kMainNavigationBarColor
        label.textColor = UIColor.white
        label.text = normalNews[section].first?.date
        label.textAlignment = .center
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = normalNews[indexPath.section][indexPath.row]
        return model.newsCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 40
        }
    }
}


//MARK: - MainNavigationBarDelegate

extension MainVC: MainNavigationBarDelegate {
    func navigationBar(_ navigationBar: MainNavigationBar, didClickMenuButton button: UIButton) {
    }
    
    func navigationBar(_ navigationBar: MainNavigationBar, beginRefresh refreshHeader: CycleRefreshHeaderView) {
        reloadLatestNews {
            refreshHeader.endRefreshing()
        }
    }
}


//MARK: - UIScrollViewDelegate

fileprivate let kBannerOffsetHeight: CGFloat = 50
fileprivate let kScrollViewMaxOffset: CGFloat = 100
fileprivate let kBarStartOffset: CGFloat = 60
fileprivate let kBarScrollLength: CGFloat = 130
extension MainVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= -kScrollViewMaxOffset {
            scrollView.contentOffset = CGPoint(x: 0, y: -kScrollViewMaxOffset)
        }
        
        //轮播banner，如果是添加到view上，那么bannerView.y = -kBannerOffsetHeight，因为tableview是scrollview，会改变bannerView的相对位置，所以需要加上一个相对偏移offsetY
        bannerView.height = bannerView.origineHeight - offsetY
        bannerView.y = -kBannerOffsetHeight + offsetY
        
        //导航栏透明度
        var alpha: CGFloat = 0
        if offsetY <= kBarStartOffset {
            alpha = 0
            barView.backgroundColor = kMainNavigationBarColor.withAlphaComponent(alpha)
            statusBackgroundView.backgroundColor = barView.backgroundColor
        } else if offsetY <= kBarScrollLength + kBarStartOffset {
            alpha = (offsetY-kBarStartOffset)/kBarScrollLength
            barView.backgroundColor = kMainNavigationBarColor.withAlphaComponent(alpha)
            statusBackgroundView.backgroundColor = barView.backgroundColor
        } else {
            statusBackgroundView.backgroundColor = kMainNavigationBarColor.withAlphaComponent(1)
            
            if firsetSectionHeaderOffset > 0 {
                if offsetY < firsetSectionHeaderOffset {
                    barView.backgroundColor = kMainNavigationBarColor.withAlphaComponent(1)
                    barView.refreshBar(with: "今日热闻")
                } else {
                    barView.backgroundColor = kMainNavigationBarColor.withAlphaComponent(0)
                    barView.refreshBar(with: "")
                }
            }
        }
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
