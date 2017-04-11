//
//  NewsDetailLoadHeader.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/23.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

class NewsDetailLoadHeader: UIView {
    //keyPath
    fileprivate let kContentOffsetKeyPath = "contentOffset"
    
    var transformChangeOffset: CGFloat = 45
    private(set) weak var scrollView: UIScrollView? {
        didSet {
            removeObserver()
            if scrollView != nil {
                addObserver()
            }
        }
    }
    
    var loadComplete: (()->())?
    
    var positionFlag: NewsPositionInNewsList = .middle {
        didSet {
            switch positionFlag {
            case .first, .alone:
                titleLabel.text = "已经是第一篇了"
            case .middle, .last:
                titleLabel.text = "载入上一篇"
            }
            
            setNeedsLayout()
        }
    }
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        return label
    }()
    
    fileprivate lazy var arrowImageView: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "ZHAnswerViewTop"))
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver()
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        //handel UIScrollView
        if newSuperview != nil && !(newSuperview is UIScrollView) { return }
        
        removeObserver()
        if newSuperview != nil {
            scrollView = newSuperview as? UIScrollView
            addObserver()
        }
    }
    
    func resetArrowImageViewToGray() {
        arrowImageView.image = #imageLiteral(resourceName: "ZHAnswerViewTopDark")
        titleLabel.textColor = UIColor.gray
    }
    
    //MARK: - add or remove observer
    func addObserver() {
        scrollView?.addObserver(self, forKeyPath: kContentOffsetKeyPath, options: .new, context: nil)
    }
    
    func removeObserver() {
        //不使用scrollView，因为在deinit阶段，scrollView为nil
        superview?.removeObserver(self, forKeyPath: kContentOffsetKeyPath)
    }
    
    fileprivate func configViews() {
        addSubview(titleLabel)
        addSubview(arrowImageView)
    }
    
    override func layoutSubviews() {
        titleLabel.sizeToFit()
        if positionFlag == .first || positionFlag == .alone {
            arrowImageView.isHidden = true
            titleLabel.snp.remakeConstraints({ (make) in
                make.center.equalTo(self)
                make.size.equalTo(titleLabel.bounds.size)
            })
        } else {
            arrowImageView.isHidden = false
            arrowImageView.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(self)
                make.size.equalTo(arrowImageView.image!.size)
                make.right.equalTo(titleLabel.snp.left).offset(-4)
            })
            titleLabel.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(self)
                make.centerX.equalTo(self.snp.centerX).offset(arrowImageView.image!.size.width/2)
                make.size.equalTo(titleLabel.bounds.size)
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let ch = change else {return}
        guard let value = (ch[.newKey] as AnyObject?)?.cgPointValue else {return}
        let offsetY = value.y
        if offsetY <= -transformChangeOffset {
            UIView.animate(withDuration: 0.25, animations: {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            })
            
            let isDragging = scrollView?.isDragging ?? false
            if isDragging == false && (positionFlag == .middle || positionFlag == .last) {
                loadComplete?()
            }
        } else {
            UIView.animate(withDuration: 0.25, animations: { 
                self.arrowImageView.transform = CGAffineTransform.identity
            })
        }
    }
}
