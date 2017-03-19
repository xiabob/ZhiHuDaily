//
//  XBCycleViewImageModel.swift
//  XBCycleView
//
//  Created by xiabob on 16/6/13.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit

open class XBCycleViewImageModel: NSObject {
    ///图片对应的标题
    var title: String?
    
    ///图片的描述
    var describe: String?
    
    ///图片对应的链接
    var imageUrlString: String?
    
    ///本地要展示的图片
    var localImage: UIImage?
    
    override init() {
        super.init()
    }
    
    init (title: String?, describe: String?, imageUrlString: String?, localImage: UIImage?) {
        self.title = title
        self.describe = describe
        self.imageUrlString = imageUrlString
        self.localImage = localImage
    }
    
    init (imageUrlString: String?, localImage: UIImage?) {
        self.imageUrlString = imageUrlString
        self.localImage = localImage
    }
    
    init(imageUrlString: String?) {
        self.imageUrlString = imageUrlString
    }
    
    init(localImage: UIImage?) {
        self.localImage = localImage
    }
}
