//
//  ThemeNavigationController.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/4/11.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

class ThemeNavigationController: UINavigationController {
    
    var themeId = 0 {
        didSet {
            if let themeVC = topViewController as? ThemeVC {
                themeVC.themeId = themeId
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
