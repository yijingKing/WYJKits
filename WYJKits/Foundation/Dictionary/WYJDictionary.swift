/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation

public extension WYJProtocol where T == Dictionary<String, Any> {
    ///转json
    func toJSONString(_ options: JSONSerialization.WritingOptions = []) -> String? {
        guard JSONSerialization.isValidJSONObject(obj) else {
            WYJLog("dic转json失败")
            return nil
        }
        var newData : Data
        if #available(iOS 11.0, *) {
            guard let nData = try? JSONSerialization.data(withJSONObject: obj, options: .sortedKeys) else {
                WYJLog("dic转json失败")
                return nil
            }
            newData = nData
        } else {
            guard let neData : Data = try? JSONSerialization.data(withJSONObject: obj, options: options) else {
                WYJLog("dic转json失败")
                return nil
            }
            newData = neData
        }
        guard let JSONString = NSString(data:newData, encoding: String.Encoding.utf8.rawValue) else {
            WYJLog("dic转json失败")
            return nil
        }
        return JSONString as String
    }
    
    /// 字典转二进制
    func toData(_ options: JSONSerialization.WritingOptions = .prettyPrinted) -> Data? {
        
        guard JSONSerialization.isValidJSONObject(obj) else {
            WYJLog("字典转二进制失败")
            return nil
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: obj, options: options)
            return data
        } catch let error {
            WYJLog(error)
        }
        return nil
    }
    
    
}


public extension Dictionary {
    ///json 初始化
    init? (json: String) {
        
        guard let jsonData = json.data(using: String.Encoding.utf8, allowLossyConversion: true) else {
            return nil
        }
        guard let dic = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) else {
            return nil
        }
        if let d = dic as? NSDictionary {
            self.init(_immutableCocoaDictionary: d)
        }
        self.init()
    }
    // MARK: 字典的key或者value组成的数组
    /// 字典的key或者value组成的数组
    /// - Parameter map: map
    /// - Returns: 数组
    func toArray<V>(_ map: (Key, Value) -> V) -> [V] {
        return self.map(map)
    }
    
    // MARK: 检查字典里面是否有某个 key
    /// 检查字典里面是否有某个 key
    func has(_ key: Key) -> Bool {
        return index(forKey: key) != nil
    }

    // MARK: JSON字符串 -> 字典
    /// JsonString转为字典
    /// - Parameter json: JSON字符串
    /// - Returns: 字典
    static func jsonToDictionary(json: String) -> Dictionary<String, Any>? {
        if let data = (try? JSONSerialization.jsonObject(
            with: json.data(using: String.Encoding.utf8,
                            allowLossyConversion: true)!,
            options: JSONSerialization.ReadingOptions.mutableContainers)) as? Dictionary<String, Any> {
            return data
        } else {
            return nil
        }
    }

    // MARK: 字典 -> JSON字符串
    /// 字典转换为JSONString
    func toJSON() -> String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions()) {
            let jsonStr = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            return String(jsonStr ?? "")
        }
        return nil
    }
    
    // MARK: 字典里面所有的 key
    /// 字典里面所有的key
    /// - Returns: key 数组
    func allKeys() -> [Key] {
        /*
         shuffled：不会改变原数组，返回一个新的随机化的数组。  可以用于let 数组
         */
       return self.keys.shuffled()
    }
    
    // MARK: 字典里面所有的 value
    /// 字典里面所有的value
    /// - Returns: value 数组
    func allValues() -> [Value] {
        return self.values.shuffled()
    }
}
