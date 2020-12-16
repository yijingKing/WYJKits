/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ 
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit
import Foundation
import CommonCrypto

//MARK: --- 初始化
public extension String {
    //MARK: --- 多字符串初始化
    init?(_ strings: String...) {
        var total = ""
        for str in strings {
            total += str
        }
        self.init(format: "%@",total)
    }
    ///float -> string
    init?(_ float: Float?,_ significand: Int? = nil) {
        if let i = significand {
            self.init(String(format: "%.\(i)f", float ?? 0.00))
        } else {
            self.init(format: "%f", float ?? 0.0)
        }
    }
    ///double -> string
    init?(_ double: Double?,_ significand: Int? = nil) {
        if let i = significand {
            self.init(String(format: "%.\(i)f", double ?? 0.00))
        } else {
            self.init(format: "%f", double ?? 0.0)
        }
    }
    ///base64
    init?(base64: String) {
        let pad = String(repeating: "=", count: base64.length % 4)
        let base64Padded = base64 + pad
        if let decodedData = Data(base64Encoded: base64Padded, options: NSData.Base64DecodingOptions(rawValue: 0)),
           let decodedString = NSString(data: decodedData, encoding: String.Encoding.utf8.rawValue) {
            self.init(decodedString)
        } else {
            self.init("")
        }
        
    }
    ///时间戳创建时间字符串
    init?(timeInterval: Double,formatter: String) {
        let date = Date.init(timeIntervalSince1970: timeInterval / 1000)
        let dateStr = date.yi_toString(format: formatter)
        
        self.init(dateStr)
    }
    
}
//MARK: --- 功能
public extension String {
    //MARK: --- 异或
    ///异或
    func yi_xor (_ pinV: String) -> String {
        guard !self.isEmpty else { return "" }
        
        if self.count != pinV.count {
            QYLog("长度不匹配")
            return ""
        }
        var code = ""
        for i in 0 ..< self.length {
            let pan = self.yi_index(i,length: 1)
            let pin = pinV.yi_index(i,length: 1)
            let codes = self.creator(pan, pin)
            code = code + codes
        }
        return code
    }
    private func creator (_ pan: String,_ pin: String) -> String {
        
        var code = ""
        for i in 0 ..< pan.length {
            let pans = charToint(pan.utf8CString[i])
            let pins = charToint(pin.utf8CString[i])
            code = code.appendingFormat("%X", pans^pins)
        }
        return code
    }
    private func charToint (_ char: CChar) -> Int {
        if (char >= "0".utf8CString[0] && char <= "9".utf8CString[0]) {
            return Int(char) - Int("0".utf8CString[0])
        } else if (char >= "A".utf8CString[0] && char <= "F".utf8CString[0]) {
            return Int(char) - Int("A".utf8CString[0]) + 10
        } else if (char >= "a".utf8CString[0] && char <= "f".utf8CString[0]) {
            return Int(char) - Int("a".utf8CString[0]) + 10
        }
        return 0
    }
    //MARK: --- 获取文本高度
    /// 获取文本高度
    func yi_getHeight(_ font : UIFont = UIFont.systemFont(ofSize: 18), fixedWidth : CGFloat) -> CGFloat {
        guard !self.isEmpty && fixedWidth > 0 else {
            return 0
        }
        
        let size = CGSize(width:fixedWidth, height:CGFloat.greatestFiniteMagnitude)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [.font : font], context:nil)
        return rect.size.height
    }
    //MARK: --- 获取文本宽度
    /// 获取文本宽度
    func yi_getWidth(_ font : UIFont = UIFont.systemFont(ofSize: 18)) -> CGFloat {
        guard !self.isEmpty else { return 0 }
        
        let size = CGSize(width:CGFloat.greatestFiniteMagnitude, height:0)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [.font : font], context:nil)
        return rect.size.width
    }
}
//MARK: --- 截取  插入  删除  添加
public extension String {
    ///开始结束
    func yi_index(_ start: Int ,_ stop: Int) -> String {
        guard !self.isEmpty else { return "" }
        
        let string = self
        let index1 = string.index(string.startIndex, offsetBy: start)
        let index2 = string.index(string.startIndex, offsetBy: stop)
        return String(string[index1..<index2])
    }
    
    ///从哪到之后长度
    func yi_index(_ start: Int ,length: Int) -> String {
        guard !self.isEmpty else { return "" }
        
        let string = self
        let index1 = string.index(string.startIndex, offsetBy: start)
        let index2 = string.index(string.startIndex, offsetBy: start + length)
        return String(string[index1..<index2])
    }
    
    ///开始到i
    func yi_index(to i: Int) -> String {
        guard !self.isEmpty else { return "" }
        
        let string = self
        let index = string.index(startIndex, offsetBy: i)
        return String(string[index])
    }
    
    ///从i到结束
    func yi_index(after i: Int) -> String {
        guard !self.isEmpty else { return "" }
        
        let string = self
        let index1 = string.index(string.startIndex, offsetBy: i)
        let index2 = string.index(string.endIndex, offsetBy: 0)
        return String(string[index1..<index2])
    }
    
    ///截取range
    func yi_index(_ range: Range<Int>) -> String {
        guard !self.isEmpty else { return "" }
        
        let string = self
        let start = string.index(startIndex, offsetBy: range.lowerBound)
        let end = string.index(startIndex, offsetBy: range.upperBound)
        return String(string[start..<end])
    }
    
    ///截取closedrange
    func yi_index(closedRange: ClosedRange<Int>) -> String {
        guard !self.isEmpty else { return "" }
        
        let string = self
        return string.yi_index(closedRange.lowerBound..<(closedRange.upperBound + 1))
    }
    
    ///count
    private var length: Int {
        return self.count
    }
    
    ///替换指定范围内的字符串
    /// - Parameters:
    ///   - index: 起点
    ///   - length: 长度
    ///   - replac: 替换字符
    ///   - cycle: 是否循环插入替换字符串
    /// - Returns: 新字符串
    mutating func yi_replacing(index:Int,length:Int,replac:String,_ cycle: Bool? = nil) -> String {
        guard !self.isEmpty else { return "" }
        
        var string = self
        let count = self.count
        let startIndex = string.index(string.startIndex, offsetBy: index)
        string.replaceSubrange(startIndex..<string.index(startIndex, offsetBy: length), with: replac)
        if cycle ?? false {
            while count <= string.count {
                string = string.yi_insert(replac, index: index)
            }
            return string
        }
        return string
    }
    
    /// 替换字符串
    /// - Parameters:
    ///   - of: 字符串
    ///   - with: 替换的字符串
    ///   - option: 可以用来指定一个选项标记（这个标记可以作为替换的条件)
    ///   - range: 指定一个替换的范围
    func yi_replacingOccurrences(_ of: String,_ with: String,option: String.CompareOptions = [],range: Range<Self.Index>? = nil) -> String {
        guard !self.isEmpty else { return "" }
        
        let string = self
        let s = string.replacingOccurrences(of: of, with: with, options: option, range: range)
        return s
    }
    /// 替换字符串
    /// - Parameters:
    ///   - range: 范围
    ///   - with: 替换字符串
    func yi_replacingCharacters(_ range: NSRange,_ with: String) -> String {
        guard !self.isEmpty else { return "" }
        
        let string = self
        return (string as NSString).replacingCharacters(in: range, with: with)
    }
    ///删除第一个字符
    mutating func yi_deleteFirst() -> String {
        guard !self.isEmpty else { return "" }
        
        var string = self
        string.remove(at: string.index(before: string.startIndex))
        return string
    }
    ///删除最后一个字符
    mutating func yi_deleteLast() -> String {
        guard !self.isEmpty else { return "" }
        
        var string = self
        string.remove(at: string.index(before: string.endIndex))
        return string
    }
    /// 删除指定字符串
    mutating func yi_delete(_ text: String) -> String {
        guard !self.isEmpty else { return "" }
        
        let string = self
        return string.replacingOccurrences(of: text, with: "")
    }
    ///字符串的插入
    mutating func yi_insert(_ text: String, index: Int) -> String {
        guard !self.isEmpty else { return "" }
        
        var string = self
        let start = string.index(string.startIndex, offsetBy: index)
        string.insert(contentsOf: text, at: start)
        return string
    }
    /// 将字符串通过特定的字符串拆分为字符串数组
    func yi_components(_ text: String) -> [String] {
        guard !self.isEmpty else { return [] }
        
        let string = self
        return NSString(string: string).components(separatedBy: text)
    }
    ///去除前后的换行和空格
    func yi_removeSapce() -> String {
        guard !self.isEmpty else { return "" }
        
        let string = self
        var resultString = string.trimmingCharacters(in: CharacterSet.whitespaces)
        resultString = resultString.trimmingCharacters(in: CharacterSet.newlines)
        return resultString
    }
    ///获取某个字符串在总字符串的位置
    func yi_positionOf(_ sub: String,_ backwards: Bool = false)->Int {
        guard !self.isEmpty else { return -1 }
        
        let string = self
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = string.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
}

//MARK: --- 转换
public extension String {
    //MARK: --- 数据类型
    /// Int
    func yi_toInt() -> Int? {
        guard !self.isEmpty else { return nil }
        
        return NSDecimalNumber.init(string: String(format: "%@", self)).intValue
    }
    /// Number
    func yi_toNumber() -> NSNumber? {
        guard !self.isEmpty else { return nil }
        
        return NSNumber.init(value: NSDecimalNumber.init(string: String(format: "%@", self)).intValue)
    }
    /// Double
    func yi_toDouble() -> Double? {
        guard !self.isEmpty else { return nil }
        
        return NSDecimalNumber.init(string: String(format: "%@", self)).doubleValue
    }
    /// Float
    func yi_toFloat() -> Float? {
        guard !self.isEmpty else { return nil }
        
        return NSDecimalNumber.init(string: String(format: "%@", self)).floatValue
    }
    /// Bool
    func yi_toBool() -> Bool? {
        guard !self.isEmpty else { return nil }
        
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if trimmedString == "true" || trimmedString == "false" {
            return (trimmedString as NSString).boolValue
        }
        return nil
    }
    //MARK: --- 时间
    ///string --> date
    func yi_toDate(from dateFormat: String,_ timeZone: TimeZone = NSTimeZone.system) -> Date? {
        guard !self.isEmpty else { return nil }
        
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        formatter.timeZone = timeZone
        let date = formatter.date(from: self)
        return date
    }
    ///string --> date
    func yi_toDate(_ dateFormat: QYDateFormatter,_ timeZone: TimeZone = NSTimeZone.system) -> Date? {
        guard !self.isEmpty else { return nil }
        
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat.rawValue
        formatter.timeZone = timeZone
        let date = formatter.date(from: self)
        return date
    }
    /// 字符串转时间戳
    func yi_toStampTime(_ mode: QYDateFormatter = .dateModeYMDHMS) -> Int {
        guard !self.isEmpty else { return 0 }
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = mode.rawValue
        let current = dateFormatter.date(from: self)
        let date = Date.init(timeInterval: 0, since: current ?? Date())
        let stamp = date.timeIntervalSince1970
        return Int(stamp)
    }
    
    //MARK: --- json转换
    /// JSONString转换为字典
    func yi_toDictionary() -> [String:Any]? {
        guard !self.isEmpty else { return nil }
        
        guard let jsonData:Data = self.data(using: .utf8) else {
            QYLog("json转dict失败")
            return nil
        }
        if let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
            return dict as? [String : Any] ?? ["":""]
        }
        QYLog("json转dict失败")
        return nil
    }
    /// JSONString转换为data
    func yi_toData(_ using: String.Encoding = .utf8) -> Data? {
        guard !self.isEmpty else { return nil }
        
        let data = self.data(using: using)
        return data
    }
    
    //MARK: --- 进制
    ///十六进制转数字
    func yi_hexToInt() -> Int {
        guard !self.isEmpty else { return 0 }
        
        let str = self.uppercased()
        var sum = 0
        for i in str.utf8 {
            // 0-9 从48开始
            sum = sum * 16 + Int(i) - 48
            // A-Z 从65开始，但有初始值10，所以应该是减去55
            if i >= 65 {
                sum -= 7
            }
        }
        return sum
    }
    ///十六进制转换为普通字符串
    func yi_hexToString() -> String {
        guard !self.isEmpty else { return "" }
        
        var bytes = [UInt8]()
        var dataBStr: String = ""
        for (index, _) in self.enumerated(){
            let fromIndex = index * 2
            let toIndex = index * 2 + 1
            if toIndex > (self.count - 1) {
                break
            }
            let hexCharStr = self.yi_index(fromIndex, 2)
            var r:CUnsignedInt = 0
            Scanner(string: hexCharStr).scanHexInt32(&r)
            bytes.append(UInt8(r))
        }
        dataBStr = String.init(data: Data(bytes), encoding: String.Encoding.ascii) ?? ""
        return dataBStr
    }
    ///普通字符串转换为十六进制
    func yi_toHexString() -> String {
        guard !self.isEmpty else { return "" }
        
        let strData = self.data(using: String.Encoding.utf8)
        let bytes = [UInt8](strData!)
        var sumString: String = ""
        for byte in bytes {
            let newString = String(format: "%x",byte&0xff)
            if newString.count == 1 {
                sumString = String(format: "%@0%@",sumString,newString)
            }else{
                sumString = String(format: "%@%@",sumString,newString)
            }
        }
        return sumString
    }
    //MARK: --- 加密
    /// base64
    func yi_toBase64 (_ options: Data.Base64EncodingOptions? = nil) -> String {
        guard !self.isEmpty else { return "" }
        
        let plainData = (self as NSString).data(using: String.Encoding.utf8.rawValue)
        var base64String = ""
        if let data = plainData {
            if let option = options {
                base64String = data.base64EncodedString(options: option)
            } else {
                base64String = data.base64EncodedString()
            }
        }
        return base64String
    }
    ///转成byte数组
    func yi_toBytes() -> [UInt8] {
        guard !self.isEmpty else { return [] }
        
        let strData = self.data(using: String.Encoding.utf8)! as NSData
        let count = self.count / MemoryLayout<UInt8>.size
        var bytesArray = [UInt8](repeating: 0, count: count)
        strData.getBytes(&bytesArray, length:count * MemoryLayout<UInt8>.size)
        return bytesArray
    }
    ///md5 字符串加密
    func yi_md5() -> String {
        guard !self.isEmpty else { return "" }
        
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
    ///encode
    func yi_encoded(_ charactersIn: String? = nil) -> String {
        guard !self.isEmpty else { return self }
        
        var customAllowedSet = NSCharacterSet.alphanumerics
        if let characters = charactersIn {
            ///"!*'();:@&=+$,/?%#[]"
            customAllowedSet =  NSCharacterSet(charactersIn:characters).inverted
        }
        let st = (self as NSString).addingPercentEncoding(withAllowedCharacters: customAllowedSet)
        return st ?? ""
    }
    
    ///url
    func yi_toUrl() -> URL? {
        guard !self.isEmpty else { return nil }
        
        return URL(string: self)
    }
    
    ///图片
    func yi_toUrlImage() -> UIImage? {
        guard !self.isEmpty else { return nil }
        
        var image: UIImage?
        if self.length <= 0 {
            return nil
        }
        if let url = URL.init(string: self),let data = try? Data(contentsOf: url) {
            image = UIImage.init(data: data)
        }
        return image
    }
    
    
    ///NSAttributedString
    func yi_toAttributedString() -> NSAttributedString {
        
        return NSAttributedString.init(string: self)
    }
    
    // MARK: 5.1、将金额字符串转化为带逗号的金额 按照千分位划分，如  "1234567" => 1,234,567   1234567.56 => 1,234,567.56
    /// 将金额字符串转化为带逗号的金额 按照千分位划分，如  "1234567" => 1,234,567   1234567.56 => 1,234,567.56
    func yi_toThousands() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .floor
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        if self.contains(".") {
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 1
            formatter.minimumIntegerDigits = 1
        }
        var num = NSDecimalNumber(string: self)
        if num.doubleValue.isNaN {
            num = NSDecimalNumber(string: "0")
        }
        let result = formatter.string(from: num)
        return result
    }
}

//MARK: --- 大小写
public extension String {
    ///转为大写
    func yi_uppercased(_ locale: Locale) -> String {
        guard !self.isEmpty else { return "" }
        
        let string = self
        return string.uppercased(with: locale)
    }
    ///转为小写
    func yi_lowercased(_ locale: Locale) -> String {
        guard !self.isEmpty else { return "" }
        
        let string = self
        return string.lowercased(with: locale)
    }
    ///大写字符串的第“计数”字符
    mutating func yi_uppercasePrefix(_ count: Int) -> String {
        guard !self.isEmpty && count > 0 else { return self }
        
        var string = self
        string.replaceSubrange(startIndex..<string.index(startIndex, offsetBy: min(count, length)),
                             with: String(string[startIndex..<string.index(startIndex, offsetBy: min(count, length))]).uppercased())
        return string
    }
    ///大写首'计数'字符的字符串
    func yi_uppercasedPrefix(_ count: Int) -> String {
        guard !self.isEmpty && count > 0 else { return self }
        var result = self
        result.replaceSubrange(startIndex..<result.index(startIndex, offsetBy: min(count, length)),
                               with: String(result[startIndex..<result.index(startIndex, offsetBy: min(count, length))]).uppercased())
        return result
    }
    ///字符串的最后“计数”字符，返回一个新字符串
    func yi_uppercasedSuffix(_ count: Int) -> String {
        guard !self.isEmpty && count > 0 else { return self }
        var result = self
        result.replaceSubrange(result.index(endIndex, offsetBy: -min(count, length))..<endIndex,
                               with: String(result[result.index(endIndex, offsetBy: -min(count, length))..<endIndex]).uppercased())
        return result
    }
    ///范围内大写
    func yi_uppercased(range: CountableRange<Int>) -> String {
        guard !self.isEmpty else { return self }
        let from = max(range.lowerBound, 0), to = min(range.upperBound, length)
        guard self.count > 0 && (0..<length).contains(from) else { return self }
        var result = self
        result.replaceSubrange(result.index(startIndex, offsetBy: from)..<result.index(startIndex, offsetBy: to),
                               with: String(result[result.index(startIndex, offsetBy: from)..<result.index(startIndex, offsetBy: to)]).uppercased())
        return result
    }
    ///首字母小写
    func yi_lowercasedFirst() -> String {
        guard !self.isEmpty else { return self }
        var result = self
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).lowercased())
        return result
    }
    ///小写字符串的第一个“计数”字符
    func yi_lowercasedPrefix(_ count: Int) -> String {
        guard !self.isEmpty && count > 0 else { return self }
        var result = self
        result.replaceSubrange(startIndex..<result.index(startIndex, offsetBy: min(count, length)),
                               with: String(result[startIndex..<result.index(startIndex, offsetBy: min(count, length))]).lowercased())
        return result
    }
    ///字符串的最后“计数”字符小写
    func yi_lowercasedSuffix(_ count: Int) -> String {
        guard !self.isEmpty && count > 0 else { return self }
        var result = self
        result.replaceSubrange(result.index(endIndex, offsetBy: -min(count, length))..<endIndex,
                               with: String(result[result.index(endIndex, offsetBy: -min(count, length))..<endIndex]).lowercased())
        return result
    }
    
}

public extension String {
    ///是否是手机
    var yi_isPhone: Bool {
        guard !self.isEmpty else { return false }
        
        return QYRegular.yi_isPhoneNumber(self)
    }
    ///是否是身份证
    var yi_isIdCard: Bool {
        guard !self.isEmpty else { return false }
        
        return QYRegular.yi_isIdCard(self)
    }
    ///是否是纯数字
    var yi_isNumber: Bool {
        guard !self.isEmpty else { return false }
        
        return QYRegular.yi_isNumber(self)
    }
}
