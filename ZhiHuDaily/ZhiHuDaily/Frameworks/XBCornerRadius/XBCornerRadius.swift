//
//  XBCornerRadius.swift
//  XBCornerRadiusDemo
//
//  Created by xiabob on 16/7/2.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit

public extension UIView {
    public func xb_setCornerRadius(_ radius: CGFloat) {
        xb_setCornerRadius(radius, backgroundColor: backgroundColor ?? .white)
    }
    
    public func xb_setCornerRadius(_ radius: CGFloat, backgroundColor: UIColor) {
        xb_setCornerRadius(radius, backgroundColor: backgroundColor, corners: .allCorners)
    }
    
    public func xb_setCornerRadius(_ radius: CGFloat, backgroundColor: UIColor, corners: UIRectCorner) {
        xb_setCornerRadii(CGSize(width: radius, height: radius), backgroundColor: backgroundColor, corners: corners, borderColor: nil, borderWidth: nil)
    }
    
    public func xb_setCornerRadii(_ cornerRadii: CGSize, backgroundColor: UIColor, corners: UIRectCorner, borderColor: UIColor?, borderWidth: CGFloat?) {
        if self is UIImageView {
            //only scaleAspectFill not cause offscreen-renderd, do this for better display
            contentMode = .scaleAspectFill
            clipsToBounds = true
        }
        
        layer.xb_roundedCorner(cornerRadii, cornerColor: backgroundColor, corners: corners, borderColor: borderColor, borderWidth: borderWidth)
    }
}


public extension CALayer {
    public func xb_roundedCorner(_ cornerRadii: CGSize, cornerColor: UIColor, corners: UIRectCorner, borderColor: UIColor?, borderWidth: CGFloat?) {
        let key = "Identifier_\(cornerRadii)_\(cornerColor)_\(corners)_\(borderColor)_\(borderWidth)"
        if key == _cornerLayerIdentifier {
            //无需重复设置
            return
        } else {
            _cornerLayerIdentifier = key
        }
        
        //remove exit layer
        for layer in sublayers ?? [] {
            if layer is _RoundedCornerLayer {
                layer.removeFromSuperlayer()
                break;
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        //draw round corner by using eo rule
        context.setLineWidth(0)
        cornerColor.setFill()
        
        //outer rect path
        let rectPath = UIBezierPath(rect: bounds)
        //inner round path
        let roundPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        rectPath.append(roundPath)
        context.addPath(rectPath.cgPath)
        
        //set even-odd fill rule
        context.__eoFillPath()
        
        //set border
        if let borderColor = borderColor, let borderWidth = borderWidth  {
            borderColor.setFill()
            let borderOutterPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
            let borderInnerPath = UIBezierPath(roundedRect: bounds.insetBy(dx: borderWidth, dy: borderWidth), byRoundingCorners: corners, cornerRadii: cornerRadii)
            borderOutterPath.append(borderInnerPath)
            context.addPath(borderOutterPath.cgPath)
            context.__eoFillPath()
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //直接使用shapelayer本身绘制没有使用图片性能高效，滑动不流畅(??)
        let subLayer = _RoundedCornerLayer()
        subLayer.frame = bounds
        subLayer.isOpaque = true
        subLayer.contents = image?.cgImage
        self.addSublayer(subLayer)
    }
    

    private struct XBAssociatedKeys {
        static var cornerLayerIdentifierKey = "xb_cornerLayerIdentifierKey"
    }
    
    private var _cornerLayerIdentifier: String? {
        get {
            return objc_getAssociatedObject(self, &XBAssociatedKeys.cornerLayerIdentifierKey) as? String
        }
        
        set {
            objc_setAssociatedObject(self, &XBAssociatedKeys.cornerLayerIdentifierKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    
}



//MARK: - _RoundedCornerLayer
class _RoundedCornerLayer: CALayer {}
