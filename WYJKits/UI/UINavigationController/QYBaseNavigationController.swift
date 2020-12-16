/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit

open class QYBaseNavigationController: UINavigationController,UIGestureRecognizerDelegate {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return yi_openPopGecognizer ?? true
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return yi_openPopGecognizer ?? true
    }
}

extension UINavigationController {
    struct QYRuntimeKey {
        static let popGestureB = UnsafeRawPointer.init(bitPattern: "popGestureB".hashValue)
    }
    ///是否打开侧滑返回
    var yi_openPopGecognizer: Bool? {
        set {
            objc_setAssociatedObject(self, QYRuntimeKey.popGestureB!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, QYRuntimeKey.popGestureB!) as? Bool
        }
    }
}
