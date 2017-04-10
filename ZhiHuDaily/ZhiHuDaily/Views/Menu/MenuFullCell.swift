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
            make.right.equalTo(-30)
            make.centerY.equalTo(iconView)
        }
    }
    
    func refreshViews(with iconImage: UIImage, model: ThemeModel) {
        iconView.image = iconImage
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
