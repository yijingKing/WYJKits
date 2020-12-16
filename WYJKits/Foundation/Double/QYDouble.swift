/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit

public extension Double {
   
    /// 转 Int
    var int: Int { return Int(self) }
    
    /// 转 CGFloat
    var cgFloat: CGFloat { return CGFloat(self) }

    /// 转 Int64
    var int64: Int64 { return Int64(self) }
    
    /// 转 Float
    var float: Float { return Float(self) }
    
    /// 转 String
    var string: String { return String(self) }
    
    /// 转 NSNumber
    var number: NSNumber { return NSNumber.init(value: self) }
    
    /// 转 Double
    var double: Double { return self }
}

public extension Double {
    
    /// 浮点数四舍五入
    /// - Parameter places: 数字
    /// - Returns: Double
    func yi_round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
