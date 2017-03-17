//
//  MainVC.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/17.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    fileprivate lazy var barView: MainNavigationBar = {
        let view = MainNavigationBar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 60))
        return view
    }()

    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    //MARK: - config views
    
    fileprivate func configViews() {
        view.addSubview(barView)
    }


}
