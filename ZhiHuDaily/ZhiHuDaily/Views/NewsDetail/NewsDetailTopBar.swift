//
//  NewsDetailTopBar.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/22.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SnapKit

class NewsDetailTopBar: UIView {
    
    fileprivate lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var maskImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = #imageLiteral(resourceName: "Home_Image_Mask")
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        label.textAlignment = .justified
        return label
    }()
    
    fileprivate lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.textAlignment = .justified
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(maskImageView)
        addSubview(titleLabel)
        addSubview(sourceLabel)
        
        setLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setLayout() {
        imageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        
        maskImageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-30)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        sourceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(titleLabel)
            make.bottom.equalTo(-12)
        }
    }
    
    open func refreshViews(with model: NewsModel) {
        imageView.yy_setImage(with: URL(string: model.detailImageUrl), options: .allowInvalidSSLCertificates)
        titleLabel.text = model.title
        sourceLabel.text = "图片：\(model.imageSource)"
    }

}
