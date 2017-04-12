//
//  ThemeVC.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/4/11.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import YYWebImage

class ThemeVC: UIViewController {
    
    //MARK: - var
    
    fileprivate lazy var navigationBar: ThemeNavigationBar = {
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: 64)
        let bar = ThemeNavigationBar(frame: rect, scrollView: self.newsTableView)
        bar.delegate = self
        return bar
    }()
    
    fileprivate lazy var backgroundImageView: UIImageView = {
        let view: UIImageView = UIImageView(frame: self.navigationBar.bounds)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var newsTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), style: .grouped)
        tableView.register(NewsCell.self, forCellReuseIdentifier: NSStringFromClass(NewsCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 64))
        headerView.backgroundColor = .clear
        //占位作用
        tableView.tableHeaderView = headerView //在设置代理之前设置header，就会出现tableview底部多了一块空区域
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.clipsToBounds = false
        return tableView
    }()
    
    fileprivate lazy var editorView: ThemeEditorView = {
        let view = ThemeEditorView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 40))
        view.addTarget(self, action: #selector(pushEditorsVC), for: .touchUpInside)
        return view
    }()
    
    fileprivate lazy var getThemeContentDS: GetThemeContent = {
        let ds = GetThemeContent()
        return ds
    }()
    
    fileprivate var origineImage: UIImage?
    fileprivate var newsModels = [NewsModel]()
    fileprivate var editorModels = [EditorModel]()
    var themeModel = ThemeModel()
    var themeId: Int = 0
    
    //MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
        configViews()
        loadThemeContent()
    }
    
    //MARK: - common set
    
    fileprivate func commonInit() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        navigationController?.setNavigationBarHidden(true, animated: true)
        fd_prefersNavigationBarHidden = true
    }
    
    fileprivate func configViews() {
        view.addSubview(newsTableView)
        view.addSubview(backgroundImageView)
        view.addSubview(navigationBar)
    }

}


//MARK: - load data

extension ThemeVC {
    
    fileprivate func loadThemeContent(completeBlock: (()->())? = nil) {
        getThemeContentDS.themeId = themeId
        getThemeContentDS.loadData { [weak self](api) in
            completeBlock?()
            guard let wself = self else {return}
            
            wself.themeModel = wself.getThemeContentDS.themeModel
            wself.newsModels = wself.getThemeContentDS.newsModels
            wself.editorModels = wself.getThemeContentDS.editorModels
            wself.refreshViews()
        }
    }
    
    fileprivate func refreshViews() {
        navigationBar.refreshViews(with: themeModel.name)
        let url = URL(string: themeModel.backgroundImage)
        backgroundImageView.yy_setImage(with: url, placeholder: #imageLiteral(resourceName: "Home_Image"), options: .allowBackgroundTask) { (image, url, type, stage, error) in
            self.origineImage = image
            self.setBlurRadiusPercent(percent: 1)
        }
        newsTableView.reloadData()
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension ThemeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(NewsCell.self), for: indexPath) as! NewsCell
        let model = newsModels[indexPath.row]
        cell.refreshViews(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return newsModels[indexPath.row].newsCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if editorModels.count > 0 {
            return editorView.xb_height
        }
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if editorModels.count > 0 {
            editorView.refreshViews(with: editorModels)
            return editorView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = newsModels[indexPath.row]
        pushDetailWebVC(model: model)
    }
    
    fileprivate func pushDetailWebVC(model: NewsModel) {
        let detailVC = NewsDetailWebVC(from: model)
        detailVC.dataSource = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc fileprivate func pushEditorsVC() {
        print("pushEditorsVC")
    }
}

//MARK: - NewsDetailWebVCDataSource

extension ThemeVC: NewsDetailWebVCDataSource {
    func newsDetail(webVC: NewsDetailWebVC, newsPositionFrom newsID: Int) -> NewsPositionInNewsList {
        var position = NewsPositionInNewsList.middle
        if newsModels.first!.newsID == newsID {
            position = .first
        } else if newsModels.last!.newsID == newsID {
            position = .last
        }
        
        if newsModels.count == 1 {
            position = .alone
        }
        
        return position
    }
    
    func newsDetail(webVC: NewsDetailWebVC, preNewsIDFrom currentNewsID: Int) -> Int {
        var newsIndex = 0
        
        for index in 0..<newsModels.count {
            let model = newsModels[index]
            if model.newsID == currentNewsID {
                newsIndex = index
                break;
            }
        }
        
        if newsIndex > 0 {
            return newsModels[newsIndex-1].newsID
        } else {
            return 0
        }
    }
    
    func newsDetail(webVC: NewsDetailWebVC, nextNewsIDFrom currentNewsID: Int) -> Int {
        var newsIndex = 0
        for index in 0..<newsModels.count {
            let model = newsModels[index]
            if model.newsID == currentNewsID {
                newsIndex = index
                break;
            }
        }
        
        if newsIndex < newsModels.count - 1 {
            return newsModels[newsIndex+1].newsID
        } else {
            return 0
        }
    }
    
    func newsDetail(webVC: NewsDetailWebVC, newsHasReaded currentNewsID: Int) {
        for model in newsModels {
            if model.newsID == currentNewsID {
                model.isRead = true
                break;
            }
        }
        
        newsTableView.reloadData()
    }
}


//MARK: - UIScrollViewDelegate

fileprivate let kScrollViewMaxOffset: CGFloat = 90

extension ThemeVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offsetY = scrollView.contentOffset.y
        if offsetY <= -kScrollViewMaxOffset {
            scrollView.contentOffset = CGPoint(x: 0, y: -kScrollViewMaxOffset)
            offsetY = -kScrollViewMaxOffset
        }
        
        if offsetY <= 0 {
            backgroundImageView.xb_height = 64 - offsetY
            let p: CGFloat = 1 - CGFloat(-offsetY / kScrollViewMaxOffset)
            setBlurRadiusPercent(percent: p)
        } else {
            backgroundImageView.xb_height = 64
            setBlurRadiusPercent(percent: 1)
        }
    }
    
    func setBlurRadiusPercent(percent: CGFloat) {
        DispatchQueue.global().async {
            let blurRadius = 5 * percent
            let image = self.origineImage?.applyBlur(withRadius: blurRadius, tintColor: nil, saturationDeltaFactor: 1.2, maskImage: nil)
            DispatchQueue.main.async {
                self.backgroundImageView.image = image
            }
        }
    }
}


//MARK: - ThemeNavigationControllerDelegate

extension ThemeVC: ThemeNavigationControllerDelegate {
    func navigationBar(_ navigationBar: ThemeNavigationBar, beginRefresh refreshHeader: CycleRefreshHeaderView) {
        loadThemeContent { 
            refreshHeader.endRefreshing()
        }
    }
    
    func navigationBar(_ navigationBar: ThemeNavigationBar, didClickBackButton button: UIButton) {
        if appDelegate.drawerController.openSide == .none {
            //当前状态是未展开左侧视图，点击展示左侧视图
            appDelegate.drawerController.open(.left, animated: true, completion: nil)
        } else {
            //
            appDelegate.drawerController.closeDrawer(animated: true, completion: nil)
        }
    }
    
    func navigationBar(_ navigationBar: ThemeNavigationBar, didClickRightButton button: UIButton) {
        
    }
}
