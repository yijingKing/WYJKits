/*******************************************************************************
 Copyright (K), 2019 - ~, ╰莪呮想好好宠Nǐつ
 
 Author:        ╰莪呮想好好宠Nǐつ
 E-mail:        1091676312@qq.com
 GitHub:        https://github.com/MemoryKing
 *******************************************************************************/


import Foundation
import MBProgressHUD

fileprivate let manager = WYJHUD.shared

///位置
public enum managerLocation {
    case top
    case center
    case bottom
}

open class WYJHUD {
    ///单例
    static var shared = WYJHUD()
    ///超时时间
    public var delayTime: TimeInterval?
    ///是否动画
    public var animated: Bool = true
    ///位置
    public var location = managerLocation.center
    ///背景颜色
    public var backgroundColor = WYJHexColor("#2b2e2e").withAlphaComponent(0.8)
    ///文本颜色
    public var textColor = UIColor.white
    ///是否遮罩层
    public var isMask = true
    private var hud: MBProgressHUD?
    
    ///显示文本
    public static func show(_ title: String?,_ completion:(() -> ())? = nil) {
        DispatchQueue.getMainAsync {
            let text = title ?? ""
            WYJHUD.hideHUD()
            manager.hud = MBProgressHUD.showAdded(to: onView, animated: manager.animated)
            manager.defaultConfiguration(manager.hud)
            manager.hud?.completionBlock = completion
            var height = text.yi.getHeight(fixedWidth: WYJRatio(350))
            height = height > WYJRatio(350) ? WYJRatio(350) : height
            if height > WYJRatio(350) {
                let tv = HUDTextView()
                tv.text = text
                tv.textColor = .white
                tv.font = WYJFont(14)
                tv.isEditable = false
                tv.showsVerticalScrollIndicator = false
                tv.showsHorizontalScrollIndicator = false
                tv.backgroundColor = UIColor.black.withAlphaComponent(0)
                manager.hud?.customView = tv
                manager.hud?.mode = .customView
            } else {
                manager.hud?.label.font = WYJFont(14)
                manager.hud?.label.text = text
                manager.hud?.mode = .text
            }
            if let time = manager.delayTime {
                manager.hud?.minShowTime = time
            } else {
                if text.count / 7 < 1 {
                    manager.hud?.minShowTime = 1.7
                } else {
                    var time = Double(text.count) / 7 + 1
                    time = time > 6 ? 5 : time
                    manager.hud?.minShowTime = time
                }
            }
            manager.hud?.hide(animated: manager.animated)
        }
    }
    
    //MARK: --- 菊花
    ///菊花
    public static func loading(_ text: String? = nil) {
        DispatchQueue.getMainAsync {
            WYJHUD.hideHUD()
            manager.hud = MBProgressHUD.showAdded(to: onView, animated: manager.animated)
            manager.hud?.detailsLabel.text = text
            manager.hud?.detailsLabel.font = WYJFont(13)
            manager.hud?.mode = .indeterminate
            manager.defaultConfiguration(manager.hud)
        }
    }
    
    ///影藏
    public static func hideHUD() {
        manager.hud?.completionBlock = nil
        manager.hud?.hide(animated: manager.animated)
        manager.hud = nil
    }
    
    //MARK: --- 默认配置
    ///默认配置
    private func defaultConfiguration(_ hud: MBProgressHUD?) {
        ///多行
        hud?.label.numberOfLines = 0
        hud?.detailsLabel.numberOfLines = 0
        hud?.bezelView.style = .solidColor
        hud?.contentColor = textColor
        hud?.bezelView.backgroundColor = backgroundColor
        
        ///位置
        switch location {
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
        if let view = NSObject().yi.getTopViewController()?.view {
            return view
        }
        return UIApplication.shared.keyWindow?.rootViewController?.view ?? UIView()
    }
    
}

fileprivate class HUDTextView: UITextView {
    override var intrinsicContentSize: CGSize {
        var width = self.text.yi.getWidth(WYJFont(15))
        width = width > WYJRatio(350) ? WYJRatio(350) : width
        var height = self.text.yi.getHeight(fixedWidth: width)
        height = height > WYJRatio(350) ? WYJRatio(350) : height
        return .init(width: width, height: height)
    }
}
