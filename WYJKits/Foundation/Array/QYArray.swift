/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation
public extension Array {
    /// 转data
    func yi_toData(_ options: JSONSerialization.WritingOptions = []) -> Data? {
        
        guard JSONSerialization.isValidJSONObject(self) else {
            QYLog("数组转data失败")
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: options) else {
            QYLog("数组转data失败")
            return nil
        }
        
        return data
    }
    
    func yi_toJSONString(_ options: JSONSerialization.WritingOptions = []) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else {
            QYLog("dic转json失败")
            return nil
        }
        guard let newData : Data = try? JSONSerialization.data(withJSONObject: self, options: options) else {
            QYLog("dic转json失败")
            return nil
        }
        let JSONString = NSString(data:newData as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString as String? ?? nil
    }
    
}
//MARK: --- 类型转换
public extension Array where Element == UInt8 {
    init(reserveCapacity: Int) {
        self = Array<Element>()
        self.reserveCapacity(reserveCapacity)
    }
    
    var slice: ArraySlice<Element> {
        return self[self.startIndex ..< self.endIndex]
    }
    
    init(hex: String) {
        self.init(reserveCapacity: hex.unicodeScalars.lazy.underestimatedCount)
        var buffer: UInt8?
        var skip = hex.hasPrefix("0x") ? 2: 0
        for char in hex.unicodeScalars.lazy {
            guard skip == 0 else {
                skip -= 1
                continue
            }
            guard char.value >= 48 && char.value <= 102 else {
                removeAll()
                return
            }
            let v: UInt8
            let c: UInt8 = UInt8(char.value)
            switch c {
            case let c where c <= 57:
                v = c - 48
            case let c where c >= 65 && c <= 70:
                v = c - 55
            case let c where c >= 97:
                v = c - 87
            default:
                removeAll()
                return
            }
            if let b = buffer {
                append(b << 4 | v)
                buffer = nil
            } else {
                buffer = v
            }
        }
        if let b = buffer {
            append(b)
        }
    }
    ///转十六进制
    func yi_toHexString() -> String {
        return `lazy`.reduce("") {
            var s = String($1, radix: 16)
            if s.count == 1 {
                s = "0" + s
            }
            return $0 + s
        }
    }
}
//MARK: --- 功能
public extension Array where Element : Equatable{
    ///去掉重复的元素
    func yi_removedDuplicates() -> [Element] {
        var uniqueValues: [Element] = self
        forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        return uniqueValues
    }
    
    ///移除对象
    mutating func yi_remove(_ object: Element) {
        if let index = firstIndex(of: object) {
             remove(at: index)
        }
     }
    ///下标获取
    subscript(input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
                result.append(self[i])
            }
            return result
        }
        set {
            for (index,i) in input.enumerated() {
                self[i] = newValue[index]
            }
        }
    }
    ///多下标获取
    func yi_indexs(_ input: [Int]) -> Array {
        var result = Array()
        for i in input {
            result.append(self[i])
        }
        return result
    }
}
