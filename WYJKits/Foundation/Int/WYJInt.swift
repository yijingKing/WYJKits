/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit

public extension WYJProtocol where T == Int {
    
    /// 转 Double
    func double() -> Double { return Double(obj) }

    /// 转 Float
    func float() -> Float { return Float(obj) }
    
    /// 转 Int64
    func int64() -> Int64 { return Int64(obj) }

    /// 转 CGFloat
    func cgFloat() -> CGFloat { return CGFloat(obj) }

    /// 转 String
    func string() -> String { return String(obj) }

    /// 转 UInt
    func uInt() -> UInt { return UInt(obj) }
    
    /// 转 range
    func range() -> CountableRange<Int> { return 0..<obj }
    
    /// 转换亿的单位
    /// - Parameter scale: 小数点后舍入值的位数，默认 2 位
    /// - Returns: 返回万的字符串
    func toHundredMillion(_ scale: Int = 2) -> String? {
        if obj < 0 {
            return nil
        } else if obj <= 99999999 {
            return "\(obj)"
        } else {
            let doub = CGFloat(obj) / 100000000
            let str = String(format: "%.\(scale)f", doub)
            let start_index = str.index(str.endIndex, offsetBy: -1)
            let suffix = String(str[start_index ..< str.endIndex])
            if suffix == "0" {
                let toIndex = str.index(str.endIndex, offsetBy: -2)
                return String(str[str.startIndex ..< toIndex])
            } else {
                return str
            }
        }
    }
    
    /// 转换万的单位
    /// - Parameter scale: 小数点后舍入值的位数，默认 2 位
    /// - Returns: 返回万的字符串
    func toTenThousand(_ scale: Int = 2) -> String? {
        if obj < 0 {
            return nil
        } else if obj <= 9999 {
            return "\(obj)"
        } else {
            let doub = CGFloat(obj) / 10000
            let str = String(format: "%.\(scale)f", doub)
            let start_index = str.index(str.endIndex, offsetBy: -1)
            let suffix = String(str[start_index ..< str.endIndex])
            if suffix == "0" {
                let toIndex = str.index(str.endIndex, offsetBy: -2)
                return String(str[str.startIndex ..< toIndex])
            } else {
                return str
            }
        }
    }
    
    /// 转换千的单位
    /// - Parameter scale: 小数点后舍入值的位数，默认 2 位
    /// - Returns: 返回万的字符串
    func toThousand(_ scale: Int = 2) -> String? {
        if obj < 0 {
            return nil
        } else if obj <= 999 {
            return "\(obj)"
        } else {
            let doub = CGFloat(obj) / 1000
            let str = String(format: "%.\(scale)f", doub)
            let start_index = str.index(str.endIndex, offsetBy: -1)
            let suffix = String(str[start_index ..< str.endIndex])
            if suffix == "0" {
                let toIndex = str.index(str.endIndex, offsetBy: -2)
                return String(str[str.startIndex ..< toIndex])
            } else {
                return str
            }
        }
    }
    
    /// 转换百的单位
    /// - Parameter scale: 小数点后舍入值的位数，默认 2 位
    /// - Returns: 返回万的字符串
    func toHundred(_ scale: Int = 2) -> String? {
        if obj < 0 {
            return nil
        } else if obj <= 99 {
            return "\(obj)"
        } else {
            let doub = CGFloat(obj) / 100
            let str = String(format: "%.\(scale)f", doub)
            let start_index = str.index(str.endIndex, offsetBy: -1)
            let suffix = String(str[start_index ..< str.endIndex])
            if suffix == "0" {
                let toIndex = str.index(str.endIndex, offsetBy: -2)
                return String(str[str.startIndex ..< toIndex])
            } else {
                return str
            }
        }
    }
}

public extension Int {

    ///  取区间内的随机数，如取  0..<10 之间的随机数
    /// - Parameter within: 0..<10
    /// - Returns: 返回区间内的随机数
    static func random(within: Range<Int>) -> Int {
        let delta = within.upperBound - within.lowerBound
        return within.lowerBound + Int(arc4random_uniform(UInt32(delta)))
    }
}
