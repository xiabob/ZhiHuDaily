//
//  String+UIColor.swift
//  WebColor
//
//  Created by xiabob on 16/12/13.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import Foundation
import UIKit


fileprivate let colorsCache = NSCache<AnyObject, UIColor>()
fileprivate let hexRegex = try? NSRegularExpression(pattern: "[0-9A-Fa-f]{3,8}", options: [.caseInsensitive])


//MARK: - HEX
public extension String {
    //#000
    func shortRgbHexCodeColor() -> UIColor? {
        var color = colorsCache.object(forKey: self as AnyObject)
        if color != nil {return color}
        
        var hexCode: UInt32 = 0
        //scan hex int
        let scanner = Scanner(string: self)
        scanner.scanHexInt32(&hexCode)
        
        let divisor = CGFloat(15)
        let r = CGFloat(hexCode  >> 8)          / divisor
        let g = CGFloat((hexCode >> 4) & 0x0F)  / divisor
        let b = CGFloat(hexCode        & 0x00F) / divisor
        color = UIColor(red: r, green: g, blue: b, alpha: CGFloat(1))
        
        if color != nil {
            colorsCache.setObject(color!, forKey: self as AnyObject)
        }
        
        return color
    }
    
    //#000f
    func shortRgbaHexCodeColor() -> UIColor? {
        var color = colorsCache.object(forKey: self as AnyObject)
        if color != nil {return color}
        
        var hexCode: UInt32 = 0
        //scan hex int
        let scanner = Scanner(string: self)
        scanner.scanHexInt32(&hexCode)
        
        let divisor = CGFloat(15)
        let r = CGFloat(hexCode  >> 12)           / divisor
        let g = CGFloat((hexCode >>  8) & 0x0F)   / divisor
        let b = CGFloat((hexCode >>  4) & 0x00F)  / divisor
        let a = CGFloat(hexCode         & 0x000F) / divisor
        color = UIColor(red: r, green: g, blue: b, alpha: a)
        
        if color != nil {
            colorsCache.setObject(color!, forKey: self as AnyObject)
        }
        
        return color
    }
    
    //FF0000
    func rgbHexCodeColor() -> UIColor? {
        var color = colorsCache.object(forKey: self as AnyObject)
        if color != nil {
            return color
        }
        
        var hexCode: UInt32 = 0
        //scan hex int
        let scanner = Scanner(string: self)
        scanner.scanHexInt32(&hexCode)
        
        let divisor = CGFloat(255)
        let r = CGFloat(hexCode  >> 16)             / divisor
        let g = CGFloat((hexCode >>  8) & 0x00FF)   / divisor
        let b = CGFloat(hexCode         & 0x0000FF) / divisor
        color = UIColor(red: r, green: g, blue: b, alpha: CGFloat(1))
        
        if color != nil {
            colorsCache.setObject(color!, forKey: self as AnyObject)
        }
        
        return color
    }
    
    //FF000000
    func rgbaHexCodeColor() -> UIColor? {
        var color = colorsCache.object(forKey: self as AnyObject)
        if color != nil {
            return color
        }
        
        var hexCode: UInt32 = 0
        //scan hex int
        let scanner = Scanner(string: self)
        scanner.scanHexInt32(&hexCode)
        
        let divisor = CGFloat(255)
        let r = CGFloat(hexCode  >> 24)               / divisor
        let g = CGFloat((hexCode >> 16) & 0x00FF)     / divisor
        let b = CGFloat((hexCode >>  8) & 0x0000FF)   / divisor
        let a = CGFloat(hexCode         & 0x000000FF) / divisor
        color = UIColor(red: r, green: g, blue: b, alpha: a)
        
        if color != nil {
            colorsCache.setObject(color!, forKey: self as AnyObject)
        }
        
        return color
    }
    
    
    public func hexColor() -> UIColor? {
        var color = colorsCache.object(forKey: self as AnyObject)
        if color != nil {
            return color
        }
        
        var colorCode = self
        if colorCode.hasPrefix("#") {
            colorCode = substring(from: index(startIndex, offsetBy: 1))
        }
        
        let length = colorCode.utf8.count
        if length == 3 { //#000
            color = colorCode.shortRgbHexCodeColor()
        } else if length == 4 { //#0000
            color = colorCode.shortRgbaHexCodeColor()
        } else if length == 6 { //#000000
            color = colorCode.rgbHexCodeColor()
        } else if length == 8 { //#00000000
            color = colorCode.rgbaHexCodeColor()
        }
        
        return color
    }
}


//MARK: - RGB
public extension String {
    
    //rgb(255, 160, 122)
    func rgbCodeColor() -> UIColor? {
        var color = colorsCache.object(forKey: self as AnyObject)
        if color != nil {
            return color
        }
        
        if hasPrefix("rgb(") {
            let colorCode = trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "rgb(", with: "").replacingOccurrences(of: ")", with: "")
            let rgb = colorCode.components(separatedBy: ",")
            if rgb.count == 3 {
                let r = uint(rgb[0].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                let g = uint(rgb[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                let b = uint(rgb[2].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                
                color = UIColor(red: CGFloat(r)/CGFloat(255), green: CGFloat(g)/CGFloat(255), blue: CGFloat(b)/CGFloat(255), alpha: CGFloat(1))
            }
            
        }
        
        if color != nil {
            colorsCache.setObject(color!, forKey: self as AnyObject)
        }
        
        return color
    }
    
    //rgba(255, 0, 0, 0.5)
    func rgbaCodeColor() -> UIColor? {
        var color = colorsCache.object(forKey: self as AnyObject)
        if color != nil {
            return color
        }
        
        if hasPrefix("rgba(") {
            let colorCode = trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "rgba(", with: "").replacingOccurrences(of: ")", with: "")
            let rgba = colorCode.components(separatedBy: ",")
            if rgba.count == 4 {
                let r = uint(rgba[0].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                let g = uint(rgba[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                let b = uint(rgba[2].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                let a = Float(rgba[3].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
                
                color = UIColor(red: CGFloat(r)/CGFloat(255), green: CGFloat(g)/CGFloat(255), blue: CGFloat(b)/CGFloat(255), alpha: CGFloat(a))
            }
            
        }
        
        if color != nil {
            colorsCache.setObject(color!, forKey: self as AnyObject)
        }
        
        return color
    }
    
    public func rgbColor() -> UIColor? {
        var color = colorsCache.object(forKey: self as AnyObject)
        if color != nil {
            return color
        }
        
        if hasPrefix("rgb(") {
            color = rgbCodeColor()
        } else if hasPrefix("rgba(") {
            color = rgbaCodeColor()
        }
        
        return color
    }
    
}


    
//MARK: - HSL
public extension String {
    //https://en.wikipedia.org/wiki/HSL_and_HSV
    
    //hsl(120, 100%, 50%)
    func hslCodeColor() -> UIColor? {
        var color = colorsCache.object(forKey: self as AnyObject)
        if color != nil {
            return color
        }
        
        if hasPrefix("hsl(") {
            let colorCode = trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "hsl(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "%", with: "")
            let hsl = colorCode.components(separatedBy: ",")
            if hsl.count == 3 {
                let h = Float(hsl[0].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0 //0-360
                let s = Float(hsl[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0 //0-100
                let l = Float(hsl[2].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0 //0-100
                color = UIColor(h: CGFloat(h)/CGFloat(360), s: CGFloat(s)/CGFloat(100), l: CGFloat(l)/CGFloat(100))
            }
        }
        
        if color != nil {
            colorsCache.setObject(color!, forKey: self as AnyObject)
        }
        
        return color
    }
    
    //hsla(120, 100%, 50%, 1)
    func hslaCodeColor() -> UIColor? {
        var color = colorsCache.object(forKey: self as AnyObject)
        if color != nil {
            return color
        }
        
        if hasPrefix("hsla(") {
            let colorCode = trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "hsla(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "%", with: "")
            let hsla = colorCode.components(separatedBy: ",")
            if hsla.count == 4 {
                let h = Float(hsla[0].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0 //0-360
                let s = Float(hsla[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0 //0-100
                let l = Float(hsla[2].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0 //0-100
                let a = Float(hsla[3].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0 //0-1
                color = UIColor(h: CGFloat(h)/CGFloat(360), s: CGFloat(s)/CGFloat(100), l: CGFloat(l)/CGFloat(100), a: CGFloat(a))
            }
        }
        
        if color != nil {
            colorsCache.setObject(color!, forKey: self as AnyObject)
        }
        
        return color
    }
    
    public func hslColor() -> UIColor? {
        var color = colorsCache.object(forKey: self as AnyObject)
        if color != nil {
            return color
        }
        
        if hasPrefix("hsl(") {
            color = hslCodeColor()
        } else if hasPrefix("hsla(") {
            color = hslaCodeColor()
        }
        
        return color
    }
}


//MARK: - HSB/HSV
public extension String {
    //https://en.wikipedia.org/wiki/HSL_and_HSV
    
    func hsbCodeColor() -> UIColor? {
        var color = colorsCache.object(forKey: self as AnyObject)
        if color != nil {
            return color
        }
        
        if hasPrefix("hsb(") {
            let colorCode = trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "hsb(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "%", with: "")
            let hsb = colorCode.components(separatedBy: ",")
            if hsb.count == 3 {
                let h = Float(hsb[0].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0 //0-360
                let s = Float(hsb[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0 //0-100
                let b = Float(hsb[2].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0 //0-100
                color = UIColor(hue: CGFloat(h)/CGFloat(360), saturation: CGFloat(s)/CGFloat(100), brightness: CGFloat(b)/CGFloat(100), alpha: 1)
            }
        }
        
        if color != nil {
            colorsCache.setObject(color!, forKey: self as AnyObject)
        }
        
        return color
    }
    
    func hsbaCodeColor() -> UIColor? {
        var color = colorsCache.object(forKey: self as AnyObject)
        if color != nil {
            return color
        }
        
        if hasPrefix("hsba(") {
            let colorCode = trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "hsba(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "%", with: "")
            let hsba = colorCode.components(separatedBy: ",")
            if hsba.count == 4 {
                let h = Float(hsba[0].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0 //0-360
                let s = Float(hsba[1].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0 //0-100
                let b = Float(hsba[2].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0 //0-100
                let a = Float(hsba[3].trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0 //0-1
                color = UIColor(hue: CGFloat(h)/CGFloat(360), saturation: CGFloat(s)/CGFloat(100), brightness: CGFloat(b)/CGFloat(100), alpha: CGFloat(a))
            }
        }
        
        if color != nil {
            colorsCache.setObject(color!, forKey: self as AnyObject)
        }
        
        return color
    }
    
    public func hsbColor() -> UIColor? {
        var color = colorsCache.object(forKey: self as AnyObject)
        if color != nil {
            return color
        }
        
        if hasPrefix("hsb(") {
            color = hsbCodeColor()
        } else if hasPrefix("hsba(") {
            color = hsbaCodeColor()
        }
        
        return color
    }
    
    public func hsvColor() -> UIColor? {
        let color = colorsCache.object(forKey: self as AnyObject)
        if color != nil {
            return color
        }
        
        return replacingOccurrences(of: "hsv", with: "hsb").hsbColor()
    }
}

    
//MARK: - Named
public extension String {
    
    public func namedColor() -> UIColor? {
        //from cache
        var color = colorsCache.object(forKey: self as AnyObject)
        if color != nil {
            return color
        }
        
        //from web colors
        let colorCode = webColorsDic[lowercased()]
        if colorCode != nil {color = colorCode!.rgbHexCodeColor()}
        if color != nil {return color}

        //from self
        var sel = NSSelectorFromString(self)
        if UIColor.responds(to: sel) {
            color = UIColor.perform(sel).takeRetainedValue() as? UIColor
        } else {
            sel = NSSelectorFromString(self + "Color")
            if UIColor.responds(to: sel) {
                color = UIColor.perform(sel).takeRetainedValue() as? UIColor
            }
        }
        
        if color != nil {
            colorsCache.setObject(color!, forKey: self as AnyObject)
        }
        
        return color
    }
}


//MARK: - API
public extension String {
    
    public func color() -> UIColor? {
        var color = colorsCache.object(forKey: self as AnyObject)
        if color != nil {return color}
        
        if hasPrefix("#") {
            color = hexColor()
        } else if hasPrefix("rgb") {
            color = rgbColor()
        } else if hasPrefix("hsl") {
            color = hslColor()
        } else if hasPrefix("hsb") {
            color = hsbColor()
        } else if hasPrefix("hsv") {
            color = hsvColor()
        } else {
            let firstMatch = hexRegex?.rangeOfFirstMatch(in: self, options: [], range: NSRange(location: 0, length: utf8.count))
            if firstMatch?.location == 0 && firstMatch?.length == utf8.count {
                color = hexColor()
            } else {
                color = namedColor()
            }
        }
        
        if color != nil {
            colorsCache.setObject(color!, forKey: self as AnyObject)
        }
        
        return color
    }
}

public extension UIColor {
    
    public convenience init(_ webColor: String, defaultColor: UIColor = .clear) {
        let color = webColor.color()
        if let color = color {
            self.init(cgColor: color.cgColor)
        } else {
            self.init(cgColor: defaultColor.cgColor)
        }
    }
}


//MARK: - UIColor extension
extension UIColor {
    ///hsl color, h、s、l、a都是0-1的浮点数
    fileprivate convenience init(h: CGFloat, s: CGFloat, l: CGFloat, a: CGFloat = 1) {
        //https://en.wikipedia.org/wiki/HSL_and_HSV
        let c = (1 - abs(2*l - 1)) * s
        let h1 = h*6
        let x = c * CGFloat(1 - abs(fmodf(Float(h1), 2) - 1)) //浮点数去掉了%操作，https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20151214/003410.html
        
        var r1: CGFloat, g1: CGFloat, b1: CGFloat
        if h1>=0 && h1<1 {
            r1 = c; g1 = x; b1 = 0
        } else if h1>=1 && h1<2 {
            r1 = x; g1 = c; b1 = 0
        } else if h1>=2 && h1<3 {
            r1 = 0; g1 = c; b1 = x
        } else if h1>=3 && h1<4 {
            r1 = 0; g1 = x; b1 = c
        } else if h1>=4 && h1<5 {
            r1 = x; g1 = 0; b1 = c
        } else if h1>=5 && h1<6 {
            r1 = c; g1 = 0; b1 = x
        } else {
            r1 = 0; g1 = 0; b1 = 0
        }
        
        let m = l - c/2
        self.init(red: r1+m, green: g1+m, blue: b1+m, alpha: a)
    }
}
