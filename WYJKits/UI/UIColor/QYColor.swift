/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ 
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit

public let QY99Color = QYHexColor("#999999")
public let QY33Color = QYHexColor("#333333")
public let QY66Color = QYHexColor("#666666")
public let QYF5Color = QYHexColor("#F5F5F5")
public let QYEEColor = QYHexColor("#EEEEEE")

public func QYHexColorFormNum(_ rgbValue: Int,_ alpha: CGFloat = 1.0) -> (UIColor) {
    return UIColor.init(rgbValue, alpha)
}

public func QYHexColor(_ rgbValue: String,_ alpha: CGFloat = 1.0) -> (UIColor) {
    return UIColor.init(rgbValue, alpha)
}

//MARK: --- 自定义初始化
public extension UIColor {
    //MARK: --- rgb_Int
    ///rgb_Int
    convenience init (_ rgbValue: Int,_ alpha: CGFloat = 1.0) {
        self.init(red:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                  green:((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                  blue:((CGFloat)(rgbValue & 0xFF)) / 255.0,
                  alpha:alpha)
    }
    //MARK: --- r g b
    ///r g b
    convenience init(_ r: UInt32 ,_ g: UInt32 ,
                     _ b: UInt32 ,_ a: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: a)
    }
    //MARK: --- rgb_string
    ///rgb_string
    convenience init(_ hex: String,_ alpha: CGFloat = 1) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = alpha
        var hex:   String = hex
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    //MARK: --- 随机色
    ///随机色
    static func yi_random (_ randomAlpha: Bool = false) -> UIColor {
        let randomRed = CGFloat(arc4random() % 255) / 255.0
        let randomGreen = CGFloat(arc4random() % 255) / 255.0
        let randomBlue = CGFloat(arc4random() % 255) / 255.0
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1)
    }

}
//MARK: --- 换换
public extension UIColor {
    ///UIColor转化为16进制
    func yi_toHex() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        var rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8
        rgb = rgb | (Int)(blue * 255) << 0
        return String(format: "#%06x", rgb)
    }
    ///颜色生成image
    func yi_toImage(_ color : UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
