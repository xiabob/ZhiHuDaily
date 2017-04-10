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
            make.right.equalTo(-30)
            make.centerY.equalTo(titleLabel)
        }
    }
    
    func refreshViews(with model: ThemeModel) {
        titleLabel.text = model.name
        if model.isSubscribed {
            flagView.image = #imageLiteral(resourceName: "Menu_Enter")
        } else {
            flagView.image = #imageLiteral(resourceName: "Dark_Menu_Follow")
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
