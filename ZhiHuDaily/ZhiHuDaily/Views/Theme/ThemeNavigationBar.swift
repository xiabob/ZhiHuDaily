//
//  ThemeNavigationBar.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/4/11.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

protocol ThemeNavigationControllerDelegate: NSObjectProtocol {
    func navigationBar(_ navigationBar: ThemeNavigationBar, beginRefresh refreshHeader: CycleRefreshHeaderView)
    func navigationBar(_ navigationBar: ThemeNavigationBar, didClickBackButton button: UIButton)
    func navigationBar(_ navigationBar: ThemeNavigationBar, didClickRightButton button: UIButton)
}

class ThemeNavigationBar: UIView {
    
    fileprivate lazy var backButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Field_Back"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "Field_Back"), for: .selected)
        button.addTarget(self, action: #selector(clickBackButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.text = ""
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var rightButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Field_Follow"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "Field_Follow"), for: .selected)
                button.addTarget(self, action: #selector(clickRightButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var cycleRefreshHeader: CycleRefreshHeaderView = { [unowned self] in
        let header:CycleRefreshHeaderView = CycleRefreshHeaderView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        header.refreshBlock = { [weak self] in
            guard let wself = self else {return}
            wself.delegate?.navigationBar(wself, beginRefresh: header)
        }
        return header
    }()
    
    var delegate: ThemeNavigationControllerDelegate?
    
    //MARK: - init
    
    init(frame: CGRect, scrollView: UIScrollView) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        cycleRefreshHeader.scrollView = scrollView
        
        configViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if newSuperview == nil {
            cycleRefreshHeader.removeObserver()
        }
    }
    
    //MARK: - config View
    
    fileprivate func configViews() {
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(rightButton)
        addSubview(cycleRefreshHeader)
    }
    
    override func layoutSubviews() {
        backButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self).offset(10)
            make.left.equalTo(8)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(backButton)
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.right.equalTo(-8)
            make.centerY.equalTo(backButton)
        }
        
        cycleRefreshHeader.snp.makeConstraints { (make) in
            make.right.equalTo(titleLabel.snp.left).offset(-6)
            make.centerY.equalTo(backButton)
            make.size.equalTo(cycleRefreshHeader.xb_size)
        }
    }
    
    func refreshViews(with title: String) {
        titleLabel.text = title
    }
    
    //MARK: - button action
    
    @objc fileprivate func clickBackButton() {
        delegate?.navigationBar(self, didClickBackButton: backButton)
    }
    
    @objc fileprivate func clickRightButton() {
        delegate?.navigationBar(self, didClickRightButton: rightButton)
    }

}
