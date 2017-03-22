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
        label.textAlignment = .natural
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
    
    fileprivate func updateLayout() {
        let imageWidth: CGFloat = newsModel!.imageUrl.isEmpty  ? 0 : 86
        newsImageView.xb_top = 12
        newsImageView.xb_relativeBottom = xb_height - 12
        newsImageView.xb_width = imageWidth
        newsImageView.xb_right = xb_width - 12
        
        titleLabel.xb_top = newsImageView.xb_top
        titleLabel.xb_left = 12
        titleLabel.xb_relativeRight = newsImageView.xb_left - 12
        titleLabel.xb_height = titleLabel.text?.heightWithConstrainedWidth(titleLabel.xb_width, font: titleLabel.font) ?? 0
        
        flagImageView.xb_size = CGSize(width: 32, height: 14)
        flagImageView.xb_right = newsImageView.xb_right
        flagImageView.xb_bottom = newsImageView.xb_bottom
        
        bottomLine.xb_left = titleLabel.xb_left
        bottomLine.xb_relativeRight = newsImageView.xb_relativeRight
        bottomLine.xb_height = 0.5
        bottomLine.xb_bottom = xb_height
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
