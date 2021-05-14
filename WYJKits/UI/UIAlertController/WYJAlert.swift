/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation
import UIKit

///系统提示窗
open class WYJAlert: UIView {
    //MARK: --- 系统提示框
    /// 系统提示框
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 内容
    ///   - highlighted: 高亮
    ///   - handler: 设置action
    ///   - titleArr: 选择数组
    ///   - type: 类型
    public class func show(title: String?,
                       message: String?,
                       titles: [String],
                       type: UIAlertController.Style = .alert,
                       handler: ((UIAlertController,UIAlertAction,NSInteger) -> Void)?,
                       complete: @escaping ((UIAlertController,NSInteger,String)->(Void))) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: type)
        for (index,item) in titles.enumerated() {
            let action = UIAlertAction.init(title: item, style: .default, handler: { (action) in
                complete(alert,index,item)
            })
            handler?(alert,action,index)
            alert.addAction(action)
        }
        
        if type == .actionSheet {
            alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    //MARK: --- 系统提示框带输入框
    /// 系统提示框带输入框
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 内容
    ///   - titleArr: 选择数组
    ///   - highlighted: 高亮
    ///   - textFields: 输入框数组
    ///   - actionHandler: 设置Alert
    ///   - tfHandler: 设置输入框
    ///   - type: 类型
    public class func show(title: String?,message: String?,
                       titleArr: [String],
                       textFields: [String],
                       type: UIAlertController.Style = .alert,
                       actionHandler: ((UIAlertController,UIAlertAction,NSInteger) -> Void)?,
                       tfHandler: ((UITextField,NSInteger) -> Void)?,
                       complete: @escaping ((UIAlertController,NSInteger,String)->(Void))) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: type)
        for (index,item) in titleArr.enumerated() {
            let action = UIAlertAction.init(title: item, style: .default, handler: { (action) in
                complete(alert,index,item)
            })
            actionHandler?(alert,action,index)
            alert.addAction(action)
        }
        for (index,item) in textFields.enumerated() {
            alert.addTextField { (tf) in
                tf.placeholder = item
                tfHandler?(tf,index)
            }
        }
        
        if type == .actionSheet {
            alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        }
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    ///默认确认取消
    public class func show(title: String = "",message: String = "",complete: @escaping (()->())) {
        show(title: title, message: message, titles: ["取消","确定"], type: .alert, handler: nil) { (alert, integer, string) -> (Void) in
            if integer == 1 {
                complete()
            }
        }
    }
    
    ///打开相机相册
    public class func invokeCameraPhotoAlbum (_ blc: ((UIImage)->())?) {
        let system = WYJSystem()
        system.photoBlock = blc
        let alertVC = UIAlertController.init(title: "", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction.init(title: "相机", style: .default) { (action) in
            system.invokeSystemCamera()
        }
        let photoAction = UIAlertAction.init(title: "相册", style: .default) { (action) in
            system.invokeSystemPhoto()
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(cameraAction)
        alertVC.addAction(photoAction)
        alertVC.addAction(cancelAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
    }
}

//MARK: --- UIAlertController 属性
public extension UIAlertController {
    //MARK: --- 标题文本颜色
    ///标题文本颜色
    var titleColor: UIColor? {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.titleColorKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            let titleAtt = NSMutableAttributedString.init(string: title ?? "")
            titleAtt.addAttribute(.foregroundColor, value: newValue ?? UIColor.black, range: .init(location: 0, length: title?.count ?? 0))
            titleAtt.addAttribute(.font, value: titleFont ?? WYJFont(17), range: .init(location: 0, length: titleAtt.length))
            setValue(titleAtt, forKey: "attributedTitle")
        }
        get {
            let color = objc_getAssociatedObject(self, WYJRuntimeKey.titleColorKey!) as? UIColor
            return color
        }
    }
    
    //MARK: --- 标题文本字体
    ///标题文本字体
    var titleFont: UIFont? {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.titleFontKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            let titleAtt = NSMutableAttributedString.init(string: title ?? "")
            titleAtt.addAttribute(.foregroundColor, value: titleColor ?? UIColor.black, range: .init(location: 0, length: title?.count ?? 0))
            titleAtt.addAttribute(.font, value: newValue ?? WYJFont(17), range: .init(location: 0, length: titleAtt.length))
            setValue(titleAtt, forKey: "attributedTitle")
        }
        get {
            let font = objc_getAssociatedObject(self, WYJRuntimeKey.titleFontKey!) as? UIFont
            return font
        }
    }
    
    //MARK: --- 标题富文本
    ///标题富文本
    var attributedTitle: NSAttributedString? {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.attributedTitleKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            setValue(newValue, forKey: "attributedTitle")
        }
        get {
            let att = objc_getAssociatedObject(self, WYJRuntimeKey.attributedTitleKey!) as? NSAttributedString
            return att
        }
    }
    
    //MARK: --- 内容颜色
    ///内容颜色
    var messageColor: UIColor? {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.messageColorKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            let titleAtt = NSMutableAttributedString.init(string: message ?? "")
            titleAtt.addAttribute(.foregroundColor, value: newValue ?? UIColor.black, range: .init(location: 0, length: message?.count ?? 0))
            titleAtt.addAttribute(.font, value: titleFont ?? WYJFont(17), range: .init(location: 0, length: titleAtt.length))
            setValue(titleAtt, forKey: "attributedMessage")
        }
        get {
            let color = objc_getAssociatedObject(self, WYJRuntimeKey.messageColorKey!) as? UIColor
            return color
        }
    }
    
    //MARK: --- 内容字体
    ///内容字体
    var messageFont: UIFont? {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.messageFontKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            let titleAtt = NSMutableAttributedString.init(string: message ?? "")
            titleAtt.addAttribute(.foregroundColor, value: messageColor ?? UIColor.black, range: .init(location: 0, length: message?.count ?? 0))
            titleAtt.addAttribute(.font, value: newValue ?? WYJFont(15), range: .init(location: 0, length: titleAtt.length))
            setValue(titleAtt, forKey: "attributedMessage")
        }
        get {
            let font = objc_getAssociatedObject(self, WYJRuntimeKey.messageFontKey!) as? UIFont
            return font
        }
    }
    
    //MARK: --- 内容富文本
    ///内容富文本
    var attributedMessage: NSAttributedString? {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.attributedMessageKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            setValue(newValue, forKey: "attributedMessage")
        }
        get {
            let att = objc_getAssociatedObject(self, WYJRuntimeKey.attributedMessageKey!) as? NSAttributedString
            return att
        }
    }
    
    private struct WYJRuntimeKey {
        static let titleColorKey = UnsafeRawPointer.init(bitPattern: "titleColorKey".hashValue)
        static let titleFontKey = UnsafeRawPointer.init(bitPattern: "titleFontKey".hashValue)
        static let attributedTitleKey = UnsafeRawPointer.init(bitPattern: "attributedTitle".hashValue)
        static let messageColorKey = UnsafeRawPointer.init(bitPattern: "messageColorKey".hashValue)
        static let messageFontKey = UnsafeRawPointer.init(bitPattern: "messageFontKey".hashValue)
        static let attributedMessageKey = UnsafeRawPointer.init(bitPattern: "attributedmessage".hashValue)
    }
}

//MARK: --- UIAlertAction  属性
public extension UIAlertAction {
    //MARK: --- 文本颜色
    ///文本颜色
    var titleColor: UIColor? {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.titleColorKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            setValue(newValue, forKey: "titleTextColor")
        }
        get {
            let color = objc_getAssociatedObject(self, WYJRuntimeKey.titleColorKey!) as? UIColor
            return color
        }
    }
    
    //MARK: --- 图片
    ///图片
    var image: UIImage? {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.imageKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            setValue(newValue?.withRenderingMode(.alwaysOriginal), forKey: "image")
        }
        get {
            let img = objc_getAssociatedObject(self, WYJRuntimeKey.imageKey!) as? UIImage
            return img
        }
    }
    
    private struct WYJRuntimeKey {
        static let titleColorKey = UnsafeRawPointer.init(bitPattern: "titleColorKey".hashValue)
        static let imageKey = UnsafeRawPointer.init(bitPattern: "imageKey".hashValue)
    }
}
