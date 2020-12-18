/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import Foundation

///string and int
public struct WYJStrInt: WYJCodable {
    var int: Int?
    
    var string: String?
    
    public init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        
        if let stringValue = try? singleValueContainer.decode(String.self) {
            string = stringValue
            int = stringValue.yi.toInt()
            
        } else if let intValue = try? singleValueContainer.decode(Int.self) {
            int = intValue
            string = String(intValue)
        } else {
            int = nil
            string = nil
        }
    }
}

///bool and int
public struct WYJBoolInt: WYJCodable {
    var int: Int?
    
    var bool: Bool?
    
    public init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        
        if let boolValue = try? singleValueContainer.decode(Bool.self) {
            bool = boolValue
            int = boolValue ? 1 : 0
            
        } else if let intValue = try? singleValueContainer.decode(Int.self) {
            int = intValue
            bool = intValue == 1 ? true : false
        } else {
            int = nil
            bool = nil
        }
    }
}

///string  double
public struct WYJStrDble: WYJCodable {
    var double: Double?
    
    var string: String?
    
    public init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        
        if let stringValue = try? singleValueContainer.decode(String.self) {
            string = stringValue
            double = stringValue.yi.toDouble()
        } else if let doubleValue = try? singleValueContainer.decode(Double.self) {
            double = doubleValue
            string = String(doubleValue)
        } else {
            double = nil
            string = nil
        }
    }
}
