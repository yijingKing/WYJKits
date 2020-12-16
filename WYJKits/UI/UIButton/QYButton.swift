/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import UIKit

//MARK: --- 属性
public extension UIButton {
    var yi_title: String? {
        get { return title(for: .normal) }
        set { setTitle(newValue, for: .normal) }
    }
    
    var yi_titleFont: UIFont? {
        get { return titleLabel?.font }
        set { titleLabel?.font = newValue }
    }
    
    var yi_attributedTitle: NSAttributedString? {
        get { return attributedTitle(for: .normal) }
        set { setAttributedTitle(newValue, for: .normal) }
    }
    
    var yi_titleColor: UIColor? {
        get { return titleColor(for: .normal) }
        set {
            setTitleColor(newValue, for: .normal)
            setTitleColor(newValue?.withAlphaComponent(0.5), for: .disabled)
            setTitleColor(newValue, for: .selected)
            if buttonType == .custom {
                setTitleColor(newValue?.withAlphaComponent(0.5), for: .highlighted)
            }
        }
    }
    var yi_selectedColor: UIColor? {
        get { return titleColor(for: .selected) }
        set {
            setTitleColor(newValue, for: .selected)
            setTitleColor(newValue?.withAlphaComponent(0.5), for: .disabled)
            setTitleColor(newValue, for: .selected)
            if buttonType == .custom {
                setTitleColor(newValue?.withAlphaComponent(0.5), for: .highlighted)
            }
        }
    }
    
    var yi_titleShadowColor: UIColor? {
        get { return titleShadowColor(for: .normal) }
        set {
            setTitleShadowColor(newValue, for: .normal)
            setTitleShadowColor(newValue?.withAlphaComponent(0.5), for: .disabled)
            setTitleShadowColor(newValue, for: .selected)
        }
    }
    
    var yi_image: UIImage? {
        get { return image(for: .normal) }
        set {
            setImage(newValue?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    var yi_selectedImage: UIImage? {
        get { return image(for: .selected) }
        set { setImage(newValue?.withRenderingMode(.alwaysOriginal), for: .selected) }
    }
    
    var yi_backgroundImage: UIImage? {
        get { return backgroundImage(for: .normal) }
        set {
            let image = newValue?.withRenderingMode(.alwaysOriginal)
            setBackgroundImage(image, for: .normal)
        }
    }
    
    var yi_selectedBackgroundImage: UIImage? {
        get { return backgroundImage(for: .selected) }
        set { setBackgroundImage(newValue?.withRenderingMode(.alwaysOriginal), for: .selected) }
    }
    
    var yi_disabledBackgroundImage: UIImage? {
        get { return backgroundImage(for: .disabled) }
        set { setBackgroundImage(newValue?.withRenderingMode(.alwaysOriginal), for: .disabled) }
    }
}

public enum QYButtonImagePosition: Int {
    case left       = 0x0
    case right      = 0x01
    case top        = 0x02
    case bottom     = 0x03
}

public extension UIButton {
    //MARK: --- 图片文本位置
    /// 图片文本位置
    /// - Parameters:
    ///   - type: 图片位置
    ///   - imageWidth: 图片大小
    ///   - space: 间距
    func yi_imagePosition(_ type: QYButtonImagePosition,_ space: CGFloat? = nil,_ imageW: CGFloat? = nil,_ imageH: CGFloat? = nil) {
        var image: UIImage?
        if imageW != 0 && imageH != 0 && imageW != nil && imageH != nil {
            image = image?.yi_scale(imageW ?? 0.0, imageH ?? 0.0)
            setImage(image, for: .normal)
        }
        let imageWidth = imageView?.image?.size.width ?? 0
        let imageHeight = imageView?.image?.size.height ?? 0
        let titleWidth = titleLabel?.text?.yi_getWidth((titleLabel?.font)!) ?? 0
        let titleHeight = titleLabel?.font.pointSize ?? 0
        let insetAmount = (space ?? 0) / 2
        let imageOffWidth = (imageWidth + titleWidth) / 2 - imageWidth / 2
        let imageOffHeight = imageHeight / 2 + insetAmount
        let titleOffWidth = imageWidth + titleWidth / 2 - (imageWidth + titleWidth) / 2
        let titleOffHeight = titleHeight / 2 + insetAmount
        switch type {
            case .left:
                imageEdgeInsets = .init(top: 0, left: -insetAmount,
                                             bottom: 0, right: insetAmount)
                titleEdgeInsets = .init(top: 0, left: insetAmount,
                                             bottom: 0, right: -insetAmount)
                contentHorizontalAlignment = .center
            case .right:
                imageEdgeInsets = .init(top: 0, left: titleWidth + insetAmount,
                                             bottom: 0, right: -(titleWidth + insetAmount))
                titleEdgeInsets = .init(top: 0, left: -(imageWidth + insetAmount),
                                             bottom: 0, right: imageWidth + insetAmount)
                contentHorizontalAlignment = .center
            case .top:
                imageEdgeInsets = .init(top: -imageOffHeight, left: imageOffWidth,
                                             bottom: imageOffHeight, right: -imageOffWidth)
                titleEdgeInsets = .init(top: titleOffHeight, left: -titleOffWidth,
                                             bottom: -titleOffHeight, right: titleOffWidth)
                contentVerticalAlignment = .center
            case .bottom:
                imageEdgeInsets = .init(top: imageOffHeight, left: imageOffWidth,
                                             bottom: -imageOffHeight, right: -imageOffWidth)
                titleEdgeInsets = .init(top: -titleOffHeight, left: -titleOffWidth,
                                             bottom: titleOffHeight, right: titleOffWidth)
                contentVerticalAlignment = .center
        }
    }
}

//MARK: --- 点击
extension UIButton {
    struct QYRuntimeKey {
        static let QYButtonClick = UnsafeRawPointer.init(bitPattern: "QYButtonClick".hashValue)
    }
    ///点击
    var yi_clickAction: (()->())? {
        set {
            objc_setAssociatedObject(self, QYRuntimeKey.QYButtonClick!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            addTarget(self, action: #selector(buttonClickAction), for: .touchUpInside)
        }
        get {
            return objc_getAssociatedObject(self, QYRuntimeKey.QYButtonClick!) as? () -> ()
        }
    }
    
    @objc private func buttonClickAction() {
        yi_clickAction?()
    }
}

//MARK: --- 倒计时
public extension UIButton {
    ///倒计时
    var yi_countdown: QYCountDownButton {
        return QYCountDownButton.shared
    }
}
