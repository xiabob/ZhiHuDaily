//
//  MenuFullCell.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/4/10.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

class MenuFullCell: MenuCell {
    
    override func configViews() {
        super.configViews()
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(flagView)
        setLayout()
    }
    
    fileprivate func setLayout() {
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(20)
            make.centerY.equalTo(iconView)
        }
        
        flagView.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.centerY.equalTo(iconView)
            make.width.equalTo(80)
        }
    }
    
    func refreshViews(with iconImage: UIImage, model: ThemeModel) {
        themeModel = model
        iconView.image = iconImage
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
