//
//  MenuBottomBarView.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/4/8.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

class MenuBottomBarView: UIView {

    fileprivate lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Menu_Download"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("离线", for: .normal)
        button.setTitleColor(kMenuGrayWhiteTextColor, for: .normal)
        button.setImagePosition(.left, spacing: 10)
        return button
    }()

    fileprivate lazy var darkOrDayButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Menu_Dark"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("夜间", for: .normal)
        button.setTitleColor(kMenuGrayWhiteTextColor, for: .normal)
        button.setImagePosition(.left, spacing: 10)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configViews() {
        addSubview(downloadButton)
        addSubview(darkOrDayButton)
        setLayout()
    }
    
    fileprivate func setLayout() {
        downloadButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(darkOrDayButton)
        }
        
        darkOrDayButton.snp.makeConstraints { (make) in
            make.left.equalTo(downloadButton.snp.right)
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(downloadButton)
        }
    }
}
