/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit

public extension WYJProtocol where T == Float {
    
    /// 转 Int
    func int() -> Int { return Int(obj) }
    
    /// 转 CGFloat
    func cgFloat() -> CGFloat { return CGFloat(obj) }
    
    /// 转 Int64
    func int64() -> Int64 { return Int64(obj) }
    
    /// 转 Double
    func double() -> Double { return Double(obj) }
    
    /// 转 String
    func string() -> String { return String(obj) }
    
    /// 转 NSNumber
    func number() -> NSNumber { return NSNumber.init(value: obj) }
    
    /// 转 Float
    func float() -> Float { return obj }
    /// 浮点数四舍五入,places
    /// - Parameter places: 小数保留的位数
    /// - Returns: 保留后的小数
    func round(to places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (obj * divisor).rounded() / divisor
    }
}
