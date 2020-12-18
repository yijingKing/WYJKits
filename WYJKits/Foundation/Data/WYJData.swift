/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/
 

import Foundation

public extension WYJProtocol where T == Data {
    ///byte  unit8 数组
    var bytes: [UInt8] {
        return [UInt8](obj)
    }
    ///转string
    func toEncodingString(_ encoding: String.Encoding = String.Encoding.utf8) -> String? {
        return String(data: obj, encoding: encoding)
    }
    ///json对象
    func toJsonObject(options: JSONSerialization.ReadingOptions = [.mutableContainers]) throws -> Any? {
        
        guard let json = try? JSONSerialization.jsonObject(with: obj, options: options) else {
            return nil
        }
        
        return json
    }
    /// data转数组
    func toArray(_ options: JSONSerialization.ReadingOptions = [.mutableContainers]) -> Array<Any>? {
        guard let json = try? JSONSerialization.jsonObject(with: obj, options: options) else {
            return nil
        }
        return json as? Array<Any>
    }
    /// 转字典
    func toDictionary(_ options: JSONSerialization.ReadingOptions = [.mutableContainers]) -> Dictionary<String, Any>? {
        guard let json = try? JSONSerialization.jsonObject(with: obj, options: options) else {
            return nil
        }
        return json as? Dictionary<String, Any>
    }
    /// 转string
    func toJSONString(_ options: JSONSerialization.ReadingOptions = [.mutableContainers]) -> String? {
        guard let json = try? JSONSerialization.jsonObject(with: obj, options: options) else {
            return nil
        }
        return json as? String
    }
}
