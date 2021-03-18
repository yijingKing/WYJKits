/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation
import UIKit

public struct WYJProtocol<T> {
    let obj: T
    init(_ obj: T) {
        self.obj = obj
    }
    
}

public protocol WYJCompatible {
    associatedtype CompatibleType
    var yi: CompatibleType { get }
}
public extension WYJCompatible {
    static var yi: WYJProtocol<Self>.Type {
        get { WYJProtocol<Self>.self }
        set {}
    }
    var yi: WYJProtocol<Self> {
        return WYJProtocol(self)
    }
}

extension CGPoint: WYJCompatible {}
extension CGSize: WYJCompatible {}
extension CGVector: WYJCompatible {}
extension CGRect: WYJCompatible {}
extension NSObject: WYJCompatible {}
extension Array: WYJCompatible {}
extension Data: WYJCompatible {}
extension Date: WYJCompatible {}
extension String: WYJCompatible {}
extension Int: WYJCompatible {}
extension Dictionary: WYJCompatible {}
extension Float: WYJCompatible {}
extension Set: WYJCompatible {}
extension Double: WYJCompatible {}
extension DateComponents: WYJCompatible {}
