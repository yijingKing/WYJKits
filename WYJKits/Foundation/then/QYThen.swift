/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ 
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation
import CoreGraphics

public protocol QYThen {}

public extension QYThen where Self: Any {

    /// 使它可以在初始化和复制值类型之后使用闭包设置属性。
    ///
    ///     let frame = CGRect().yi_with {
    ///       $0.origin.x = 10
    ///       $0.size.width = 100
    ///     }
    func yi_with (_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }
    
    /// 使它可用来执行闭包。
    ///
    ///     UserDefaults.standard.yi_do {
    ///       $0.set("devxoul", forKey: "username")
    ///       $0.set("devxoul@gmail.com", forKey: "email")
    ///       $0.synchronize()
    ///     }
    func yi_do (_ block: (Self) throws -> Void) rethrows {
        try block(self)
    }
}

public extension QYThen where Self: AnyObject {

    ///使它可以在初始化后使用闭包设置属性。
    ///
    ///     let label = UILabel().yi_then {
    ///       $0.textAlignment = .center
    ///       $0.textColor = UIColor.black
    ///       $0.text = "Hello, World!"
    ///     }
    func yi_then(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }

}

extension NSObject: QYThen {}
extension CGPoint: QYThen {}
extension CGRect: QYThen {}
extension CGSize: QYThen {}
extension CGVector: QYThen {}
extension Array: QYThen {}
extension Dictionary: QYThen {}
extension Set: QYThen {}
