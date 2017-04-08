//
//  MenuVC.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/17.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {
    
    fileprivate lazy var loginView: MenuLoginView = {
        let view = MenuLoginView(frame: .zero)
        return view
    }()
    
    fileprivate lazy var topBarView: MenuTopBarView = {
        let view = MenuTopBarView(frame: .zero)
        return view
    }()
    
    fileprivate lazy var bottomBarView: MenuBottomBarView = {
        let view = MenuBottomBarView(frame: .zero)
        return view
    }()
    
    //MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        commonInit()
        configViews()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        loginView.frame = CGRect(x: 0, y: 25, width: view.xb_width, height: 40)
        topBarView.frame = CGRect(x: 0, y: loginView.xb_bottom+10, width: view.xb_width, height: 50)
        bottomBarView.frame = CGRect(x: 0, y: view.xb_bottom-60, width: view.xb_width, height: 60)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - config
    
    fileprivate func commonInit() {
        view.backgroundColor = kMenuBackgroundColor
    }
    
    fileprivate func configViews() {
        view.addSubview(loginView)
        view.addSubview(topBarView)
        view.addSubview(bottomBarView)
    }
}
