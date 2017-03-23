//
//  NewsDetailBottomToolBar.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/23.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

protocol NewsDetailBottomToolBarDelegate: NSObjectProtocol {
    func bottomToolBar(_ toolBar: NewsDetailBottomToolBar, didClickBackButton button: UIButton)
    func bottomToolBar(_ toolBar: NewsDetailBottomToolBar, didClickNextButton button: UIButton)
    func bottomToolBar(_ toolBar: NewsDetailBottomToolBar, didClickVoteButton button: UIButton)
    func bottomToolBar(_ toolBar: NewsDetailBottomToolBar, didClickShareButton button: UIButton)
    func bottomToolBar(_ toolBar: NewsDetailBottomToolBar, didClickCommentButton button: UIButton)
}

class NewsDetailBottomToolBar: UIView {
    
    fileprivate lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "News_Navigation_Arrow"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "News_Navigation_Arrow_Highlight"), for: .highlighted)
        button.addTarget(self, action: #selector(onBackButtonClicked), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "News_Navigation_Next"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "News_Navigation_Next_Highlight"), for: .highlighted)
        button.setImage(#imageLiteral(resourceName: "News_Navigation_Unnext"), for: .disabled)
        button.addTarget(self, action: #selector(onNextButtonClicked), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var voteButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "News_Navigation_Vote"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "News_Navigation_Vote"), for: .highlighted)
        button.addTarget(self, action: #selector(onVoteButtonClicked), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var voteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = UIColor.gray
        label.textAlignment = .left
        label.text = ""
        return label
    }()
    
    fileprivate lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "News_Navigation_Share"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "News_Navigation_Share_Highlight"), for: .highlighted)
        button.addTarget(self, action: #selector(onShareButtonClicked), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "News_Navigation_Comment"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "News_Navigation_Comment_Highlight"), for: .highlighted)
        button.addTarget(self, action: #selector(onCommentButtonClicked), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
    
    weak var delegate: NewsDetailBottomToolBarDelegate?
    var extraModel: NewsExtraModel?
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - config views
    
    fileprivate func configViews() {
        backgroundColor = UIColor.white
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: -kXBBorderWidth)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        layer.shadowRadius = kXBBorderWidth
        
        let buttonWidth = kScreenWidth / 5
        
        backButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: xb_height)
        addSubview(backButton)
        
        nextButton.frame = CGRect(x: backButton.xb_right, y: 0, width: buttonWidth, height: xb_height)
        addSubview(nextButton)
        
        voteButton.frame = CGRect(x: nextButton.xb_right, y: 0, width: buttonWidth, height: xb_height)
        addSubview(voteButton)
        voteLabel.frame = CGRect(x: voteButton.xb_width/2+6, y: 10, width: 40, height: 12)
        voteButton.addSubview(voteLabel)
        
        shareButton.frame = CGRect(x: voteButton.xb_right, y: 0, width: buttonWidth, height: xb_height)
        addSubview(shareButton)
        
        commentButton.frame = CGRect(x: shareButton.xb_right, y: 0, width: buttonWidth, height: xb_height)
        addSubview(commentButton)
        commentLabel.frame = CGRect(x: commentButton.xb_width/2, y: 10, width: 20, height: 12)
        commentButton.addSubview(commentLabel)
    }
    
    func refreshViews(with model: NewsExtraModel?, andNewsPosition position: NewsPositionInNewsList) {
        extraModel = model
        if position == .last || position == .alone {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        let voteNumber = extraModel?.voteNumber ?? 0
        voteLabel.text = voteNumber > 0 ? "\(voteNumber)" : ""
        commentLabel.text = "\(extraModel?.allCommentNumber ?? 0)"
    }
    
    //MARK: - action
    
    @objc fileprivate func onBackButtonClicked() {
        delegate?.bottomToolBar(self, didClickBackButton: backButton)
    }
    
    @objc fileprivate func onNextButtonClicked() {
        
        delegate?.bottomToolBar(self, didClickNextButton: nextButton)
    }
    
    @objc fileprivate func onVoteButtonClicked() {
        delegate?.bottomToolBar(self, didClickVoteButton: voteButton)
    }
    
    @objc fileprivate func onShareButtonClicked() {
        delegate?.bottomToolBar(self, didClickShareButton: shareButton)
    }
    
    @objc fileprivate func onCommentButtonClicked() {
        delegate?.bottomToolBar(self, didClickCommentButton: commentButton)
    }
}
