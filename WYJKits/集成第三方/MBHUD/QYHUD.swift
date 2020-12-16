/*******************************************************************************
 Copyright (K), 2019 - ~, ╰莪呮想好好宠Nǐつ
 
 Author:        ╰莪呮想好好宠Nǐつ
 E-mail:        1091676312@qq.com
 GitHub:        https://github.com/MemoryKing
 *******************************************************************************/


import Foundation
import MBProgressHUD

fileprivate let manager = QYHUD.shared

///位置
public enum managerLocation {
    case top
    case center
    case bottom
}

open class QYHUD {
    ///单例
    static var shared = QYHUD()
    ///超时时间
    public var yi_delayTime: TimeInterval?
    ///是否动画
    public var yi_animated: Bool = true
    ///位置
    public var yi_location = managerLocation.center
    ///背景颜色
    public var yi_backgroundColor = QYHexColor("#2b2e2e").withAlphaComponent(0.8)
    ///文本颜色
    public var yi_textColor = UIColor.white
    ///是否遮罩层
    public var yi_isMask = true
    private var hud: MBProgressHUD?
    
    ///显示文本
    public static func yi_show(_ title: String?,_ completion:(() -> ())? = nil) {
        DispatchQueue.yi_getMainAsync {
            let text = title ?? ""
            QYHUD.yi_hidden()
            manager.hud = MBProgressHUD.showAdded(to: onView, animated: manager.yi_animated)
            manager.defaultConfiguration(manager.hud)
            manager.hud?.completionBlock = completion
            let tv = HUDTextView()
            tv.text = text
            tv.textColor = .white
            tv.font = QYFont(15)
            tv.isEditable = false
            tv.showsVerticalScrollIndicator = false
            tv.showsHorizontalScrollIndicator = false
            tv.backgroundColor = UIColor.black.withAlphaComponent(0)
            manager.hud?.customView = tv
            manager.hud?.mode = .customView
            
            if let time = manager.yi_delayTime {
                manager.hud?.minShowTime = time
            } else {
                if text.count / 7 < 1 {
                    manager.hud?.minShowTime = 1.75
                } else {
                    var time = Double(text.count) / 7 + 1
                    time = time > 6 ? 5 : time
                    manager.hud?.minShowTime = time
                }
            }
            manager.hud?.hide(animated: manager.yi_animated)
        }
    }
    
    //MARK: --- 菊花
    ///菊花
    public static func yi_loading(_ text: String? = nil) {
        DispatchQueue.yi_getMainAsync {
            QYHUD.yi_hidden()
            manager.hud = MBProgressHUD.showAdded(to: onView, animated: manager.yi_animated)
            manager.hud?.label.text = text
            manager.hud?.mode = .indeterminate
            manager.defaultConfiguration(manager.hud)
        }
    }
    
    ///影藏
    public static func yi_hidden() {
        manager.hud?.completionBlock = nil
        manager.hud?.hide(animated: manager.yi_animated)
        manager.hud = nil
    }
    
    //MARK: --- 默认配置
    ///默认配置
    private func defaultConfiguration(_ hud: MBProgressHUD?) {
        ///多行
        hud?.label.numberOfLines = 0
        hud?.bezelView.style = .solidColor
        hud?.contentColor = yi_textColor
        hud?.bezelView.backgroundColor = yi_backgroundColor
        
        ///位置
        switch yi_location {
            case .top:
                hud?.offset = .init(x: 0, y: -MBProgressMaxOffset)
            case .center:
                hud?.offset = .init(x: 0, y: 0)
            case .bottom:
                hud?.offset = .init(x: 0, y: MBProgressMaxOffset)
        }
        hud?.removeFromSuperViewOnHide = true
    }
    
    ///当前视图
    private static var onView: UIView {
        if let view = NSObject().yi_getTopViewController()?.view {
            return view
        }
        return UIApplication.shared.keyWindow?.rootViewController?.view ?? UIView()
    }
    
}

fileprivate class HUDTextView: UITextView {
    override var intrinsicContentSize: CGSize {
        var width = self.text.yi_getWidth(QYFont(15))
        width = width > QYRatio(350) ? QYRatio(350) : width
        var height = self.text.yi_getHeight(fixedWidth: width)
        height = height > QYRatio(350) ? QYRatio(350) : height
        return .init(width: width, height: height)
    }
}
