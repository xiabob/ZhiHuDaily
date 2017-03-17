//
//  MainNavigationBar.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/17.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SnapKit

class MainNavigationBar: UIView {
    
    fileprivate lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Home_Icon"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "Home_Icon"), for: .selected)
        button.addTarget(self, action: #selector(onMenuButtonClick), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.text = "今日热闻"
        return label
    }()
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = kMainNavigationBarColor
        
        configViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - config View
    
    fileprivate func configViews() {
        addSubview(menuButton)
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        menuButton.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalTo(self).offset(10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self).offset(10)
        }
    }
    
    //MARK: - action
    
    @objc fileprivate func onMenuButtonClick() {
        
    }

    func refreshBar(with title: String) {
        titleLabel.text = title
    }
}
