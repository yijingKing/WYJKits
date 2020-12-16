/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import Foundation
import UIKit

public extension UITextView {
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc private func textDidChange (_ tv: UITextView) {
        setNeedsDisplay()
    }
}

//MARK:   -------   重写系统方法 ----------
public extension UITextView {
    override func draw(_ rect: CGRect) {
        // 如果有文字,就直接返回,不需要画占位文字
        if hasText {
            return
        }
        
        // 属性
        let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: yi_placeholderColor,NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 16)]
        // 文字
        var rect1 = rect
        rect1.origin.x = 5
        rect1.origin.y = 8
        rect1.size.width = rect1.size.width - 2 * rect1.origin.x
        ((yi_placeholder ?? "") as NSString).draw(in: rect1, withAttributes: attrs)
    }
}

//MARK:   -------   属性扩展 ----------
public extension UITextView {
    private struct QYRuntimeKey {
        static let placeholderKey = UnsafeRawPointer.init(bitPattern: "placeholder".hashValue)
        static let placeholderColorKey = UnsafeRawPointer.init(bitPattern: "placeholderColor".hashValue)
    }
    //MARK: --- 占位字
    ///占位字
    var yi_placeholder: String? {
        set {
            objc_setAssociatedObject(self, QYRuntimeKey.placeholderKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            addNotification()
        }
        get {
            return objc_getAssociatedObject(self, QYRuntimeKey.placeholderKey!) as? String
        }
    }
    //MARK: --- 占位字颜色
    ///占位字颜色
    var yi_placeholderColor: UIColor {
        set {
            objc_setAssociatedObject(self, QYRuntimeKey.placeholderColorKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, QYRuntimeKey.placeholderColorKey!) as? UIColor ?? QY99Color
        }
    }
}
