/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ 
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation
import UIKit

//MARK: --- 获取属性和方法
public extension NSObject {
    
    //MARK: --- 获取类的属性列表
    /// 获取类的属性列表
    func yi_get_class_copyPropertyList() -> [String] {
        var outCount:UInt32 = 0
        let propers:UnsafeMutablePointer<objc_property_t>! =  class_copyPropertyList(classForCoder, &outCount)
        let count:Int = Int(outCount);
        var names:[String] = [String]()
        for i in 0...(count-1) {
            let aPro: objc_property_t = propers[i]
            if let proName:String = String(utf8String: property_getName(aPro)){
                names.append(proName)
            }
        }
        return names
    }
    //MARK: --- 获取类的方法列表
    /// 获取类的方法列表
    func yi_get_class_copyMethodList() -> [String] {
        var outCount:UInt32
        outCount = 0
        let methods:UnsafeMutablePointer<objc_property_t>! =  class_copyMethodList(classForCoder, &outCount)
        let count:Int = Int(outCount);
        var names:[String] = [String]()
        for i in 0...(count-1) {
            let aMet: objc_property_t = methods[i]
            if let methodName:String = String(utf8String: property_getName(aMet)){
                names.append(methodName)
            }
        }
        return names
    }
    ///获取当前控制器
    func yi_getTopViewController () -> UIViewController? {
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            let windows = UIApplication.shared.windows
            for windowTemp in windows {
                if windowTemp.windowLevel == UIWindow.Level.normal {
                    window = windowTemp
                    break
                }
            }
        }
        let vc = window?.rootViewController
        if let presentVC = vc?.presentedViewController {
           return presentVC
            
        } else if let tabVC = vc as? UITabBarController,let selectVC = tabVC.selectedViewController {
            return selectVC
            
        } else if let naiVC = vc as? UINavigationController {
            return naiVC.visibleViewController
        }
        
        return nil
    }
    
}

public class AssociatedWrapper<Base> {
   let base: Base
   init(_ base: Base) {
        self.base = base
    }
}

public protocol AssociatedCompatible {
    associatedtype AssociatedCompatibleType
    var associated: AssociatedCompatibleType { get }
}

extension AssociatedCompatible {
    public var associated: AssociatedWrapper<Self> {
        get { return AssociatedWrapper(self) }
    }
}

extension NSObject: AssociatedCompatible { }

extension AssociatedWrapper where Base: NSObject {
    
    public enum Policy {
        case nonatomic
        case atomic
    }
    
    /// 获取关联值
    public func get<T>(_ key: UnsafeRawPointer) -> T? {
        objc_getAssociatedObject(base, key) as? T
    }
    
    /// 设置关联值 OBJC_ASSOCIATION_ASSIGN
    public func set(assign key: UnsafeRawPointer, _ value: Any) {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_ASSIGN)
    }
    
    /// 设置关联值 OBJC_ASSOCIATION_RETAIN_NONATOMIC / OBJC_ASSOCIATION_RETAIN
    public func set(retain key: UnsafeRawPointer, _ value: Any?, _ policy: Policy = .nonatomic) {
        switch policy {
        case .nonatomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        case .atomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 设置关联值 OBJC_ASSOCIATION_COPY_NONATOMIC / OBJC_ASSOCIATION_COPY
    public func set(copy key: UnsafeRawPointer, _ value: Any?, _ policy: Policy = .nonatomic) {
        switch policy {
        case .nonatomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        case .atomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_COPY)
        }
    }
}




//MARK: --- 时间选择器
public extension NSObject {
    ///时间选择器
    var yi_datePicker: QYDatePickerViewController {
        return QYDatePickerViewController()
    }
    
}

//MARK: --- 宏定义
/// 比例  -- Parameters: -- num: 长宽 -- proportionWidth: 比例宽(默认375)
public func QYRatio(_ num: CGFloat,_ proportionWidth: CGFloat = 375) -> CGFloat {
    return num * QYProportion(proportionWidth)
}
///屏幕宽
public var QYScreenWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}
///屏幕高
public var QYScreenHeight: CGFloat {
    return UIScreen.main.bounds.size.height
}
///屏幕比例
public func QYProportion(_ wid: CGFloat = 375) -> CGFloat {
    return UIScreen.main.bounds.size.width / wid
}
///导航高度
public var QYNavHeight: CGFloat {
    return 44.0
}
///tabbar栏高度
public var QYTabBarHeight: CGFloat {
    return 49.0
}
///底部安全区域
public var QYBottomHeight: CGFloat {
    return UIApplication.shared.statusBarFrame.size.height > 20.1 ? 34.0: 0.0
}
///状态条占的高度
public var QYStatusHeight: CGFloat {
    return UIApplication.shared.statusBarFrame.height
}
///导航栏高度 + 状态栏高度
public var QYStatusAndNavHeight: CGFloat {
    return QYStatusHeight + QYNavHeight
}
///tabbar高度 + iphoneX多出来的高度
public var QYBottomAndTabBarHeight: CGFloat {
    return QYBottomHeight + QYTabBarHeight
}
///大小
public func QYFont(_ font: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: font * QYProportion())
}
///加粗
public func QYBoldFont(_ font: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: font * QYProportion())
}
///斜体
public func QYItalicSystemFont(_ font: CGFloat) -> UIFont {
    return UIFont.italicSystemFont(ofSize: font)
}

