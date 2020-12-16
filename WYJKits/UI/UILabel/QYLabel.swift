/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import Foundation
import UIKit

public extension UILabel {
    
    /// 改变字间距
    ///
    /// - Parameter space: space
    func yi_wordSpace(_ space: Float) {
        let labelText = text
        let attStr = NSMutableAttributedString.init(string: labelText!)
        attStr.addAttribute(NSAttributedString.Key.kern, value: (space), range: NSMakeRange(0, (labelText?.count)!))
        attStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: NSMutableParagraphStyle.init(), range: NSMakeRange(0, (labelText?.count)!))
        attributedText = attStr
        sizeToFit()
    }
    
    /// 改变行间距
    ///
    /// - Parameter space: space
    func yi_lineSpace(_ space: Float) {
        let labelText = text
        let attStr = NSMutableAttributedString.init(string: labelText!)
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = CGFloat(space)
        attStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, (labelText?.count)!))
        attributedText = attStr
        sizeToFit()
    }
    
    
    /// 改变行间距和字间距
    ///
    /// - Parameters:
    ///   - lineSpace: 行间距
    ///   - wordSpace: 字间距
    func yi_lineSpaceWithWordSpace(_ lineSpace:Float,_ wordSpace:Float) {
        let labelText = text
        let attStr = NSMutableAttributedString.init(string: labelText!)
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = CGFloat(lineSpace)
        attStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, (labelText?.count)!))
        attStr.addAttribute(NSAttributedString.Key.kern, value: (wordSpace), range: NSMakeRange(0, (labelText?.count)!))
        attributedText = attStr
        sizeToFit()
    }
}

 
//MARK: -- 事件扩展 --
public extension UILabel {
    struct QYRunTimeKey {
        //复制文本信息
        static let isCopy = UnsafeRawPointer.init(bitPattern: "isCopy".hashValue)
        
    }
    ///开启长按复制
    var yi_isCopy: Bool {
        set {
            objc_setAssociatedObject(self, QYRunTimeKey.isCopy!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            //添加长按手势
            isUserInteractionEnabled = true
            let LongPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressCopyEvent))
            addGestureRecognizer(LongPress)
        }
        get {
            return  objc_getAssociatedObject(self, QYRunTimeKey.isCopy!) as? Bool ?? false
        }
    }
    
    
    @objc func longPressCopyEvent(){
        // 让其成为响应者
        becomeFirstResponder()
        // 拿出菜单控制器单例
        let menu = UIMenuController.shared
        // 创建一个复制的item
        let copy = UIMenuItem(title: "copy", action: #selector(copyText))
        // 将复制的item交给菜单控制器（菜单控制器其实可以接受多个操作）
        menu.menuItems = [copy]
        // 设置菜单控制器的点击区域为这个控件的bounds
        menu.setTargetRect(bounds, in: self)
        // 显示菜单控制器，默认是不可见状态
        menu.setMenuVisible(true, animated: true)
    }
    
    @objc func copyText() {
        if text != nil {
            UIPasteboard.general.string = text
        }
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(copyText) {
            return true
        } else {
            return false
        }
    }
    
    /// 拥有成为响应者的能力
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
}

//MARK: --- 初始化
public extension UILabel {
    ///渐变色本文
    static func yi_initGradient(_ frame: CGRect) -> QYGradientLabel {
        let label = QYGradientLabel.shared
        label.frame = frame
        return label
    }
    static func yi_init(frame: CGRect,text: String,textColor: UIColor? = nil,font: UIFont? = nil) -> UILabel {
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
//MARK: --- 功能
public extension UILabel {

    
}
