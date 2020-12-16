/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import Foundation
import UIKit

public extension UITextField {
    /// 文本距离左右侧的距离
    ///
    /// - Parameters:
    ///   - leftWidth: 左侧距离
    ///   - rightWidth: 右侧距离
    func yi_distanceSides(_ leftWidth:CGFloat,
                          _ rightWidth:CGFloat? = nil)  {
        //左侧view
        let leftV = UIView(frame: CGRect(x: 0, y: 0, width: leftWidth, height: 5))
        self.leftViewMode = .always
        self.leftView = leftV
        //右侧view
        let rightV = UIView(frame: CGRect(x: 0, y: 0, width: rightWidth!, height: 5))
        self.rightViewMode = .always
        self.rightView = rightV
    }
    /// 添加标题
    ///
    /// - Parameters:
    ///   - titleLabel: titleLabel
    ///   - titleWidth: titleWidth
    ///   - spacing: 距离左侧的距离
    func yi_leftTitle(_ title: String,
                      _ titleWidth: CGFloat,
                      _ color: UIColor? = nil,
                      _ font: UIFont? = nil,
                      _ textAlignment: NSTextAlignment? = nil,
                      _ spacing: CGFloat? = nil)  {
        let label = UILabel()
        label.text = title
        label.textColor = color ?? self.textColor
        label.font = font ?? self.font
        label.textAlignment = textAlignment ?? self.textAlignment
        let leftV = UIView(frame: CGRect(x: 0, y: 0, width: titleWidth, height: 30))
        label.frame = CGRect(x: spacing ?? 0, y: 0, width: titleWidth - (spacing ?? 0), height: 30)
        leftV.addSubview(label)
        self.leftViewMode = .always
        self.leftView = leftV
    }
    
    /// 添加左侧icon
    ///
    /// - Parameters:
    ///   - image: image
    ///   - size: icon的size
    ///   - padding: 距离文本距离
    func yi_leftIcon(_ image: UIImage,_ size:CGSize,_ padding: CGFloat)  {
        let leftV = UIView(frame: CGRect(x: 0, y: 0, width: size.width + 2 * padding - 3, height: size.height))
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: size.width, height: size.height)
        leftV.addSubview(imageView)
        self.leftViewMode = .always
        self.leftView = leftV
    }
    
    /// 添加标题
    ///
    /// - Parameters:
    ///   - titleLabel: titleLabel
    ///   - titleWidth: titleWidth
    ///   - spacing: 距离右侧的距离
    func yi_rightTitle(_ title: String,
                       _ titleWidth: CGFloat,
                       _ color: UIColor? = nil,
                       _ font: UIFont? = nil,
                       _ textAlignment: NSTextAlignment? = nil,
                       _ spacing: CGFloat? = nil) {
        let label = UILabel()
        label.text = title
        label.textColor = color ?? self.textColor
        label.font = font ?? self.font
        label.textAlignment = textAlignment ?? self.textAlignment
        let leftV = UIView(frame: CGRect(x: 0, y: 0, width: titleWidth, height: 30))
        label.frame = CGRect(x: spacing ?? 0, y: 0, width: titleWidth - (spacing ?? 0), height: 30)
        leftV.addSubview(label)
        self.rightViewMode = .always
        self.rightView = leftV
    }
    /// 添加右侧icon
    ///
    /// - Parameters:
    ///   - image: image
    ///   - size: size
    ///   - padding: padding
    func yi_rightIcon(_ image: UIImage,size:CGSize,padding: CGFloat)  {
        let rightV = UIView(frame: CGRect(x: 0, y: 0, width: size.width + 2 * padding, height: size.height))
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: size.width, height: size.height)
        rightV.addSubview(imageView)
        self.rightViewMode = .always
        self.rightView = rightV
    }
}

private extension UITextField {
    @objc func textFieldDidChange() {
        if self.yi_maxCount > 0 {
            self.setMaxCount()
        }
    }
    ///设置最大值
    private func setMaxCount() {
        let textCount = self.text?.count ?? 0
        if textCount > self.yi_maxCount {
            self.text = String(self.text?.prefix(self.yi_maxCount) ?? "")
        }
    }
    
}
public extension UITextField {
    private struct QYRuntimeKey {
        static let maxCount = UnsafeRawPointer.init(bitPattern: "maxCount".hashValue)
        static let key = UnsafeRawPointer.init(bitPattern: "key".hashValue)
        static let placeholderColor = UnsafeRawPointer.init(bitPattern: "placeholderColor".hashValue)
    }
    ///标识
    var yi_key: String {
        set {
            objc_setAssociatedObject(self, QYRuntimeKey.key!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, QYRuntimeKey.key!) as! String
        }
    }
    ///最大字数
    var yi_maxCount: Int {
        set {
            objc_setAssociatedObject(self, QYRuntimeKey.maxCount!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        get {
            return objc_getAssociatedObject(self, QYRuntimeKey.maxCount!) as? Int ?? 0
        }
    }
    ///占位字颜色
    var yi_placeholderColor: UIColor {
        set {
            guard let holder = self.placeholder, !holder.isEmpty else { return }
            self.attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: newValue])
            objc_setAssociatedObject(self, QYRuntimeKey.placeholderColor!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, QYRuntimeKey.placeholderColor!) as? UIColor ?? QY99Color
        }
    }
}
