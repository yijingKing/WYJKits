/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import UIKit
// MARK:- 一、基本的扩展
public extension WYJProtocol where T: UserDefaults {
  
    // MARK: 存值
    /// 存值
    /// - Parameters:
    ///   - value: 值
    ///   - key: 键
    @discardableResult
    static func setValue(value: Any?, key: String?) -> Bool {
        guard let v = value,let k = key else {
            return false
        }
        UserDefaults.standard.set(v, forKey: k)
        UserDefaults.standard.synchronize()
        return true
    }
    
    // MARK: 取值
    /// 取值
    /// - Parameter key: 键
    /// - Returns: 返回值
    static func getValue(key: String?) -> Any? {
        guard let k = key, let result = UserDefaults.standard.value(forKey: k) else {
            return nil
        }
        return result
    }
    
    
    /// 移除所有值
    static func removeAll() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
    
    /// 移除单个值
    /// - Parameter key: 键名
    static func remove(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
}

// MARK: 模型持久化
public extension WYJProtocol where T: UserDefaults {
    
    // MARK: 存储模型
    /// 存储模型
    /// - Parameters:
    ///   - object: 模型
    ///   - key: 对应的key
    static func setItem<T: Decodable & Encodable>(_ object: T, forKey key: String) {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(object) else {
            return
        }
        UserDefaults.standard.set(encoded, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: 取出模型
    /// 取出模型
    /// - Parameters:
    ///   - type: 当时存储的类型
    ///   - key: 对应的key
    /// - Returns: 对应类型的模型
    static func getItem<T: Decodable & Encodable>(_ type: T.Type, forKey key: String) -> T? {
        
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        let decoder = JSONDecoder()
        guard let object = try? decoder.decode(type, from: data) else {
            WYJLog("Couldnt find key")
            return nil
        }
        return object
    }
}
