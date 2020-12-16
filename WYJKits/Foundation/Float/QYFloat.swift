/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit

public extension Float {
    
    /// 转 Int
    var int: Int { return Int(self) }
    
    /// 转 CGFloat
    var cgFloat: CGFloat { return CGFloat(self) }
    
    /// 转 Int64
    var int64: Int64 { return Int64(self) }
    
    /// 转 Double
    var double: Double { return Double(self) }
    
    /// 转 String
    var string: String { return String(self) }
    
    /// 转 NSNumber
    var number: NSNumber { return NSNumber.init(value: self) }
    
    /// 转 Float
    var float: Float { return self }
}

public extension Float {

    /// 浮点数四舍五入,places
    /// - Parameter places: 小数保留的位数
    /// - Returns: 保留后的小数
    func yi_round(to places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}
