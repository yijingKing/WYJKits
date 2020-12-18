/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ 
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation
import CoreGraphics

public extension WYJProtocol where T: Any {

    /// 使它可以在初始化和复制值类型之后使用闭包设置属性。
    ///
    ///     let frame = CGRect().with {
    ///       $0.origin.x = 10
    ///       $0.size.width = 100
    ///     }
    func with (_ block: (inout T) throws -> Void) rethrows -> T {
        var copy = obj
        try block(&copy)
        return copy
    }
    
    /// 使它可用来执行闭包。
    ///
    ///     UserDefaults.standard.do {
    ///       $0.set("devxoul", forKey: "username")
    ///       $0.set("devxoul@gmail.com", forKey: "email")
    ///       $0.synchronize()
    ///     }
    func dos (_ block: (T) throws -> Void) rethrows {
        try block(obj)
    }
}

public extension WYJProtocol where T: AnyObject {

    ///使它可以在初始化后使用闭包设置属性。
    ///
    ///     let label = UILabel().yi.then {
    ///       $0.textAlignment = .center
    ///       $0.textColor = UIColor.black
    ///       $0.text = "Hello, World!"
    ///     }
    func then(_ block: (T) throws -> Void) rethrows -> T {
        try block(obj)
        return obj
    }
}

