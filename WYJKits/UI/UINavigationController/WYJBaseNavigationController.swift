/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit

open class WYJBaseNavigationController: UINavigationController,UIGestureRecognizerDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self

    }
    
    
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return openPopGecognizer ?? true
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return openPopGecognizer ?? true
    }
}

extension UINavigationController {
    struct WYJRuntimeKey {
        static let popGestureB = UnsafeRawPointer.init(bitPattern: "popGestureB".hashValue)
    }
    ///是否打开侧滑返回
    var openPopGecognizer: Bool? {
        set {
            objc_setAssociatedObject(self, WYJRuntimeKey.popGestureB!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYJRuntimeKey.popGestureB!) as? Bool
        }
    }
}
