//
//  MenuNormalCell.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/4/10.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

class MenuNormalCell: MenuCell {

    override func configViews() {
        super.configViews()
        
        addSubview(titleLabel)
        addSubview(flagView)
        setLayout()
    }

    fileprivate func setLayout() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalTo(self)
        }
        
        flagView.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(80)
        }
    }
    
    func refreshViews(with model: ThemeModel) {
        themeModel = model
        titleLabel.text = model.name
        if model.isSubscribed {
            flagView.setImage(#imageLiteral(resourceName: "Menu_Enter"), for: .normal)
        } else {
            flagView.setImage(#imageLiteral(resourceName: "Dark_Menu_Follow"), for: .normal)
        }
        
        if model.isSelected {
            backgroundColor = kMenuSelectedColor
            titleLabel.textColor = UIColor.white
        } else {
            backgroundColor = kMenuBackgroundColor
            titleLabel.textColor = kMenuGrayWhiteTextColor
        }
    }
}
