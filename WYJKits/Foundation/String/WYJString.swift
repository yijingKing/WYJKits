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
        let dateStr = date.yi.toString(format: formatter)
        
        self.init(dateStr)
    }
    
}
//MARK: --- 功能
public extension WYJProtocol where T == String {
    //MARK: --- 异或
    ///异或
    func xor (_ pinV: String) -> String {
        guard !obj.isEmpty else { return "" }
        
        if obj.count != pinV.count {
            WYJLog("长度不匹配")
            return ""
        }
        var code = ""
        for i in 0 ..< obj.length {
            let pan = index(i,length: 1)
            let pin = pinV.yi.index(i,length: 1)
            let codes = obj.creator(pan, pin)
            code = code + codes
        }
        return code
    }
    //MARK: --- 获取文本高度
    /// 获取文本高度
    func getHeight(_ font : UIFont = UIFont.systemFont(ofSize: 18), fixedWidth : CGFloat) -> CGFloat {
        guard !obj.isEmpty && fixedWidth > 0 else {
            return 0
        }
        let size = CGSize(width:fixedWidth, height:CGFloat.greatestFiniteMagnitude)
        let text = obj as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [.font : font], context:nil)
        return rect.size.height
    }
    //MARK: --- 获取文本宽度
    /// 获取文本宽度
    func getWidth(_ font : UIFont = UIFont.systemFont(ofSize: 18)) -> CGFloat {
        guard !obj.isEmpty else { return 0 }
        
        let size = CGSize(width:CGFloat.greatestFiniteMagnitude, height:0)
        let text = obj as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [.font : font], context:nil)
        return rect.size.width
    }
    
    /// UUID
    static func UUID() -> String? {
        let uuid = CFUUIDCreate(kCFAllocatorDefault)
        let cfString = CFUUIDCreateString(kCFAllocatorDefault, uuid)
        return cfString as String?
    }
}

//MARK: --- 截取  插入  删除  添加
public extension WYJProtocol where T == String {
    ///开始结束
    func index(_ start: Int ,_ stop: Int) -> String {
        guard !obj.isEmpty else {
            WYJLog("字符串为空")
            return ""
        }
        let string = obj
        let index1 = string.index(string.startIndex, offsetBy: start)
        let index2 = string.index(string.startIndex, offsetBy: stop)
        return String(string[index1..<index2])
    }
    
    ///从哪到之后长度
    func index(_ start: Int ,length: Int) -> String {
        guard !obj.isEmpty else { return "" }
        
        let string = obj
        let index1 = string.index(string.startIndex, offsetBy: start)
        let index2 = string.index(string.startIndex, offsetBy: start + length)
        return String(string[index1..<index2])
    }
    
    ///开始到i
    func index(to i: Int) -> String {
        guard !obj.isEmpty else { return "" }
        
        let string = obj
        let index = string.index(string.startIndex, offsetBy: i)
        return String(string[string.startIndex..<index])
    }
    
    ///从i到结束
    func index(after i: Int) -> String {
        guard !obj.isEmpty else { return "" }
        
        let string = obj
        let index1 = string.index(string.startIndex, offsetBy: i)
        let index2 = string.index(string.endIndex, offsetBy: 0)
        return String(string[index1..<index2])
    }
    
    ///截取range
    func index(_ range: Range<Int>) -> String {
        guard !obj.isEmpty else { return "" }
        
        let string = obj
        let start = string.index(string.startIndex, offsetBy: range.lowerBound)
        let end = string.index(string.startIndex, offsetBy: range.upperBound)
        return String(string[start..<end])
    }
    
    ///替换指定范围内的字符串
    /// - Parameters:
    ///   - index: 起点
    ///   - length: 长度
    ///   - replac: 替换字符
    ///   - cycle: 是否循环插入替换字符串
    /// - Returns: 新字符串
    func replacing(index:Int, length:Int, replac:String,_ cycle: Bool? = nil) -> String {
        guard !obj.isEmpty else { return "" }
        
        var string = obj
        let count = obj.count
        let startIndex = string.index(string.startIndex, offsetBy: index)
        string.replaceSubrange(startIndex..<string.index(startIndex, offsetBy: length), with: replac)
        if cycle ?? false {
            while count < string.count {
                string = string.yi.insert(replac, index: index)
            }
            return string
        }
        return string
    }
    /// 替换字符串
    /// - Parameters:
    ///   - range: 范围
    ///   - with: 替换字符串
    func replacingCharacters(_ range: NSRange,_ with: String) -> String {
        guard !obj.isEmpty else { return "" }
        
        let string = obj
        return (string as NSString).replacingCharacters(in: range, with: with)
    }
    ///删除第一个字符
    func deleteFirst() -> String {
        guard !obj.isEmpty else { return "" }
        
        var string = obj
        string.remove(at: string.index(before: string.startIndex))
        return string
    }
    ///删除最后一个字符
    func deleteLast() -> String {
        guard !obj.isEmpty else { return "" }
        
        var string = obj
        string.remove(at: string.index(before: string.endIndex))
        return string
    }
    /// 删除指定字符串
    func delete(_ text: String) -> String {
        guard !obj.isEmpty else { return "" }
        
        let string = obj
        return string.replacingOccurrences(of: text, with: "")
    }
    ///字符串的插入
    func insert(_ text: String, index: Int) -> String {
        guard !obj.isEmpty else { return "" }
        
        var string = obj
        let start = string.index(string.startIndex, offsetBy: index)
        string.insert(contentsOf: text, at: start)
        return string
    }
    /// 将字符串通过特定的字符串拆分为字符串数组
    func components(_ text: String) -> [String] {
        guard !obj.isEmpty else { return [] }
        
        let string = obj
        return NSString(string: string).components(separatedBy: text)
    }
    ///去除前后的换行和空格
    func removeSapce() -> String {
        guard !obj.isEmpty else { return "" }
        
        let string = obj
        var resultString = string.trimmingCharacters(in: CharacterSet.whitespaces)
        resultString = resultString.trimmingCharacters(in: CharacterSet.newlines)
        return resultString
    }
    
    /// 替换
    /// - Parameters:
    ///   - before: 保留前几位
    ///   - after: 保留后几位
    ///   - text:  替换的文本
    /// - Returns: 替换后的字符串
    func replac(beforeFew before: Int,afterFew after: Int, _ text: String? = nil) -> String? {
        let phone = obj
        var tempStr = ""
        let replacText = text ?? "*"
        while tempStr.count < phone.count - before - after {
            tempStr = tempStr + replacText
        }
        return phone.yi.index(to: before) + tempStr + phone.yi.index(after: phone.count - after)
    }
    
    /// 银行卡替换
    /// - Parameters:
    ///   - before: 保留前几位
    ///   - after: 保留后几位
    ///   - text:  替换的文本
    /// - Returns: 替换后的字符串
    func replacCard(beforeFew before: Int,afterFew after: Int, _ text: String? = nil) -> String? {
        var idCardNumber = obj
        var tempStr = ""
        let replacText = text ?? "*"
        while tempStr.count < idCardNumber.count - before - after {
            tempStr = tempStr + replacText
        }
        idCardNumber = idCardNumber.yi.index(to: before) + tempStr + idCardNumber.yi.index(after: idCardNumber.count - after)
        let nu = idCardNumber.count / 4
        var i = 1
        while i <= nu {
            idCardNumber = idCardNumber.yi.insert(" ", index: 4 * i + i - 1)
            i += 1
        }
        
        return idCardNumber
    }
}

//MARK: --- 转换
public extension WYJProtocol where T == String {
    //MARK: --- 数据类型
    /// Int
    func toInt() -> Int? {
        guard !obj.isEmpty else { return nil }
        
        return NSDecimalNumber.init(string: String(format: "%@", obj)).intValue
    }
    
    /// Number
    func toNumber() -> NSNumber? {
        guard !obj.isEmpty else { return nil }
        
        return NSNumber.init(value: NSDecimalNumber.init(string: String(format: "%@", obj)).intValue)
    }
    
    /// Double
    func toDouble() -> Double? {
        guard !obj.isEmpty else { return nil }
        
        return NSDecimalNumber.init(string: String(format: "%@", obj)).doubleValue
    }
    
    /// Float
    func toFloat() -> Float? {
        guard !obj.isEmpty else { return nil }
        
        return NSDecimalNumber.init(string: String(format: "%@", obj)).floatValue
    }
    
    /// Bool
    func toBool() -> Bool? {
        guard !obj.isEmpty else { return nil }
        
        let trimmedString = obj.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if trimmedString == "true" || trimmedString == "false" {
            return (trimmedString as NSString).boolValue
        }
        return nil
    }
    
    //MARK: --- 时间
    ///string --> date
    func toDate(from dateFormat: String,_ timeZone: TimeZone = NSTimeZone.system) -> Date? {
        guard !obj.isEmpty else { return nil }
        
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        formatter.timeZone = timeZone
        let date = formatter.date(from: obj)
        return date
    }
    
    ///string --> date
    func toDate(_ dateFormat: WYJDateFormatter,_ timeZone: TimeZone = NSTimeZone.system) -> Date? {
        guard !obj.isEmpty else { return nil }
        
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat.rawValue
        formatter.timeZone = timeZone
        let date = formatter.date(from: obj)
        return date
    }
    
    /// 字符串转时间戳
    func toStampTime(_ mode: WYJDateFormatter = .dateModeYMDHMS) -> Int {
        guard !obj.isEmpty else { return 0 }
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = mode.rawValue
        let current = dateFormatter.date(from: obj)
        let date = Date.init(timeInterval: 0, since: current ?? Date())
        let stamp = date.timeIntervalSince1970
        return Int(stamp)
    }
    
    //MARK: --- json转换
    /// JSONString转换为字典
    func toDictionary() -> [String:Any]? {
        guard !obj.isEmpty else { return nil }
        
        guard let jsonData:Data = obj.data(using: .utf8) else {
            WYJLog("json转dict失败")
            return nil
        }
        guard let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
            WYJLog("json转dict失败")
            return nil
        }
        return dict as? [String : Any]
    }
    
    /// JSONString转换为data
    func toData(_ using: String.Encoding = .utf8) -> Data? {
        guard !obj.isEmpty else { return nil }
        
        let data = obj.data(using: using)
        return data
    }
    
    ///转成json
    func toJSON() -> WYJJSON? {
        guard !obj.isEmpty else { return nil }
        return WYJJSON.init(obj)
    }
    
    //MARK: --- 进制
    ///十六进制转数字
    func hexToInt() -> Int {
        guard !obj.isEmpty else { return 0 }
        
        let str = obj.uppercased()
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
    func hexToString() -> String {
        guard !obj.isEmpty else { return "" }
        
        var bytes = [UInt8]()
        var dataBStr: String = ""
        for (index, _) in obj.enumerated(){
            let fromIndex = index * 2
            let toIndex = index * 2 + 1
            if toIndex > (obj.count - 1) {
                break
            }
            let hexCharStr = self.index(fromIndex, 2)
            var r:CUnsignedInt = 0
            Scanner(string: hexCharStr).scanHexInt32(&r)
            bytes.append(UInt8(r))
        }
        dataBStr = String.init(data: Data(bytes), encoding: String.Encoding.ascii) ?? ""
        return dataBStr
    }
    
    ///普通字符串转换为十六进制
    func toHexString() -> String {
        guard !obj.isEmpty else { return "" }
        
        let strData = obj.data(using: String.Encoding.utf8)
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
    func toBase64 (_ options: Data.Base64EncodingOptions? = nil) -> String {
        guard !obj.isEmpty else { return "" }
        
        let plainData = (obj as NSString).data(using: String.Encoding.utf8.rawValue)
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
    func toBytes() -> [UInt8] {
        guard !obj.isEmpty else { return [] }
        
        let strData = obj.data(using: String.Encoding.utf8)! as NSData
        let count = obj.count / MemoryLayout<UInt8>.size
        var bytesArray = [UInt8](repeating: 0, count: count)
        strData.getBytes(&bytesArray, length:count * MemoryLayout<UInt8>.size)
        return bytesArray
    }
    
    ///md5 字符串加密
    func md5() -> String {
        guard !obj.isEmpty else { return "" }
        
        let str = obj.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(obj.lengthOfBytes(using: String.Encoding.utf8))
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
    func encoded(_ charactersIn: String? = nil) -> String? {
        guard !obj.isEmpty else { return obj }
        
        var customAllowedSet = NSCharacterSet.alphanumerics
        if let characters = charactersIn {
            ///"!*'();:@&=+$,/?%#[]"
            customAllowedSet =  NSCharacterSet(charactersIn:characters).inverted
        }
        let st = (obj as NSString).addingPercentEncoding(withAllowedCharacters: customAllowedSet)
        return st
    }
    
    ///url
    func toUrl() -> URL? {
        guard !obj.isEmpty else { return nil }
        
        return URL(string: obj)
    }
    
    ///图片
    func toUrlImage() -> UIImage? {
        guard !obj.isEmpty else { return nil }
        
        if obj.length <= 0 {
            return nil
        }
        guard let url = URL.init(string: obj) else {
            return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return UIImage.init(data: data)
    }
    
    ///NSAttributedString
    func toAttributedString() -> NSAttributedString {
        
        return NSAttributedString.init(string: obj)
    }
    
    // MARK: 将金额字符串转化为带逗号的金额 按照千分位划分，如  "1234567" => 1,234,567   1234567.56 => 1,234,567.56
    /// 将金额字符串转化为带逗号的金额 按照千分位划分，如  "1234567" => 1,234,567   1234567.56 => 1,234,567.56
    func toThousands() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .floor
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        if obj.contains(".") {
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 1
            formatter.minimumIntegerDigits = 1
        }
        var num = NSDecimalNumber(string: obj)
        if num.doubleValue.isNaN {
            num = NSDecimalNumber(string: "0")
        }
        formatter.usesGroupingSeparator = true //设置用组分隔
        formatter.groupingSeparator = "," //分隔符号
        formatter.groupingSize = 4 //分隔位数
        let result = formatter.string(from: num)
        return result
    }
    
    // MARK:字符串转 UIViewController
    /// 字符串转 UIViewController
    /// - Returns: 对应的控制器
    @discardableResult
    func toViewController() -> UIViewController? {
        // 1.获取类
        guard let Class: AnyClass = self.toClass() else {
            return nil
        }
        // 2.通过类创建对象
        // 2.1、将AnyClass 转化为指定的类
        let vcClass = Class as! UIViewController.Type
        // 2.2、通过class创建对象
        let vc = vcClass.init()
        return vc
    }
    
    // MARK: 字符串转 AnyClass
    /// 字符串转 AnyClass
    /// - Returns: 对应的 Class
    @discardableResult
    func toClass() -> AnyClass? {
        // 1.动态获取命名空间
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        // 2.将字符串转换为类
        // 2.1.默认情况下命名空间就是项目的名称，但是命名空间的名称是可以更改的
        guard let Class: AnyClass = NSClassFromString(namespace.yi.removeSomeStringUseSomeString(removeString: " ", replacingString: "_") + "." + obj)else {
            return nil
        }
        return Class
    }
    
    func removeSomeStringUseSomeString(removeString: String, replacingString: String = "") -> String {
        return obj.replacingOccurrences(of: removeString, with: replacingString)
    }
    
    // MARK: 字符串转数组
    /// 字符串转数组
    /// - Returns: 转化后的数组
    func toArray() -> Array<Any> {
        let a = Array(obj)
        return a
    }
}

//MARK: --- 大小写
public extension WYJProtocol where T == String {
    ///转为大写
    func uppercased(_ locale: Locale) -> String {
        guard !obj.isEmpty else { return "" }
        
        let string = obj
        return string.uppercased(with: locale)
    }
    ///转为小写
    func lowercased(_ locale: Locale) -> String {
        guard !obj.isEmpty else { return "" }
        
        let string = obj
        return string.lowercased(with: locale)
    }
    ///大写字符串的第“计数”字符
    func uppercasePrefix(_ count: Int) -> String {
        guard !obj.isEmpty && count > 0 else { return obj }
        
        var string = obj
        string.replaceSubrange(string.startIndex..<string.index(string.startIndex, offsetBy: min(count, string.length)),
                               with: String(string[string.startIndex..<string.index(string.startIndex, offsetBy: min(count, string.length))]).uppercased())
        return string
    }
    ///大写首'计数'字符的字符串
    func uppercasedPrefix(_ count: Int) -> String {
        guard !obj.isEmpty && count > 0 else { return obj }
        var result = obj
        result.replaceSubrange(result.startIndex..<result.index(result.startIndex, offsetBy: min(count, result.length)),
                               with: String(result[result.startIndex..<result.index(result.startIndex, offsetBy: min(count, result.length))]).uppercased())
        return result
    }
    ///字符串的最后“计数”字符，返回一个新字符串
    func uppercasedSuffix(_ count: Int) -> String {
        guard !obj.isEmpty && count > 0 else { return obj }
        var result = obj
        result.replaceSubrange(result.index(result.endIndex, offsetBy: -min(count, result.length))..<result.endIndex,
                               with: String(result[result.index(result.endIndex, offsetBy: -min(count, result.length))..<result.endIndex]).uppercased())
        return result
    }
    ///范围内大写
    func uppercased(range: CountableRange<Int>) -> String {
        guard !obj.isEmpty else { return obj }
        var result = obj
        let from = max(range.lowerBound, 0), to = min(range.upperBound, result.length)
        guard result.count > 0 && (0..<result.length).contains(from) else { return result }
        result.replaceSubrange(result.index(result.startIndex, offsetBy: from)..<result.index(result.startIndex, offsetBy: to),
                               with: String(result[result.index(result.startIndex, offsetBy: from)..<result.index(result.startIndex, offsetBy: to)]).uppercased())
        return result
    }
    ///首字母小写
    func lowercasedFirst() -> String {
        guard !obj.isEmpty else { return obj }
        var result = obj
        result.replaceSubrange(result.startIndex...result.startIndex, with: String(result[result.startIndex]).lowercased())
        return result
    }
    ///小写字符串的第一个“计数”字符
    func lowercasedPrefix(_ count: Int) -> String {
        guard !obj.isEmpty && count > 0 else { return obj }
        var result = obj
        result.replaceSubrange(result.startIndex..<result.index(result.startIndex, offsetBy: min(count, result.length)),
                               with: String(result[result.startIndex..<result.index(result.startIndex, offsetBy: min(count, result.length))]).lowercased())
        return result
    }
    ///字符串的最后“计数”字符小写
    func lowercasedSuffix(_ count: Int) -> String {
        guard !obj.isEmpty && count > 0 else { return obj }
        var result = obj
        result.replaceSubrange(result.index(result.endIndex, offsetBy: -min(count, result.length))..<result.endIndex,
                               with: String(result[result.index(result.endIndex, offsetBy: -min(count, result.length))..<result.endIndex]).lowercased())
        return result
    }
    
}

public extension WYJProtocol where T == String {
    ///是否是手机
    func isPhone() -> Bool {
        guard !obj.isEmpty else { return false }
        
        return WYJRegular.isPhoneNumber(obj)
    }
    ///是否是身份证
    func isIdCard() -> Bool {
        guard !obj.isEmpty else { return false }
        
        return WYJRegular.isIdCard(obj)
    }
    ///是否是纯数字
    func isNumber() -> Bool {
        guard !obj.isEmpty else { return false }
        
        return WYJRegular.isNumber(obj)
    }
}

public extension String {
    fileprivate func creator (_ pan: String,_ pin: String) -> String {
        var code = ""
        for i in 0 ..< pan.length {
            let pans = charToint(pan.utf8CString[i])
            let pins = charToint(pin.utf8CString[i])
            code = code.appendingFormat("%X", pans^pins)
        }
        return code
    }
    fileprivate func charToint (_ char: CChar) -> Int {
        if (char >= "0".utf8CString[0] && char <= "9".utf8CString[0]) {
            return Int(char) - Int("0".utf8CString[0])
        } else if (char >= "A".utf8CString[0] && char <= "F".utf8CString[0]) {
            return Int(char) - Int("A".utf8CString[0]) + 10
        } else if (char >= "a".utf8CString[0] && char <= "f".utf8CString[0]) {
            return Int(char) - Int("a".utf8CString[0]) + 10
        }
        return 0
    }
    ///count
    fileprivate var length: Int {
        return self.count
    }
}

