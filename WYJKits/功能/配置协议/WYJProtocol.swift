/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation
import UIKit

public struct WYJProtocol<T> {
    public let obj: T
    public init(_ obj: T) {
        self.obj = obj
    }
}

public protocol WYJCompatible {
    associatedtype CompatibleType
    var yi: CompatibleType { get }
}

public extension WYJCompatible {
    var yi: WYJProtocol<Self> {
        return WYJProtocol(self)
    }
}

extension NSObject: WYJCompatible {}
extension CGPoint: WYJCompatible {}
extension CGRect: WYJCompatible {}
extension CGSize: WYJCompatible {}
extension CGVector: WYJCompatible {}
extension Array: WYJCompatible {}
extension String: WYJCompatible {}
extension Dictionary: WYJCompatible {}
extension Set: WYJCompatible {}
extension Data: WYJCompatible {}
extension Date: WYJCompatible {}
extension DateComponents: WYJCompatible {}
