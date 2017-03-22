//
//  ViewUtils.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/22.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import Toast_Swift

//see http://stackoverflow.com/questions/30450434/figure-out-size-of-uilabel-based-on-string-in-swift
extension String {
    ///线程安全的方法，用于计算UILabel的高度
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        //In iOS 7 and later, this method returns fractional sizes (in the size component of the returned CGRect); to use a returned size to size views, you must use raise its value to the nearest higher integer using the ceil function.
        return ceil(boundingBox.height)
    }
    
    ///线程安全的方法，用于计算UILabel的宽度
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        //In iOS 7 and later, this method returns fractional sizes (in the size component of the returned CGRect); to use a returned size to size views, you must use raise its value to the nearest higher integer using the ceil function.
        return ceil(boundingBox.width)
    }
}

extension NSAttributedString {
    ///线程安全的方法，用于计算UILabel的高度
    func heightWithConstrainedWidth(_ width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    ///线程安全的方法，用于计算UILabel的宽度
    func widthWithConstrainedHeight(_ height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}


extension UIView {
    func showToast(_ text: String) {
        self.makeToast(text, duration: TimeInterval(2), position: .center)
    }
    
    func showToast(_ text: String, duration: TimeInterval) {
        self.makeToast(text, duration: duration, position: .center)
    }
}
