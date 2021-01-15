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
}
