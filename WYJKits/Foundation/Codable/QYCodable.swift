/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import UIKit
import Foundation

public enum QYCodableError: Error {
    ///json转model失败
    case jsonToModelFail
    ///json转data失败
    case jsonToDataFail
    ///字典转json失败
    case dicToJsonFail
    ///json转数组失败
    case jsonToArrFail
    ///model转json失败
    case modelToJsonFail
}


public protocol QYCodable: Codable {
    init(from decoder: String?) throws
    init(from decoder: Dictionary<String,Any>?) throws
}
public extension QYCodable {
    init(from decoder: String?) throws {
        self = try Self.yi_init(decoder)
    }
    init(from decoder: Dictionary<String,Any>?) throws {
        self = try Self.yi_init(decoder)
    }
}
public extension QYCodable {
    
    ///模型转字典
    func yi_toDic() -> [String:Any] {
        let mirro = Mirror(reflecting: self)
        var dict = [String:Any]()
        for case let (key?, value) in mirro.children {
            dict[key] = value
        }
        return dict
    }
    
    ///model 转 json
    func yi_toJSONString () throws -> String {
        if let jsonData = try? JSONEncoder().encode(self) {
            if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                return jsonString
            }
        }
        throw QYCodableError.dicToJsonFail
    }
    ///dic 转 model
    static func yi_init<T : QYCodable>(_ dic: Dictionary<String, Any>?) throws -> T {
        
        guard let JSONString = dic?.yi_toJSONString() else {
            throw QYCodableError.dicToJsonFail
        }
        guard let jsonData = JSONString.data(using: .utf8) else {
            throw QYCodableError.jsonToDataFail
        }
        let decoder = JSONDecoder()
        do {
            let obj = try decoder.decode(T.self, from: jsonData)
            return obj
        }catch {
            QYLog(error)
        }
        throw QYCodableError.jsonToModelFail
    }
    ///jsonstring 转 model
    static func yi_init<T : QYCodable>(_ json: String?) throws -> T {
        
        guard let jsonData = json?.data(using: .utf8) else {
            throw QYCodableError.jsonToDataFail
        }
        let decoder = JSONDecoder()
        do {
            let obj = try decoder.decode(T.self, from: jsonData)
            return obj
        }catch {
            QYLog(error)
        }
        throw QYCodableError.jsonToModelFail
    }
}


