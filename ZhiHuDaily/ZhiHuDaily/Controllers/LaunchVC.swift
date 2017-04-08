//
//  LaunchVC.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/17.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import YYWebImage

class LaunchVC: UIViewController {
    fileprivate lazy var launchImageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight-92))
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.alpha = 0
        return view
    }()
    
    fileprivate lazy var launchBottomView: LaunchBottomView = {
        let view = LaunchBottomView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height:92))
        return view
    }()
    
    fileprivate lazy var launchDS: LaunchDS = {
        let ds = LaunchDS()
        return ds;
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = kLaunchBackgroundColor
        view.addSubview(launchImageView)
        view.addSubview(launchBottomView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        launchBottomView.showBottomView(0.35, showCompleteBlock: {
            self.loadLaunchData()
        }) {
            dispatchMain(after: 1, completeBlock: {
                appDelegate.window?.rootViewController = appDelegate.drawerController
                appDelegate.drawerController.view.addSubview(self.view)
                UIView.animate(withDuration: 0.25, animations: { 
                    self.view.alpha = 0
                }, completion: { (finished) in
                    self.view.removeFromSuperview()
                })
                UIApplication.shared.setStatusBarHidden(false, with: .none)
            })
        }
    }
    
  
    //MARK: - Load
    
    fileprivate func loadLaunchData() {
        launchDS.loadDataFromLocal { [weak self](api) in
            guard let wself = self else {return}
            if wself.launchDS.errorCode.code == .success {
                wself.showLaunchImage(from: wself.launchDS.model)
            } else {
                wself.showDefaultImage()
            }
            
            wself.launchDS.loadData({ (api) in
                //预先下载图片
                guard let model = wself.launchDS.model else {return}
                guard let imageURL = URL(string: model.url) else {return}
                YYWebImageManager.shared().requestImage(with: imageURL, options: .allowInvalidSSLCertificates, progress: nil, transform: nil, completion: nil)
            })
        }
    }
    
    fileprivate func showLaunchImage(from model: LaunchModel?) {
        guard let model = model else {return showDefaultImage()}
        guard let imageURL = URL(string: model.url) else {return showDefaultImage()}
        let key = YYWebImageManager.shared().cacheKey(for: imageURL)
        if model.isValid == false || (YYWebImageManager.shared().cache?.diskCache.containsObject(forKey: key))! == false {
            return showDefaultImage()
        }
        
        launchImageView.yy_setImage(with: URL(string: model.url), options: .allowInvalidSSLCertificates)
        UIView.animate(withDuration: 0.35, animations: {
            self.launchImageView.alpha = 0.9
        })
    }
    
    fileprivate func showDefaultImage() {
        launchImageView.image = #imageLiteral(resourceName: "Splash_Image")
        UIView.animate(withDuration: 0.35, animations: {
            self.launchImageView.alpha = 0.9
        })
    }

    
    //MARK: - system
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
