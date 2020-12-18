/*******************************************************************************
 Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ
 
 Author:        ╰莪呮想好好宠Nǐつ
 E-mail:        1091676312@qq.com
 GitHub:        https://github.com/MemoryKing
 ********************************************************************************/


import UIKit

public extension WYJProtocol where T: UIButton {
    @discardableResult
    func title(_ string: String) -> WYJProtocol {
        obj.setTitle(string, for: .normal)
        return self
    }
    @discardableResult
    func titleFont(_ font: UIFont?) -> WYJProtocol {
        obj.titleLabel?.font = font
        return self
    }
    @discardableResult
    func attributedTitle(_ attributed: NSAttributedString?) -> WYJProtocol {
        obj.setAttributedTitle(attributed, for: .normal)
        return self
    }
    @discardableResult
    func titleColor(_ color: UIColor?) -> WYJProtocol {
        obj.setTitleColor(color, for: .normal)
        obj.setTitleColor(color?.withAlphaComponent(0.5), for: .disabled)
        obj.setTitleColor(color, for: .selected)
        if obj.buttonType == .custom {
            obj.setTitleColor(color?.withAlphaComponent(0.5), for: .highlighted)
        }
        return self
    }
    @discardableResult
    func selectedColor(_ color: UIColor?) -> WYJProtocol {
        obj.setTitleColor(color, for: .selected)
        obj.setTitleColor(color?.withAlphaComponent(0.5), for: .disabled)
        obj.setTitleColor(color, for: .selected)
        if obj.buttonType == .custom {
            obj.setTitleColor(color?.withAlphaComponent(0.5), for: .highlighted)
        }
        return self
    }
    @discardableResult
    func titleShadowColor(_ color: UIColor?) -> WYJProtocol {
        obj.setTitleShadowColor(color, for: .normal)
        obj.setTitleShadowColor(color?.withAlphaComponent(0.5), for: .disabled)
        obj.setTitleShadowColor(color, for: .selected)
        return self
    }
    @discardableResult
    func image(_ image: UIImage?) -> WYJProtocol {
        obj.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        return self
    }
    @discardableResult
    func selectedImage(_ image: UIImage?) -> WYJProtocol {
        obj.setImage(image?.withRenderingMode(.alwaysOriginal), for: .selected)
        return self
    }
    @discardableResult
    func backgroundImage(_ image: UIImage?) -> WYJProtocol {
        let img = image?.withRenderingMode(.alwaysOriginal)
        obj.setBackgroundImage(img, for: .normal)
        return self
    }
    @discardableResult
    func selectedBackgroundImage(_ image: UIImage?) -> WYJProtocol {
        obj.setBackgroundImage(image?.withRenderingMode(.alwaysOriginal), for: .selected)
        return self
    }
    @discardableResult
    func disabledBackgroundImage(_ image: UIImage?) -> WYJProtocol {
        obj.setBackgroundImage(image?.withRenderingMode(.alwaysOriginal), for: .disabled)
        return self
    }
    ///点击
    @discardableResult
    func clickAction(_ block:(()->())?) -> WYJProtocol {
        obj.clickAction = block
        return self
    }
}

public enum WYJButtonImagePosition: Int {
    case left       = 0x0
    case right      = 0x01
    case top        = 0x02
    case bottom     = 0x03
}

public extension WYJProtocol where T: UIButton {
    //MARK: --- 图片文本位置
    /// 图片文本位置
    /// - Parameters:
    ///   - type: 图片位置
    ///   - imageWidth: 图片大小
    ///   - space: 间距
    @discardableResult
    func imagePosition(_ type: WYJButtonImagePosition,_ space: CGFloat? = nil,_ imageW: CGFloat? = nil,_ imageH: CGFloat? = nil) -> WYJProtocol {
        var image: UIImage?
        if imageW != 0 && imageH != 0 && imageW != nil && imageH != nil {
            image = image?.yi.scale(imageW ?? 0.0, imageH ?? 0.0)
            obj.setImage(image, for: .normal)
        }
        let imageWidth = obj.imageView?.image?.size.width ?? 0
        let imageHeight = obj.imageView?.image?.size.height ?? 0
        let titleWidth = obj.titleLabel?.text?.yi.getWidth(obj.titleLabel?.font ?? UIFont.systemFont(ofSize: 17)) ?? 0
        
        
        let titleHeight = obj.titleLabel?.font.pointSize ?? 0
        let insetAmount = (space ?? 0) / 2
        let imageOffWidth = (imageWidth + titleWidth) / 2 - imageWidth / 2
        let imageOffHeight = imageHeight / 2 + insetAmount
        let titleOffWidth = imageWidth + titleWidth / 2 - (imageWidth + titleWidth) / 2
        let titleOffHeight = titleHeight / 2 + insetAmount
        switch type {
        case .left:
            obj.imageEdgeInsets = .init(top: 0, left: -insetAmount,
                                        bottom: 0, right: insetAmount)
            obj.titleEdgeInsets = .init(top: 0, left: insetAmount,
                                        bottom: 0, right: -insetAmount)
            obj.contentHorizontalAlignment = .center
        case .right:
            obj.imageEdgeInsets = .init(top: 0, left: titleWidth + insetAmount,
                                        bottom: 0, right: -(titleWidth + insetAmount))
            obj.titleEdgeInsets = .init(top: 0, left: -(imageWidth + insetAmount),
                                        bottom: 0, right: imageWidth + insetAmount)
            obj.contentHorizontalAlignment = .center
        case .top:
            obj.imageEdgeInsets = .init(top: -imageOffHeight, left: imageOffWidth,
                                        bottom: imageOffHeight, right: -imageOffWidth)
            obj.titleEdgeInsets = .init(top: titleOffHeight, left: -titleOffWidth,
                                        bottom: -titleOffHeight, right: titleOffWidth)
            obj.contentVerticalAlignment = .center
        case .bottom:
            obj.imageEdgeInsets = .init(top: imageOffHeight, left: imageOffWidth,
                                        bottom: -imageOffHeight, right: -imageOffWidth)
            obj.titleEdgeInsets = .init(top: -titleOffHeight, left: -titleOffWidth,
                                        bottom: titleOffHeight, right: titleOffWidth)
            obj.contentVerticalAlignment = .center
        }
        return self
    }
}

//MARK: --- 点击
extension UIButton {
    struct WYJRuntimeKey {
        static let WYJButtonClick = UnsafeRawPointer.init(bitPattern: "WYJButtonClick".hashValue)
    }
    ///点击
    var clickAction: (()->())? {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.WYJButtonClick!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            addTarget(self, action: #selector(buttonClickAction), for: .touchUpInside)
        }
        get {
            return objc_getAssociatedObject(self, WYJRuntimeKey.WYJButtonClick!) as? () -> ()
        }
    }
    
    @objc private func buttonClickAction() {
        clickAction?()
    }
}

//MARK: --- 倒计时
public extension UIButton {
    ///倒计时
    var countdown: WYJCountDownButton {
        return WYJCountDownButton.shared
    }
}
