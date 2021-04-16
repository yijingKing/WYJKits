/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit

public extension WYJProtocol where T == Double {
   
    /// 转 Int
    func int() -> Int { return Int(obj) }
    
    /// 转 CGFloat
    func cgFloat() -> CGFloat { return CGFloat(obj) }

    /// 转 Int64
    func int64() -> Int64 { return Int64(obj) }
    
    /// 转 Float
    func float() -> Float { return Float(obj) }
    
    /// 转 String
    func string() -> String { return String(obj) }
    
    /// 转 NSNumber
    func number() -> NSNumber { return NSNumber.init(value: obj) }
    
    /// 转 Double
    func double() -> Double { return obj }
    /// 浮点数四舍五入
    /// - Parameter places: 数字
    /// - Returns: Double
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (obj * divisor).rounded() / divisor
    }
}


public extension WYJProtocol where T == Double {
    /**
     NumberFormatter.Style:
     none                   四舍五入的整数
     decimal                小数形式（以国际化格式输出 保留三位小数,第四位小数四舍五入）
     currency               货币形式（以货币通用格式输出 保留2位小数,第三位小数四舍五入,在前面添加货币符号）
     percent                百分数形式
     scientific             科学计数
     spellOut               朗读形式（英文表示）
     ordinal                序数形式
     currencyISOCode        货币形式
     currencyPlural         货币形式
     currencyAccounting     会计计数
     */
    
    /// 转换格式
    /// - Parameters:
    ///   - minFraction: 最小分数位(默认0)
    ///   - maxFraction: 最大分数位(默认2)
    ///   - minInteger: 最小整数位
    ///   - maxInteger: 最大整数位
    /// - Returns: 转换格式后的字符串
    func localized(_ style: NumberFormatter.Style,minFraction: Int? = nil,maxFraction: Int? = nil,minInteger: Int? = nil,maxInteger: Int? = nil) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        
        if let min = minFraction {
            numberFormatter.minimumFractionDigits = min
        }
        if let max = maxFraction {
            numberFormatter.maximumFractionDigits = max
        }
        numberFormatter.minimumIntegerDigits = minInteger ?? 1
        if let max = maxInteger {
            numberFormatter.maximumIntegerDigits = max
        }
        return numberFormatter.string(for: obj)
    }
    
    ///分数(默认最小2位,最大3位)
    func toDecimal(min minFraction: Int? = 2,max maxFraction: Int? = nil) -> String? {
        return localized(.decimal, minFraction: minFraction, maxFraction: maxFraction,minInteger: 1,maxInteger: nil)
    }
    ///百分数(默认最小2位,最大3位)
    func toPercent(min minFraction: Int? = 2,max maxFraction: Int? = nil) -> String? {
        return localized(.percent, minFraction: minFraction, maxFraction: maxFraction,minInteger: 1,maxInteger: nil)
    }
    
    /// 分割位数
    /// - Parameters:
    ///   - style: 小数形式
    ///   - groupingSeparator: 分隔符号
    ///   - groupingSize: 分隔位数
    /// - Returns: 分割后的字符串
    func toSeparator(_ style: NumberFormatter.Style,separator: String? = ",",length: Int? = 4) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = separator
        numberFormatter.groupingSize = length ?? 0
        return numberFormatter.string(for: obj)
    }
    
    /// 增加前后缀
    /// - Parameters:
    ///   - style: 小数形式
    ///   - prefix: 前缀
    ///   - suffix: 后缀
    /// - Returns: 增加后的字符串
    func toPositive(_ style: NumberFormatter.Style,prefix: String? = nil,suffix: String? = nil) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        numberFormatter.positivePrefix = prefix
        numberFormatter.positiveSuffix = suffix
        return numberFormatter.string(for: obj)
    }
}
