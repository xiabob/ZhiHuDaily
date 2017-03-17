//
//  LaunchBottomView.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/17.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SnapKit

fileprivate let kLightWhiteColor = UIColor.white.withAlphaComponent(0.9)
fileprivate let kGrayWhiteColor = UIColor.white.withAlphaComponent(0.6)

class LaunchBottomView: UIView {

    fileprivate lazy var borderView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = kLightWhiteColor.cgColor
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = kLightWhiteColor
        label.text = "知乎日报"
        return label
    }()

    fileprivate lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = kGrayWhiteColor
        label.text = "每天三次，每次七分钟"
        return label
    }()
    
    
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
        backgroundColor = .clear
        addSubview(borderView)
        addSubview(titleLabel)
        addSubview(detailLabel)
    }
    
    override func layoutSubviews() {
        borderView.snp.makeConstraints { (make) in
            make.left.equalTo(24)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(borderView.snp.right).offset(12)
            make.top.equalTo(borderView)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(borderView)
        }
    }
    
    //MARK: - show
    
    func showBottomView(_ duration: TimeInterval, showCompleteBlock:(()->())?, animationCompleteBlock:(()->())?) {
        UIView.animate(withDuration: duration,
                       delay: 0.25,
                       options: .curveEaseIn,
                       animations: {
                        self.center.y -= self.bounds.height })
        { (finished) in
            showCompleteBlock?()
            self.showCircleLayer(animationCompleteBlock: animationCompleteBlock)
        }
    }
    
    fileprivate func showCircleLayer(animationCompleteBlock:(()->())?) {
        let layer = CAShapeLayer()
        let arcCenter = CGPoint(x: borderView.bounds.width*0.5, y: borderView.bounds.height*0.5)
        let path = UIBezierPath(arcCenter: arcCenter, radius: 12, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(0), clockwise: true)
        layer.lineWidth = 4
        layer.lineCap = kCALineCapRound
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = kLightWhiteColor.cgColor
        layer.path = path.cgPath
        borderView.layer.addSublayer(layer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.5
        layer.add(animation, forKey: "circleAnimation")
        
        dispatchMain(after: animation.duration) { 
            animationCompleteBlock?()
        }
    }
}
