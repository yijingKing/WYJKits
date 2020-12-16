/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/
 

import Foundation

public extension Data {
    ///byte  unit8 数组
    var yi_bytes: [UInt8] {
        return [UInt8](self)
    }
    ///转string
    func yi_toEncodingString(_ encoding: String.Encoding = String.Encoding.utf8) -> String? {
        return String(data: self, encoding: encoding)
    }
    ///json对象
    func yi_toJsonObject(options: JSONSerialization.ReadingOptions = [.mutableContainers]) throws -> Any {
        
        return try JSONSerialization.jsonObject(with: self, options: options)
    }
    /// data转数组
    func yi_toArray(_ options: JSONSerialization.ReadingOptions = [.mutableContainers]) -> Array<Any>? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: options) {
            return json as? Array<Any>
        }
        return nil
    }
    /// 转字典
    func yi_toDictionary(_ options: JSONSerialization.ReadingOptions = [.mutableContainers]) -> Dictionary<String, Any>? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: options) {
            return json as? Dictionary<String, Any>
        }
        
        return nil
    }
    /// 转string
    func yi_toJSONString(_ options: JSONSerialization.ReadingOptions = [.mutableContainers]) -> String? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: options) {
            return json as? String
        }
        return nil
    }
}
