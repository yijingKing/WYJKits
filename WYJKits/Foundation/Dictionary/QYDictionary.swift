/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation

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
    ///转json
    func yi_toJSONString(_ options: JSONSerialization.WritingOptions = []) -> String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            QYLog("dic转json失败")
            return ""
        }
        if let newData : Data = try? JSONSerialization.data(withJSONObject: self, options: options) {
            if let JSONString = NSString(data:newData as Data,encoding: String.Encoding.utf8.rawValue) {
                return JSONString as String
            }
        }
        QYLog("dic转json失败")
        return ""
    }
    
    /// 字典转二进制
    func yi_toData(_ options: JSONSerialization.WritingOptions = .prettyPrinted) -> Data? {
        
        if (!JSONSerialization.isValidJSONObject(self)) {
            QYLog("字典转二进制失败")
            return Data()
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: options)
            return data
        } catch let error {
            QYLog(error)
        }
        return nil
    }
}
