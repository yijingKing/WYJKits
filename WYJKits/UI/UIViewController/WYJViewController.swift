/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import Foundation
import UIKit

//MARK: ---------- 设置导航 ----------
public extension WYJProtocol where T: UIViewController {
    ///设置暗黑模式(影响当前view/viewController/window 以及它下面的任何内容。)
    @available(iOS 12.0, *)
    @discardableResult
    func interfaceStyle(_ style: UIUserInterfaceStyle) -> WYJProtocol {
        if #available(iOS 13.0, *) {
            obj.overrideUserInterfaceStyle = style
        } else {
            // Fallback on earlier versions
        }
        return self
    }
    @available(iOS 12.0, *)
    ///获取当前暗黑模式
    func userInterfaceStyle() -> UIUserInterfaceStyle {
        if #available(iOS 13.0, *) {
            return UITraitCollection.current.userInterfaceStyle
        } else {
            // Fallback on earlier versions
        }
        return .unspecified
    }
    
    ///影藏底线
    @discardableResult
    func isHiddenShadow(_ bool: Bool) -> WYJProtocol {
            
        if let nav = obj.navigationController {
                if bool {
                    nav.navigationBar.shadowImage = UIImage()
                } else {
                    nav.navigationBar.shadowImage = nil
                }
            }
        return self
    }
    ///隐藏导航
    @discardableResult
    func isNavBarHidden(_ bool: Bool) -> WYJProtocol {
        obj.navigationController?.isNavigationBarHidden = bool
        return self
    }
    ///导航透明
    func navClear() -> WYJProtocol {
        obj.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        obj.navigationController?.navigationBar.shadowImage = UIImage()
        return self
    }
    ///返回图片
    @discardableResult
    func backImage(_ img: UIImage?) -> WYJProtocol {
        if let nav = obj.navigationController {
            if nav.children.count > 1 {
                navLeftImageItem(img) {
                    goBack()
                }
            }
        }
        return self
    }
    ///导航背景色
    @discardableResult
    func navBackground(_ color:UIColor?) -> WYJProtocol {
        if let nav = obj.navigationController {
            nav.navigationBar.barTintColor = color ?? UIColor.white
            nav.navigationBar.isTranslucent = false
        }
        return self
    }
    ///文本
    @discardableResult
    func navTitle (_ title: String?,
                      _ color: UIColor? = nil,
                      _ font: CGFloat? = nil) -> WYJProtocol {
        if let nav = obj.navigationController {
            obj.navigationItem.title = title ?? ""
            let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: color ?? UIColor.black,NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font ?? 18)]
            nav.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key: AnyObject]
        }
        return self
    }
    ///左文本按钮
    @discardableResult
    func navLeftTitleItem (_ title: String,
                              _ font: UIFont? = nil,
                              _ color: UIColor? = nil,
                              _ navBlk: @escaping()->()) -> WYJProtocol {
        let item = obj._customBarButtonItem(title, color ?? UIColor.black, font ?? UIFont.systemFont(ofSize: 14), nil, #selector(obj.navLeftItemClick))
        obj.navigationItem.leftBarButtonItem = item
        obj.leftNavBlock = navBlk
        return self
    }
    
    ///左图片按钮
    @discardableResult
    func navLeftImageItem (_ image: UIImage?,
                              _ navBlk: @escaping()->()) -> WYJProtocol {
        let leftItem = UIBarButtonItem(image: image?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(obj.navLeftItemClick))
        obj.navigationItem.leftBarButtonItem = leftItem
        obj.leftNavBlock = navBlk
        return self
    }
    
    ///左图文
    @discardableResult
    func navLeftTitleAndImageItem (_ title: String? ,
                                      _ color: UIColor? = nil,
                                      _ font: UIFont? = nil,
                                      _ image: UIImage? = nil,
                                      _ navBlk: @escaping()->()) -> WYJProtocol {
        let item = obj._customBarButtonItem(title, color ?? UIColor.black, font ?? UIFont.systemFont(ofSize: 17), image, #selector(obj.navLeftItemClick))
        obj.navigationItem.leftBarButtonItem = item
        obj.leftNavBlock = navBlk
        return self
    }

    ///右文本按钮
    @discardableResult
    func navRightTitleItem (_ title: String,
                               _ font: UIFont? = nil,
                               _ color: UIColor? = nil,
                               _ navBlk: @escaping()->()) -> WYJProtocol {
        let item = obj._customBarButtonItem(title, color ?? UIColor.black, font ?? UIFont.systemFont(ofSize: 14), nil, #selector(obj.navRightItemClick))
        obj.navigationItem.rightBarButtonItem = item
        obj.rightNavBlock = navBlk
        return self
    }
    
    ///右图片按钮
    @discardableResult
    func navRightImageItem (_ image: UIImage,_ navBlk: @escaping()->()) -> WYJProtocol {
        let rightItem = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(obj.navRightItemClick))
        obj.navigationItem.rightBarButtonItem = rightItem
        obj.rightNavBlock = navBlk
        return self
    }
    
    ///右图文
    @discardableResult
    func navRightTitleAndImageItem (_ title: String?,
                                       _ color: UIColor? = nil,
                                       _ font: UIFont? = nil,
                                       _ image: UIImage? = nil,_ navBlk: @escaping()->()) -> WYJProtocol {
        let item = obj._customBarButtonItem(title, color ?? UIColor.black, font ?? UIFont.systemFont(ofSize: 17), image, #selector(obj.navRightItemClick))
        obj.navigationItem.rightBarButtonItem = item
        obj.rightNavBlock = navBlk
        return self
    }
}
//MARK: --- 功能
public extension WYJProtocol where T: UIViewController {
    ///背景图
    @discardableResult
    func backgroundImage(_ named: String) -> WYJProtocol {
        let image = UIImage(named: named)
        let imageView = UIImageView(frame: obj.view.frame)
        imageView.image = image
        obj.view.addSubview(imageView)
        obj.view.sendSubviewToBack(imageView)
        return self
    }
    ///背景图
    @discardableResult
    func backgroundImage(_ image: UIImage) -> WYJProtocol {
        let imageView = UIImageView(frame: obj.view.frame)
        imageView.image = image
        obj.view.addSubview(imageView)
        obj.view.sendSubviewToBack(imageView)
        return self
    }
    ///将指定的视图控制器添加为当前视图控制器的子视图控制器
    @discardableResult
    func addChildViewController(_ vc: UIViewController, toView: UIView) -> WYJProtocol {
        obj.addChild(vc)
        toView.addSubview(vc.view)
        vc.didMove(toParent: obj)
        return self
    }
}

//MARK: --- 跳转
public extension WYJProtocol where T: UIViewController {
    ///跳转
    @discardableResult
    func push(_ viewController: UIViewController,_ animated: Bool = true) -> WYJProtocol {
        if let nav = obj.navigationController {
            if nav.children.count > 0 {
                viewController.hidesBottomBarWhenPushed = true
            }
            nav.pushViewController(viewController, animated: animated)
        }
        return self
    }
    @discardableResult
    func present(_ viewController: UIViewController,_ animated: Bool = true,_ completion: (()->Void)? = nil) -> WYJProtocol {
        obj.present(viewController, animated: animated, completion: completion)
        return self
    }
    ///返回
    @discardableResult
    func goBack(_ ani: Bool = true) -> WYJProtocol {
        if let nav = obj.navigationController {
            if nav.viewControllers.count > 1 {
                nav.popViewController(animated: ani)
            }
        }
        if let _ = obj.presentingViewController {
            obj.dismiss(animated: ani, completion: nil)
        }
        return self
    }

    ///返回某视图
    @discardableResult
    func goBackToVC(_ num: Int? = nil,_ ani: Bool? = nil) -> WYJProtocol {
        if let nav = obj.navigationController {
            let vc = nav.viewControllers[num ?? 0]
            nav.popToViewController(vc, animated: ani ?? true)
        }
        return self
    }
    
    ///返回首页
    @discardableResult
    func backToRootControlelr (_ ani: Bool = true) -> WYJProtocol {
        if let nav = obj.navigationController, nav.viewControllers.count > 1 {
            nav.popToRootViewController(animated: ani)
        }
        if let _ = obj.presentingViewController {
            obj.dismiss(animated: ani, completion: nil)
        }
        return self
    }
}

//MARK: --- 私有
fileprivate extension UIViewController {
    private struct WYJRuntimeKey {
        static let leftKey = UnsafeRawPointer.init(bitPattern: "leftKey".hashValue)
        static let rightKey = UnsafeRawPointer.init(bitPattern: "rightKey".hashValue)
        static let titleColorKey = UnsafeRawPointer.init(bitPattern: "titleColorKey".hashValue)
        static let hiddenShadowKey = UnsafeRawPointer.init(bitPattern: "hiddenShadowKey".hashValue)
        static let interfaceStyleKey = UnsafeRawPointer.init(bitPattern: "interfaceStyleKey".hashValue)
    }
    
    var leftNavBlock: (() ->())? {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.leftKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return  (objc_getAssociatedObject(self, WYJRuntimeKey.leftKey!) as! (() ->()))
        }
    }
    
    var rightNavBlock: (() ->())? {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.rightKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, WYJRuntimeKey.rightKey!) as! (() ->()))
        }
    }
    
    @objc func navLeftItemClick() {
        if let block = leftNavBlock {
            block()
        }
    }
    
    @objc func navRightItemClick() {
        if let block = rightNavBlock {
            block()
        }
    }
    
    //自定义barItem
    func _customBarButtonItem (_ title: String? ,
                                       _ color: UIColor? = nil,
                                       _ font: UIFont? = nil,
                                       _ image: UIImage? = nil,
                                       _ block: Selector) -> UIBarButtonItem {
        let button = UIButton().yi.then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(color ?? UIColor.black, for: .normal)
            $0.setBackgroundImage(image, for: .normal)
            $0.titleLabel?.font = font ?? UIFont.systemFont(ofSize: 17)
            $0.addTarget(self, action: block, for: .touchUpInside)
        }
        return UIBarButtonItem.init(customView: button)
    }
}
