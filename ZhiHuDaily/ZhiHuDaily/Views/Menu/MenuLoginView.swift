//
//  MenuLoginView.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/4/8.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SnapKit

class MenuLoginView: UIView {
    
    fileprivate lazy var loginControl: UIControl = {
        let control = UIControl()
        return control
    }()

    fileprivate lazy var avatarView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = #imageLiteral(resourceName: "Menu_Avatar")
        return view
    }()
    
    fileprivate lazy var avatarMaskView: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "Menu_Avatar_Mask"))
        return view
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = kMenuGrayWhiteTextColor
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "请登录"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configViews() {
        addSubview(avatarView)
        addSubview(avatarMaskView)
        addSubview(nameLabel)
        addSubview(loginControl)
        setLayout()
    }
    
    fileprivate func setLayout() {
        avatarView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalTo(self)
            make.width.equalTo(35)
            make.height.equalTo(avatarView.snp.width)
        }
        
        avatarMaskView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(avatarView)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(20)
            make.centerY.equalTo(avatarView)
        }
        
        loginControl.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(nameLabel)
            make.top.bottom.equalTo(self)
        }
    }
}
