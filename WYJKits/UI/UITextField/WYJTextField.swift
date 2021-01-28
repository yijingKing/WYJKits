/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import Foundation
import UIKit

public extension WYJProtocol where T: UITextField {
    ///标识
    @discardableResult
    func identify(_ identify: String) -> WYJProtocol {
        obj.identify = identify
        return self
    }
    func identify() -> String {
        return obj.identify
    }
    ///最大字数
    @discardableResult
    func maxCount(_ count: Int) -> WYJProtocol {
        obj.maxCount = count
        return self
    }
    ///占位字颜色
    @discardableResult
    func placeholderColor(_ color: UIColor) -> WYJProtocol {
        obj.placeholderColor = color
        return self
    }
    /// 文本距离左右侧的距离
    ///
    /// - Parameters:
    ///   - leftWidth: 左侧距离
    ///   - rightWidth: 右侧距离
    @discardableResult
    func distanceSides(_ leftWidth:CGFloat,
                          _ rightWidth:CGFloat? = nil) -> WYJProtocol {
        //左侧view
        let leftV = UIView(frame: CGRect(x: 0, y: 0, width: leftWidth, height: 5))
        obj.leftViewMode = .always
        obj.leftView = leftV
        //右侧view
        let rightV = UIView(frame: CGRect(x: 0, y: 0, width: rightWidth!, height: 5))
        obj.rightViewMode = .always
        obj.rightView = rightV
        return self
    }
    /// 添加标题
    ///
    /// - Parameters:
    ///   - titleLabel: titleLabel
    ///   - titleWidth: titleWidth
    ///   - spacing: 距离左侧的距离
    @discardableResult
    func leftTitle(_ title: String,
                      _ titleWidth: CGFloat,
                      _ color: UIColor? = nil,
                      _ font: UIFont? = nil,
                      _ textAlignment: NSTextAlignment? = nil,
                      _ spacing: CGFloat? = nil) -> WYJProtocol {
        let label = UILabel()
        label.text = title
        label.textColor = color ?? obj.textColor
        label.font = font ?? obj.font
        label.textAlignment = textAlignment ?? obj.textAlignment
        let leftV = UIView(frame: CGRect(x: 0, y: 0, width: titleWidth, height: 30))
        label.frame = CGRect(x: spacing ?? 0, y: 0, width: titleWidth - (spacing ?? 0), height: 30)
        leftV.addSubview(label)
        obj.leftViewMode = .always
        obj.leftView = leftV
        return self
    }
    
    /// 添加左侧icon
    ///
    /// - Parameters:
    ///   - image: image
    ///   - size: icon的size
    ///   - padding: 距离文本距离
    @discardableResult
    func leftIcon(_ image: UIImage,
                  _ size:CGSize,
                  _ padding: CGFloat) -> WYJProtocol {
        let leftV = UIView(frame: CGRect(x: 0, y: 0, width: size.width + 2 * padding - 3, height: size.height))
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: size.width, height: size.height)
        leftV.addSubview(imageView)
        obj.leftViewMode = .always
        obj.leftView = leftV
        return self
    }
    
    /// 添加标题
    ///
    /// - Parameters:
    ///   - titleLabel: titleLabel
    ///   - titleWidth: titleWidth
    ///   - spacing: 距离右侧的距离
    @discardableResult
    func rightTitle(_ title: String,
                       _ titleWidth: CGFloat,
                       _ color: UIColor? = nil,
                       _ font: UIFont? = nil,
                       _ textAlignment: NSTextAlignment? = nil,
                       _ spacing: CGFloat? = nil) -> WYJProtocol {
        let label = UILabel()
        label.text = title
        label.textColor = color ?? obj.textColor
        label.font = font ?? obj.font
        label.textAlignment = textAlignment ?? obj.textAlignment
        let leftV = UIView(frame: CGRect(x: 0, y: 0, width: titleWidth, height: 30))
        label.frame = CGRect(x: spacing ?? 0, y: 0, width: titleWidth - (spacing ?? 0), height: 30)
        leftV.addSubview(label)
        obj.rightViewMode = .always
        obj.rightView = leftV
        return self
    }
    /// 添加右侧icon
    ///
    /// - Parameters:
    ///   - image: image
    ///   - size: size
    ///   - padding: padding
    @discardableResult
    func rightIcon(_ image: UIImage,size:CGSize,padding: CGFloat) -> WYJProtocol {
        let rightV = UIView(frame: CGRect(x: 0, y: 0, width: size.width + 2 * padding, height: size.height))
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: size.width, height: size.height)
        rightV.addSubview(imageView)
        obj.rightViewMode = .always
        obj.rightView = rightV
        return self
    }
    /// 方法
    /// - Parameters:
    ///   - event: 事件方式
    ///   - block: 回调
    @discardableResult
    func addTarget(_ event: UIControl.Event, _ block: ((UITextField)->())?) -> WYJProtocol {
        obj.allEvent(event, block)
        return self
    }
    
}

fileprivate extension UITextField {
    func allEvent(_ event: UIControl.Event, _ block: ((UITextField)->())?) {
        eventBlock = block
        self.addTarget(self, action: #selector(allEventSelects(_:)), for: event)
    }
}

private extension UITextField {
    @objc func allEventSelects(_ tf: UITextField) {
        eventBlock?(tf)
    }
    @objc func textFieldDidChange() {
        if self.maxCount > 0 {
            self.setMaxCount()
        }
    }
    ///设置最大值
    func setMaxCount() {
        let textCount = self.text?.count ?? 0
        if textCount > self.maxCount {
            self.text = String(self.text?.prefix(self.maxCount) ?? "")
        }
    }
}
fileprivate extension UITextField {
    private struct WYJRuntimeKey {
        static let maxCount = UnsafeRawPointer.init(bitPattern: "maxCount".hashValue)
        static let identify = UnsafeRawPointer.init(bitPattern: "identify".hashValue)
        static let placeholderColor = UnsafeRawPointer.init(bitPattern: "placeholderColor".hashValue)
        static let eventBlock = UnsafeRawPointer.init(bitPattern: "eventBlock".hashValue)
    }
    ///标识
    var identify: String {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.identify!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYJRuntimeKey.identify!) as! String
        }
    }
    ///最大字数
    var maxCount: Int {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.maxCount!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        get {
            return objc_getAssociatedObject(self, WYJRuntimeKey.maxCount!) as? Int ?? 0
        }
    }
    ///占位字颜色
    var placeholderColor: UIColor {
        set {
            guard let holder = self.placeholder, !holder.isEmpty else { return }
            self.attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: newValue])
            objc_setAssociatedObject(self, WYJRuntimeKey.placeholderColor!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYJRuntimeKey.placeholderColor!) as? UIColor ?? WYJ99Color
        }
    }
    ///代理回调
    var eventBlock: ((UITextField)->())? {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.eventBlock!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYJRuntimeKey.eventBlock!) as? (UITextField) -> ()
        }
    }
}
