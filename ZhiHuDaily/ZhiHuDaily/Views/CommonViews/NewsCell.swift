//
//  NewsCell.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/21.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var newsImageView: UIView = {
        let view = UIView()
        view.layer.contentsGravity = kCAGravityResizeAspectFill
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var flagImageView: UIView = {
        let view = UIView()
        view.layer.contentsGravity = kCAGravityResizeAspectFill
        view.layer.masksToBounds = true
        view.layer.contents = #imageLiteral(resourceName: "Home_Morepic").cgImage
        view.isHidden = true
        view.sizeToFit()
        return view
    }()
    
    fileprivate lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = kXBBorderColor
        return view
    }()
    
    var newsModel: NewsModel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configViews()
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func configViews() {
        addSubview(titleLabel)
        addSubview(newsImageView)
        addSubview(flagImageView)
        addSubview(bottomLine)
    }
    
    fileprivate func setLayout() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(newsImageView.snp.left).offset(-12)
            make.top.equalTo(12)
            make.bottom.lessThanOrEqualTo(-12)
        }
        
        newsImageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel)
            make.bottom.equalTo(-12)
            make.right.equalTo(-12)
            make.width.equalTo(86)
        }
        
        flagImageView.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(newsImageView)
            make.size.equalTo(CGSize(width: 32, height: 14))
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalTo(newsImageView)
            make.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    fileprivate func updateLayout() {
        let imageWidth: CGFloat = (newsModel?.imageUrl.isEmpty ?? false) ? 0 : 86
        newsImageView.snp.updateConstraints { (make) in
            make.width.equalTo(imageWidth)
        }
    }
    
    func refreshViews(with newsModel: NewsModel) {
        self.newsModel = newsModel
        
        titleLabel.text = newsModel.title
        if newsModel.isRead {
            titleLabel.textColor = UIColor.gray
        } else {
            titleLabel.textColor = UIColor.black
        }
        
        newsImageView.layer.yy_setImage(with: URL(string: newsModel.imageUrl ), placeholder: #imageLiteral(resourceName: "Home_Image"))
        
        flagImageView.isHidden = !newsModel.isMultipic
        
        updateLayout()
    }
}
