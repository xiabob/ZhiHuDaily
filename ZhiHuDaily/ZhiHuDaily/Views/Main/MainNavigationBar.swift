//
//  MainNavigationBar.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/17.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SnapKit

protocol MainNavigationBarDelegate: NSObjectProtocol {
    func navigationBar(_ navigationBar: MainNavigationBar, didClickMenuButton button: UIButton);
    func navigationBar(_ navigationBar: MainNavigationBar, beginRefresh refreshHeader: CycleRefreshHeaderView);
}


class MainNavigationBar: UIView {
    
    fileprivate lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Home_Icon"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "Home_Icon"), for: .selected)
        button.addTarget(self, action: #selector(onMenuButtonClick(sender:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.text = "今日热闻"
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var cycleRefreshHeader: CycleRefreshHeaderView = {
        let header:CycleRefreshHeaderView = CycleRefreshHeaderView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        header.refreshBlock = { [weak self] in
            guard let wself = self else {return}
            wself.delegate?.navigationBar(wself, beginRefresh: header)
        }
        return header
    }()
    
    weak var delegate: MainNavigationBarDelegate?
    
    //MARK: - init
    
    init(frame: CGRect, scrollView: UIScrollView) {
        super.init(frame: frame)
        backgroundColor = kMainNavigationBarColor
        cycleRefreshHeader.scrollView = scrollView
        
        configViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - config View
    
    fileprivate func configViews() {
        addSubview(menuButton)
        addSubview(titleLabel)
        addSubview(cycleRefreshHeader)
    }
    
    override func layoutSubviews() {
        menuButton.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalTo(self).offset(10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(menuButton)
        }
        
        cycleRefreshHeader.snp.makeConstraints { (make) in
            make.right.equalTo(titleLabel.snp.left).offset(-6)
            make.centerY.equalTo(menuButton)
            make.size.equalTo(cycleRefreshHeader.xb_size)
        }
    }
    
    //MARK: - action
    
    @objc fileprivate func onMenuButtonClick(sender: UIButton) {
        delegate?.navigationBar(self, didClickMenuButton: sender)
    }

    func refreshBar(with title: String) {
        titleLabel.text = title
    }
}
