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
    
    fileprivate lazy var barView: MainNavigationBar = { [unowned self] in
        let view = MainNavigationBar(frame: CGRect(x: 0, y: kStatusBarHeight, width: kScreenWidth, height: 40), scrollView: self.newsTableView)
        view.backgroundColor = kMainNavigationBarColor.withAlphaComponent(0)
        view.delegate = self
        return view
    }()
    
    fileprivate lazy var bannerView: XBCycleView = { [unowned self] in
        let view = XBCycleView(frame: CGRect(x: 0, y: -kBannerOffsetHeight, width: kScreenWidth, height: 200+kBannerOffsetHeight), imageArray: [])
        view.autoScrollTimeInterval = 4
        view.delegate = self
        return view
    }()
    
    fileprivate lazy var refreshFooter: MJRefreshAutoNormalFooter = { [unowned self] in
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadBeforeNews))
        footer?.isRefreshingTitleHidden = true
        footer?.setTitle("", for: .idle)
        return footer!
    }()
    
    fileprivate lazy var newsTableView: UITableView = { [unowned self] in
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bannerView.isAutoCycle = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bannerView.isAutoCycle = false
    }
    
    deinit {
        barView.removeFromSuperview()
    }

    //MARK: - config views
    
    fileprivate func commonInit() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        navigationController?.setNavigationBarHidden(true, animated: true)
        fd_prefersNavigationBarHidden = true
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
        getLatestNewsDS.loadDataFromLocal { [weak self](api) in
            guard let wself = self else {return}
            wself.topBannerNews = wself.getLatestNewsDS.topBannerNewsModel
            wself.normalNews.append(wself.getLatestNewsDS.normalNewsModel)
            wself.refreshViews()
            
            //fetch from network
            wself.loadNetWorkLatestNews()
        }
    }
    
    fileprivate func loadNetWorkLatestNews() {
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
        getBeforeNewsDS.loadDataFromLocal { [weak self](api) in
            guard let wself = self else {return}
            var hasLocalData = false
            if wself.getBeforeNewsDS.normalNewsModel.count > 0 {
                wself.normalNews.append(wself.getBeforeNewsDS.normalNewsModel)
                hasLocalData = true
            }
            wself.newsTableView.reloadData()
            wself.refreshFooter.endRefreshing()
            
            //get from network again
            wself.loadNetworkBeforeNews(hasLocalData: hasLocalData)
        }
    }
    
    fileprivate func loadNetworkBeforeNews(hasLocalData: Bool) {
        getBeforeNewsDS.loadData { [weak self](api) in
            guard let wself = self else {return}
            if wself.getBeforeNewsDS.normalNewsModel.count > 0 {
                if hasLocalData {
                    wself.normalNews[wself.normalNews.count-1] = wself.getBeforeNewsDS.normalNewsModel
                } else {
                    wself.normalNews.append(wself.getBeforeNewsDS.normalNewsModel)
                }
            }
            wself.newsTableView.reloadData()
        }
    }
    
    fileprivate func getModel(from newsID: Int, inModels newsModels: [NewsModel]) -> NewsModel? {
        var result: NewsModel?
        let _ = newsModels.contains { (innnerModel) -> Bool in
            if innnerModel.newsID == newsID {
                result = innnerModel
                return true
            } else {
                return false
            }
        }
        
        return result
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
    
    fileprivate func pushDetailWebVC(model: NewsModel) {
        let detailVC = NewsDetailWebVC(from: model)
        detailVC.dataSource = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


//MARK: - NewsDetailWebVCDataSource

extension MainVC: NewsDetailWebVCDataSource {
    func newsDetail(webVC: NewsDetailWebVC, newsPositionFrom newsID: Int) -> NewsPositionInNewsList {
        var position = NewsPositionInNewsList.middle
        if normalNews.first!.first!.newsID == newsID {
            position = .first
        } else if normalNews.last!.last!.newsID == newsID {
            position = .last
        }
        
        if normalNews.count == 1 && normalNews.first!.count == 1 {
            position = .alone
        }
        
        return position
    }
    
    func newsDetail(webVC: NewsDetailWebVC, preNewsIDFrom currentNewsID: Int) -> Int {
        var newsIndex = 0
        let sectionIndex: Int = normalNews.index { (newsSection) -> Bool in
            newsSection.contains(where: { (model) -> Bool in
                if model.newsID == currentNewsID {
                    newsIndex = newsSection.index(of: model)!
                    return true
                } else {
                    return false
                }
            })
        } ?? 0
        
        var preNewsID = 0
        if sectionIndex == 0 && newsIndex == 0 {
            preNewsID = -1
        } else if newsIndex == 0 {
            preNewsID = normalNews[sectionIndex-1].last!.newsID
        } else {
            preNewsID = normalNews[sectionIndex][newsIndex-1].newsID
        }
        
        return preNewsID
    }
    
    func newsDetail(webVC: NewsDetailWebVC, nextNewsIDFrom currentNewsID: Int) -> Int {
        var newsIndex = 0
        let sectionIndex: Int = normalNews.index { (newsSection) -> Bool in
            newsSection.contains(where: { (model) -> Bool in
                if model.newsID == currentNewsID {
                    newsIndex = newsSection.index(of: model)!
                    return true
                } else {
                    return false
                }
            })
        } ?? 0
        
        var nextNewsID = 0
        if sectionIndex == normalNews.count-1 && newsIndex == normalNews[sectionIndex].count-1 {
            nextNewsID = -1
        } else if newsIndex == normalNews[sectionIndex].count-1 {
            nextNewsID = normalNews[sectionIndex+1].first!.newsID
        } else {
            nextNewsID = normalNews[sectionIndex][newsIndex+1].newsID
        }
        
        return nextNewsID
    }
    
    func newsDetail(webVC: NewsDetailWebVC, newsHasReaded currentNewsID: Int) {
        let _ = normalNews.index { (newsSection) -> Bool in
            newsSection.contains(where: { (model) -> Bool in
                if model.newsID == currentNewsID {
                    model.isRead = true
                    return true
                } else {
                    return false
                }
            })
        }
        
        newsTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = normalNews[indexPath.section][indexPath.row]
        pushDetailWebVC(model: model)
    }
}


//MARK: - MainNavigationBarDelegate

extension MainVC: MainNavigationBarDelegate {
    func navigationBar(_ navigationBar: MainNavigationBar, didClickMenuButton button: UIButton) {
        if appDelegate.drawerController.openSide == .none {
            //当前状态是未展开左侧视图，点击展示左侧视图
            appDelegate.drawerController.open(.left, animated: true, completion: nil)
        } else {
            //
            appDelegate.drawerController.closeDrawer(animated: true, completion: nil)
        }
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
        var offsetY = scrollView.contentOffset.y
        if offsetY <= -kScrollViewMaxOffset {
            scrollView.contentOffset = CGPoint(x: 0, y: -kScrollViewMaxOffset)
            offsetY = -kScrollViewMaxOffset
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
        
        //提前预加载数据
        let cellHeight = normalNews.first?.first?.newsCellHeight ?? 90
        if offsetY >= scrollView.contentSize.height - scrollView.xb_height - cellHeight * 10 {
            refreshFooter.beginRefreshing()
        }
        
        //超出一定范围，不滚动banner
        if offsetY >= bannerView.origineHeight * 2 {
            bannerView.isAutoCycle = false
        } else {
            bannerView.isAutoCycle = true
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
        let model = topBannerNews[currentIndex]
        pushDetailWebVC(model: model)
    }
}
