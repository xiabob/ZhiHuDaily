//
//  MenuTopBarView.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/4/8.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

class MenuTopBarView: UIView {

    fileprivate lazy var collectButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Menu_Icon_Collect"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitle("收藏", for: .normal)
        button.setTitleColor(kMenuGrayWhiteTextColor, for: .normal)
        button.setImagePosition(.top, spacing: 2)
        return button
    }()
    
    fileprivate lazy var messageButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Menu_Icon_Message"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitle("消息", for: .normal)
        button.setTitleColor(kMenuGrayWhiteTextColor, for: .normal)
        button.setImagePosition(.top, spacing: 2)
        return button
    }()
    
    fileprivate lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Menu_Icon_Setting"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitle("设置", for: .normal)
        button.setTitleColor(kMenuGrayWhiteTextColor, for: .normal)
        button.setImagePosition(.top, spacing: 2)
        return button
    }()
    
    fileprivate lazy var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red:0.11, green:0.14, blue:0.16, alpha:1)
        return line
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configViews() {
        addSubview(collectButton)
        addSubview(messageButton)
        addSubview(settingButton)
        addSubview(bottomLine)
        setLayout()
    }
    
    fileprivate func setLayout() {
        collectButton.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalTo(self)
        }
        
        messageButton.snp.makeConstraints { (make) in
            make.left.equalTo(collectButton.snp.right).offset(45)
            make.centerY.equalTo(collectButton)
        }
        
        settingButton.snp.makeConstraints { (make) in
            make.left.equalTo(messageButton.snp.right).offset(45)
            make.centerY.equalTo(collectButton)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(kXBBorderWidth)
        }
    }
}
