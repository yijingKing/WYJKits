/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import Foundation
import UIKit
// MARK:--- 基本的扩展
public extension WYJProtocol where T: UILabel {
    
    /// 改变字间距
    ///
    /// - Parameter space: space
    @discardableResult
    func wordSpace(_ space: Float) -> WYJProtocol {
        let labelText = obj.text
        let attStr = NSMutableAttributedString.init(string: labelText!)
        attStr.addAttribute(NSAttributedString.Key.kern, value: (space), range: NSMakeRange(0, (labelText?.count)!))
        attStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: NSMutableParagraphStyle.init(), range: NSMakeRange(0, (labelText?.count)!))
        obj.attributedText = attStr
        obj.sizeToFit()
        return self
    }
    
    /// 改变行间距
    ///
    /// - Parameter space: space
    @discardableResult
    func lineSpace(_ space: Float) -> WYJProtocol {
        let labelText = obj.text
        let attStr = NSMutableAttributedString.init(string: labelText!)
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = CGFloat(space)
        attStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, (labelText?.count)!))
        obj.attributedText = attStr
        obj.sizeToFit()
        return self
    }
    
    
    /// 改变行间距和字间距
    ///
    /// - Parameters:
    ///   - lineSpace: 行间距
    ///   - wordSpace: 字间距
    @discardableResult
    func lineSpaceWithWordSpace(_ lineSpace:Float,_ wordSpace:Float) -> WYJProtocol  {
        let labelText = obj.text
        let attStr = NSMutableAttributedString.init(string: labelText!)
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = CGFloat(lineSpace)
        attStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, (labelText?.count)!))
        attStr.addAttribute(NSAttributedString.Key.kern, value: (wordSpace), range: NSMakeRange(0, (labelText?.count)!))
        obj.attributedText = attStr
        obj.sizeToFit()
        return self
    }
}

//MARK: --- 初始化
public extension UILabel {
    ///渐变色本文
    static func initGradient(_ frame: CGRect) -> WYJGradientLabel {
        let label = WYJGradientLabel.shared
        label.frame = frame
        return label
    }
    static func `init`(frame: CGRect,text: String,textColor: UIColor? = nil,font: UIFont? = nil) -> UILabel {
        let label = UILabel()
        label.frame = frame
        label.text = text
        if let color = textColor {
            label.textColor = color
        }
        if let fo = font {
            label.font = fo
        }
        return label
    }
}
