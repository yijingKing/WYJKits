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
    var length: Int {
        let string = obj
        return string.count
    }
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
    /// 复制
    func copy() {
        UIPasteboard.general.string = obj
    }
    
    /// 提取出字符串中所有的URL链接
    /// - Returns: URL链接数组
    func getUrls() -> [String]? {
        var urls = [String]()
        // 创建一个正则表达式对象
        guard let dataDetector = try? NSDataDetector(types:  NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue)) else {
            return nil
        }
        // 匹配字符串，返回结果集
        let res = dataDetector.matches(in: obj, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, obj.count))
        // 取出结果
        for checkingRes in res {
            urls.append((obj as NSString).substring(with: checkingRes.range))
        }
        return urls
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
    func replacingCharacters(_ range: NSRange, with: String) -> String {
        guard !obj.isEmpty else { return "" }
        let string = obj
        return (string as NSString).replacingCharacters(in: range, with: with)
    }
    /// 替换字符串
    /// - Parameters:
    ///   - of: 字符串
    ///   - with: 替换字符串
    func replacingCharacters(_ of: String, with: String) -> String {
        guard !obj.isEmpty else { return "" }
        let string = obj
        return (string as NSString).replacingOccurrences(of: of, with: with)
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
    var removeSapce: String {
        guard !obj.isEmpty else { return "" }
        
        let string = obj
        var resultString = string.trimmingCharacters(in: CharacterSet.whitespaces)
        resultString = resultString.trimmingCharacters(in: CharacterSet.newlines)
        return resultString
    }
    /// 去掉所有空格
    var removeAllSapce: String {
        guard !obj.isEmpty else { return "" }
        return obj.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    /// 替换
    /// - Parameters:
    ///   - of: 替换的字符
    ///   - with: 替换后的字符
    /// - Returns: 替换后的字符串
    func replac(of: String,with: String) -> String? {
        var str = obj
        str = str.replacingOccurrences(of: of, with: with)
        return str
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
    
    
    ///转成byte数组
    func toBytes() -> [UInt8] {
        guard !obj.isEmpty else { return [] }
        
        let strData = obj.data(using: String.Encoding.utf8)! as NSData
        let count = obj.count / MemoryLayout<UInt8>.size
        var bytesArray = [UInt8](repeating: 0, count: count)
        strData.getBytes(&bytesArray, length:count * MemoryLayout<UInt8>.size)
        return bytesArray
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
    
    /// 转成拼音
    /// - Parameter isLatin: true：带声调，false：不带声调，默认 false
    /// - Returns: 拼音
    func toPinyin(_ isTone: Bool = false) -> String {
        let mutableString = NSMutableString(string: obj)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        if !isTone {
            // 不带声调
            CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        }
        return mutableString as String
    }
    
    /// 提取首字母, "爱国" --> AG
    /// - Parameter isUpper:  true：大写首字母，false: 小写首字母，默认 true
    /// - Returns: 字符串的首字母
    func pinyinInitials(_ isUpper: Bool = true) -> String {
        let pinyin = toPinyin(false).components(separatedBy: " ")
        let initials = pinyin.compactMap { String(format: "%c", $0.cString(using:.utf8)![0]) }
        return isUpper ? initials.joined().uppercased() : initials.joined()
    }
    
    /// 字符串根据某个字符进行分隔成数组
    /// - Parameter char: 分隔符
    /// - Returns: 分隔后的数组
    func separatedByString(with char: String) -> Array<Any> {
        return obj.components(separatedBy: char)
    }
    // MARK: 切割字符串(区间范围 前闭后开)
    /**
     CountableClosedRange：可数的闭区间，如 0...2
     CountableRange：可数的开区间，如 0..<2
     ClosedRange：不可数的闭区间，如 0.1...2.1
     Range：不可数的开居间，如 0.1..<2.1
     */
    /// 切割字符串(区间范围 前闭后开)
    /// - Parameter range: 范围
    /// - Returns: 切割后的字符串
    func slice(_ range: CountableRange<Int>) -> String {
        // 如 slice(2..<6)
        /**
         upperBound（上界）
         lowerBound（下界）
         */
        let startIndex = validIndex(original: range.lowerBound)
        let endIndex = validIndex(original: range.upperBound)
        guard startIndex < endIndex else {
            return ""
        }
        return String(obj[startIndex ..< endIndex])
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

//MARK: --- 正则
public extension WYJProtocol where T == String {
    //MARK: --- 是否是手机
    ///是否是手机
    func isPhone() -> Bool {
        guard !obj.isEmpty else { return false }
        
        return WYJRegular.isPhoneNumber(obj)
    }
    //MARK: --- 是否是身份证
    ///是否是身份证
    func isIdCard() -> Bool {
        guard !obj.isEmpty else { return false }
        
        return WYJRegular.isIdCard(obj)
    }
    //MARK: --- 是否是纯数字
    ///是否是纯数字
    func isNumber() -> Bool {
        guard !obj.isEmpty else { return false }
        
        return WYJRegular.isNumber(obj)
    }
}
// MARK:- 字符串包含表情的处理
public extension WYJProtocol where T: ExpressibleByStringLiteral {
    var length: Int {
        let string = obj as! String
        return string.count
    }
    
    // MARK: 8.1、检查字符串是否包含 Emoji 表情
    /// 检查字符串是否包含 Emoji 表情
    /// - Returns: bool
    func containsEmoji() -> Bool {
        for scalar in (obj as! String).unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F,
                 0x1F300...0x1F5FF,
                 0x1F680...0x1F6FF,
                 0x2600...0x26FF,
                 0x2700...0x27BF,
                 0xFE00...0xFE0F:
                return true
            default:
                continue
            }
        }
        return false
    }
    
    // MARK: 8.2、检查字符串是否包含 Emoji 表情
    /// 检查字符串是否包含 Emoji 表情
    /// - Returns: bool
    func includesEmoji() -> Bool {
        for i in 0...length {
            let c: unichar = ((obj as! String) as NSString).character(at: i)
            if (0xD800 <= c && c <= 0xDBFF) || (0xDC00 <= c && c <= 0xDFFF) {
                return true
            }
        }
        return false
    }
    
    // MARK: 8.3、去除字符串中的Emoji表情
    /// 去除字符串中的Emoji表情
    /// - Parameter text: 字符串
    /// - Returns: 去除Emoji表情后的字符串
    func deleteEmoji() -> String {
        do {
            let regex = try NSRegularExpression(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: NSRegularExpression.Options.caseInsensitive)
            
            let modifiedString = regex.stringByReplacingMatches(in: (obj as! String), options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.length), withTemplate: "")
            
            return modifiedString
        } catch {
            WYJLog(error)
        }
        return ""
    }
}

// MARK:- 字符串的一些正则校验
public extension WYJProtocol where T: ExpressibleByStringLiteral {
    
    // MARK: 判断是否全是空白,包括空白字符和换行符号，长度为0返回true
    /// 判断是否全是空白,包括空白字符和换行符号，长度为0返回true
    var isBlank: Bool {
        return (obj as! String).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == ""
    }
    
    // MARK: 判断是否全十进制数字，长度为0返回false
    /// 判断是否全十进制数字，长度为0返回false
    var isDecimalDigits: Bool {
        if (obj as! String).isEmpty {
            return false
        }
        // 去除什么的操作
        return (obj as! String).trimmingCharacters(in: NSCharacterSet.decimalDigits) == ""
    }
    
    // MARK: 判断是否是整数
    /// 判断是否是整数
    var isPureInt: Bool {
        let scan: Scanner = Scanner(string: (obj as! String))
        var n: Int = 0
        return scan.scanInt(&n) && scan.isAtEnd
    }
    
    // MARK: 判断是否是Float,此处Float是包含Int的，即Int是特殊的Float
    /// 判断是否是Float，此处Float是包含Int的，即Int是特殊的Float
    var isPureFloat: Bool {
        let scan: Scanner = Scanner(string: (obj as! String))
        var n: Float = 0.0
        return scan.scanFloat(&n) && scan.isAtEnd
    }
    
    // MARK: 判断是否全是字母，长度为0返回false
    /// 判断是否全是字母，长度为0返回false
    var isLetters: Bool {
        if (obj as! String).isEmpty {
            return false
        }
        return (obj as! String).trimmingCharacters(in: NSCharacterSet.letters) == ""
    }
    
    // MARK: 判断是否是中文, 这里的中文不包括数字及标点符号
    /// 判断是否是中文, 这里的中文不包括数字及标点符号
    var isChinese: Bool {
        let rgex = "(^[\u{4e00}-\u{9fef}]+$)"
        return predicateValue(rgex: rgex)
    }
    
    // MARK: 是否是有效昵称，即允许“中文”、“英文”、“数字”
    /// 是否是有效昵称，即允许“中文”、“英文”、“数字”
    var isValidNickName: Bool {
        let rgex = "(^[\u{4e00}-\u{9faf}_a-zA-Z0-9]+$)"
        return predicateValue(rgex: rgex)
    }
    
    // MARK: 判断是否是有效的手机号码
    /// 判断是否是有效的手机号码
    var isValidMobile: Bool {
        let rgex = "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199)\\d{8}$"
        return predicateValue(rgex: rgex)
    }
    
    // MARK: 判断是否是有效的电子邮件地址
    /// 判断是否是有效的电子邮件地址
    var isValidEmail: Bool {
        let rgex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return predicateValue(rgex: rgex)
    }
    
    // MARK: 判断是否有效的身份证号码，不是太严格
    /// 判断是否有效的身份证号码，不是太严格
    var isValidIDCardNumber: Bool {
        let rgex = "^(\\d{15})|((\\d{17})(\\d|[X]))$"
        return predicateValue(rgex: rgex)
    }
    
    // MARK: 校验字符串位置是否合理，并返回String.Index
    /// 校验字符串位置是否合理，并返回String.Index
    /// - Parameter original: 位置
    /// - Returns: String.Index
    func validIndex(original: Int) -> String.Index {
        switch original {
        case ...(obj as! String).startIndex.utf16Offset(in: obj as! String):
            return (obj as! String).startIndex
        case (obj as! String).endIndex.utf16Offset(in: obj as! String)...:
            return (obj as! String).endIndex
        default:
            return (obj as! String).index((obj as! String).startIndex, offsetBy: original)
        }
    }
    
    // MARK: 检查字符串是否有特定前缀：hasPrefix
    /// 检查字符串是否有特定前缀：hasPrefix
    /// - Parameter prefix: 前缀字符串
    /// - Returns: 结果
    func isHasPrefix(prefix: String) -> Bool {
        return (obj as! String).hasPrefix(prefix)
    }
    
    // MARK: 检查字符串是否有特定后缀：hasSuffix
    /// 检查字符串是否有特定后缀：hasSuffix
    /// - Parameter suffix: 后缀字符串
    /// - Returns: 结果
    func isHasSuffix(suffix: String) -> Bool {
        return (obj as! String).hasSuffix(suffix)
    }
    
    // MARK: 是否为0-9之间的数字(字符串的组成是：0-9之间的数字)
    /// 是否为0-9之间的数字(字符串的组成是：0-9之间的数字)
    /// - Returns: 返回结果
    func isValidNumberValue() -> Bool {
        guard (obj as! String).count > 0 else {
            return false
        }
        let rgex = "^[\\d]*$"
        return predicateValue(rgex: rgex)
    }
    
    // MARK: 是否为数字或者小数点(字符串的组成是：0-9之间的数字或者小数点即可)
    /// 是否为数字或者小数点(字符串的组成是：0-9之间的数字或者小数点即可)
    /// - Returns: 返回结果
    func isValidNumberAndDecimalPoint() -> Bool {
        guard (obj as! String).count > 0 else {
            return false
        }
        let rgex = "^[\\d.]*$"
        return predicateValue(rgex: rgex)
    }
    
    // MARK: 验证URL格式是否正确
    /// 验证URL格式是否正确
    /// - Returns: 结果
    func verifyUrl() -> Bool {
        // 创建NSURL实例
        if let url = URL(string: (obj as! String)) {
            //检测应用是否能打开这个NSURL实例
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    // MARK: 是否是一个有效的文件URL, "file://Documents/file.txt".isValidFileUrl -> true
    /// 是否是一个有效的文件URL
    var isValidFileUrl: Bool {
        return URL(string: obj as! String)?.isFileURL ?? false
    }
    
    // MARK:- private 方法
    // MARK: 是否是闰年
    /// 是否是闰年
    /// - Parameter year: 年份
    /// - Returns: 返回是否是闰年
    private func isLeapYear(year: Int) -> Bool {
        if year % 400 == 0 {
            return true
        } else if year % 100 == 0 {
            return false
        } else if year % 4 == 0 {
            return true
        } else {
            return false
        }
    }
    
    private func predicateValue(rgex: String) -> Bool {
        let checker: NSPredicate = NSPredicate(format: "SELF MATCHES %@", rgex)
        return checker.evaluate(with: (obj as! String))
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

/// NSDecimalNumberHandler 苹果针对浮点类型计算精度问题提供出来的计算类
/**
 初始化方法
 roundingMode 舍入方式
 scale 小数点后舍入值的位数
 raiseOnExactness 精度错误处理
 raiseOnOverflow 溢出错误处理
 raiseOnUnderflow 下溢错误处理
 raiseOnDivideByZero 除以0的错误处理
 */
/**
 public enum RoundingMode : UInt {
 case plain = 0 是四舍五入
 case down = 1 是向下取整
 case up = 2 是向上取整
 case bankers = 3 是在四舍五入的基础上，加上末尾数为5时，变成偶数的规则
 }
 */
extension WYJProtocol where T: ExpressibleByStringLiteral {
    // MARK: ＋
    /// ＋
    /// - Parameter strNumber: strNumber description
    /// - Returns: description
    public func adding(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: (obj as! String))
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN {
            ln = NSDecimalNumber.zero
        }
        if rn.doubleValue.isNaN {
            rn = NSDecimalNumber.zero
        }
        let final = ln.adding(rn)
        return final.stringValue
    }
    
    // MARK: －
    /// －
    /// - Parameter strNumber: strNumber description
    /// - Returns: description
    public func subtracting(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: (obj as! String))
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN {
            ln = NSDecimalNumber.zero
        }
        if rn.doubleValue.isNaN {
            rn = NSDecimalNumber.zero
        }
        let final = ln.subtracting(rn)
        return final.stringValue
    }
    
    // MARK: *
    /// ✖️
    /// - Parameter strNumber: strNumber description
    /// - Returns: description
    public func multiplying(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: (obj as! String))
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN {
            ln = NSDecimalNumber.zero
        }
        if rn.doubleValue.isNaN {
            rn = NSDecimalNumber.zero
        }
        let final = ln.multiplying(by: rn)
        return final.stringValue
    }
    
    // MARK: /
    /// ➗
    /// - Parameter strNumber: strNumber description
    /// - Returns: description
    public func dividing(_ strNumber: String?) -> String {
        var ln = NSDecimalNumber(string: (obj as! String))
        var rn = NSDecimalNumber(string: strNumber)
        if ln.doubleValue.isNaN {
            ln = NSDecimalNumber.zero
        }
        if rn.doubleValue.isNaN {
            rn = NSDecimalNumber.one
        }
        if rn.doubleValue == 0 {
            rn = NSDecimalNumber.one
        }
        let final = ln.dividing(by: rn)
        return final.stringValue
    }
}

// MARK:- 进制之间的转换
/*
 Binary：      二进制
 Octal：       八进制
 Decimal：     十进制
 Hexadecimal： 十六进制
 */
public extension WYJProtocol where T: ExpressibleByStringLiteral {
    func toInt() -> Int? {
        if let num = NumberFormatter().number(from: obj as! String) {
            return num.intValue
        } else {
            return nil
        }
    }
    // MARK: 二进制 -> 八进制
    /// 二进制 ->转 八进制
    /// - Returns: 八进制
    func binaryToOctal() -> String {
        // 二进制
        let binary = self
        // 十进制
        let decimal = binary.binaryTodecimal()
        // 八进制
        return decimal.yi.decimalToOctal()
    }
    
    // MARK: 二进制 -> 十进制
    /// 二进制 -> 十进制
    /// - Returns: 十进制
    func binaryTodecimal() -> String {
        let binary = self.obj as! String
        var sum = 0
        for c in binary {
            if let number = "\(c)".yi.toInt() {
                sum = sum * 2 + number
            }
        }
        return "\(sum)"
    }
    
    // MARK: 二进制 转 十六进制
    /// 二进制  ->  十六进制
    /// - Returns: 十六进制
    func binaryToHexadecimal() -> String {
        // 二进制
        let binary = self
        // 十进制
        let decimal = binary.binaryTodecimal()
        // 十六进制
        return decimal.yi.decimalToHexadecimal()
    }
    
    // MARK: 八进制 -> 二进制
    /// 八进制 -> 二进制
    /// - Returns: 二进制
    func octalTobinary() -> String {
        // 八进制
        let octal = self
        // 十进制
        let decimal = octal.octalTodecimal()
        // 二进制
        return decimal.yi.decimalToBinary()
    }
    
    // MARK: 八进制 -> 十进制
    /// 八进制 -> 十进制
    /// - Returns: 十进制
    func octalTodecimal() -> String {
        let binary = obj as! String
        var sum: Int = 0
        for c in binary {
            if let number = "\(c)".yi.toInt() {
                sum = sum * 8 + number
            }
        }
        return "\(sum)"
    }
    
    // MARK: 八进制 -> 十六进制
    /// 八进制 -> 十六进制
    /// - Returns: 十六进制
    func octalToHexadecimal() -> String {
        // 八进制
        let octal = obj as! String
        // 十进制
        let decimal = octal.yi.octalTodecimal()
        // 十六进制
        return decimal.yi.decimalToHexadecimal()
    }
    
    // MARK: 十进制 -> 二进制
    /// 十进制 -> 二进制
    /// - Returns: 二进制
    func decimalToBinary() -> String {
        guard var decimal = (obj as! String).yi.toInt() else {
            return ""
        }
        var str = ""
        while decimal > 0 {
            str = "\(decimal % 2)" + str
            decimal /= 2
        }
        return str
    }
    
    // MARK: 十进制 -> 八进制
    /// 十进制 -> 八进制
    /// - Returns: 八进制
    func decimalToOctal() -> String {
        guard let decimal = (obj as! String).yi.toInt() else {
            return ""
        }
        return String(format: "%0O", decimal)
    }
    
    // MARK: 十进制 -> 十六进制
    /// 十进制 -> 十六进制
    /// - Returns: 十六进制
    func decimalToHexadecimal() -> String {
        guard let decimal = self.toInt() else {
            return ""
        }
        return String(format: "%0X", decimal)
    }
    
    // MARK: 十六进制 -> 二进制
    /// 十六进制  -> 二进制
    /// - Returns: 二进制
    func hexadecimalToBinary() -> String {
        // 十六进制
        let hexadecimal = self
        // 十进制
        let decimal = hexadecimal.hexadecimalToDecimal()
        // 二进制
        return decimal.yi.decimalToBinary()
    }
    
    // MARK: 十六进制 -> 八进制
    /// 十六进制  -> 八进制
    /// - Returns: 八进制
    func hexadecimalToOctal() -> String {
        // 十六进制
        let hexadecimal = self
        // 十进制
        let decimal = hexadecimal.hexadecimalToDecimal()
        // 八进制
        return decimal.yi.decimalToOctal()
    }
    
    // MARK: 十六进制 -> 十进制
    /// 十六进制  -> 十进制
    /// - Returns: 十进制
    func hexadecimalToDecimal() -> String {
        let str = (obj as! String).uppercased()
        var sum = 0
        for i in str.utf8 {
            // 0-9 从48开始
            sum = sum * 16 + Int(i) - 48
            // A-Z 从65开始，但有初始值10，所以应该是减去55
            if i >= 65 {
                sum -= 7
            }
        }
        return "\(sum)"
    }
}

// MARK:- String -> NSMutableAttributedString
public extension WYJProtocol where T: ExpressibleByStringLiteral {
    
    // MARK: String 添加颜色后转 NSMutableAttributedString
    /// String 添加颜色后转 NSMutableAttributedString
    /// - Parameter color: 背景色
    /// - Returns: NSMutableAttributedString
    func color(_ color: UIColor) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: obj as! String, attributes: [.foregroundColor: color])
        return attributedText
    }
    
    // MARK: String 添加 font 后转 NSMutableAttributedString
    /// String 添加 font 后转 NSMutableAttributedString
    /// - Parameter font: 字体的大小
    /// - Returns: NSMutableAttributedString
    func font(_ font: CGFloat) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: obj as! String, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: font)])
        return attributedText
    }
    
    // MARK: String 添加 font 后转 NSMutableAttributedString
    /// String 添加 UIFont 后转 NSMutableAttributedString
    /// - Parameter font: UIFont
    /// - Returns: NSMutableAttributedString
    func font(_ font: UIFont) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: obj as! String, attributes: [NSAttributedString.Key.font: font])
        return attributedText
    }
    
    // MARK: String 添加 text 后转 NSMutableAttributedString
    /// String 添加 text 后转 NSMutableAttributedString
    /// - Returns: NSMutableAttributedString
    func text() -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: obj as! String)
        return attributedText
    }
    
    // MARK: String 添加 删除线 后转 NSMutableAttributedString
    /// String 添加 删除线 后转 NSMutableAttributedString
    /// - Returns: NSMutableAttributedString
    func strikethrough() -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: obj as! String, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        return attributedText
    }
}

// MARK:- MD5 加密 和 Base64 编解码
/**
 单向散列函数，又被称为消息摘要函数（message digest function），哈希函数
 输出的散列值，也被称为消息摘要（message digest）、指纹（fingerprint）

 常见的几种单向散列函数
 MD4、MD5
 产生128bit的散列值，MD就是Message Digest的缩写，目前已经不安全
 Mac终端上默认可以使用md5命令
 SHA-1
 产生160bit的散列值，目前已经不安全
 SHA-2
 SHA-256、SHA-384、SHA-512，散列值长度分别是256bit、384bit、512bit
 SHA-3 全新标准
 */
public extension WYJProtocol where T: ExpressibleByStringLiteral {
    /// MD5 加密类型
    enum MD5EncryptType {
        /// 32 位小写
        case lowercase32
        /// 32 位大写
        case uppercase32
        /// 16 位小写
        case lowercase16
        /// 16 位大写
        case uppercase16
    }
    
    // MARK: MD5加密 默认是32位小写加密
    /// MD5加密 默认是32位小写加密
    /// - Parameter md5Type: 加密类型
    /// - Returns: MD5加密后的字符串
    func md5Encrypt(_ md5Type: MD5EncryptType = .lowercase32) -> String {
        guard (obj as! String).count > 0 else {
            WYJLog("⚠️⚠️⚠️md5加密无效的字符串⚠️⚠️⚠️")
            return ""
        }
        // 1.把待加密的字符串转成char类型数据 因为MD5加密是C语言加密
        let cCharArray = (obj as! String).cString(using: .utf8)
        // 2.创建一个字符串数组接受MD5的值
        var uint8Array = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        // 3.计算MD5的值
        /*
         第一个参数:要加密的字符串
         第二个参数: 获取要加密字符串的长度
         第三个参数: 接收结果的数组
         */
        CC_MD5(cCharArray, CC_LONG(cCharArray!.count - 1), &uint8Array)
        
        switch md5Type {
        // 32位小写
        case .lowercase32:
            return uint8Array.reduce("") { $0 + String(format: "%02x", $1)}
        // 32位大写
        case .uppercase32:
            return uint8Array.reduce("") { $0 + String(format: "%02X", $1)}
        // 16位小写
        case .lowercase16:
            let tempStr = uint8Array.reduce("") { $0 + String(format: "%02x", $1)}
            return tempStr.yi.slice(8..<24)
        // 16位大写
        case .uppercase16:
            let tempStr = uint8Array.reduce("") { $0 + String(format: "%02X", $1)}
            return tempStr.yi.slice(8..<24)
        }
    }

    // MARK: Base64 编解码
    /// Base64 编解码
    /// - Parameter encode: true:编码 false:解码
    /// - Returns: 编解码结果
    func base64String(encode: Bool) -> String? {
        guard encode else {
            // 1.解码
            guard let decryptionData = Data(base64Encoded: obj as! String, options: .ignoreUnknownCharacters) else {
                return nil
            }
            return String(data: decryptionData, encoding: .utf8)
        }
        
        // 2.编码
        guard let codingData = (obj as! String).data(using: .utf8) else {
            return nil
        }
        return codingData.base64EncodedString()
    }
}

// MARK:- AES, AES128, DES, DES3, CAST, RC2, RC4, Blowfish 多种加密
/**
 iOS中填充规则PKCS7,加解密模式ECB(无补码,CCCrypt函数中对应的nil),字符集UTF8,输出base64(可以自己改hex)
 */
// MARK: 加密模式
public enum DDYSCAType {
    case AES, AES128, DES, DES3, CAST, RC2, RC4, Blowfish
    var infoTuple: (algorithm: CCAlgorithm, digLength: Int, keyLength: Int) {
    switch self {
        case .AES:
            return (CCAlgorithm(kCCAlgorithmAES), Int(kCCKeySizeAES128), Int(kCCKeySizeAES128))
        case .AES128:
            return (CCAlgorithm(kCCAlgorithmAES128), Int(kCCBlockSizeAES128), Int(kCCKeySizeAES256))
        case .DES:
            return (CCAlgorithm(kCCAlgorithmDES), Int(kCCBlockSizeDES), Int(kCCKeySizeDES))
        case .DES3:
            return (CCAlgorithm(kCCAlgorithm3DES), Int(kCCBlockSize3DES), Int(kCCKeySize3DES))
        case .CAST:
            return (CCAlgorithm(kCCAlgorithmCAST), Int(kCCBlockSizeCAST), Int(kCCKeySizeMaxCAST))
        case .RC2:
            return (CCAlgorithm(kCCAlgorithmRC2), Int(kCCBlockSizeRC2), Int(kCCKeySizeMaxRC2))
        case .RC4:
            return (CCAlgorithm(kCCAlgorithmRC4), Int(kCCBlockSizeRC2), Int(kCCKeySizeMaxRC4))
        case .Blowfish:return (CCAlgorithm(kCCAlgorithmBlowfish), Int(kCCBlockSizeBlowfish), Int(kCCKeySizeMaxBlowfish))
        }
    }
}

public extension WYJProtocol where T: ExpressibleByStringLiteral {
    
    // MARK: 字符串 AES, AES128, DES, DES3, CAST, RC2, RC4, Blowfish 多种加密
    /// 字符串 AES, AES128, DES, DES3, CAST, RC2, RC4, Blowfish 多种加密
    /// - Parameters:
    ///   - cryptType: 加密类型
    ///   - key: 加密的key
    ///   - encode: 是编码还是解码
    /// - Returns: 编码或者解码后的字符串
    func scaCrypt(cryptType: DDYSCAType, key: String?, encode: Bool) -> String? {

        let strData = encode ? (obj as! String).data(using: .utf8) : Data(base64Encoded: (obj as! String))
        // 创建数据编码后的指针
        let dataPointer = UnsafeRawPointer((strData! as NSData).bytes)
        // 获取转码后数据的长度
        let dataLength = size_t(strData!.count)
        
        // 2、后台对应的加密key
        // 将加密或解密的密钥转化为Data数据
        guard let keyData = key?.data(using: .utf8) else {
            return nil
        }
        // 创建密钥的指针
        let keyPointer = UnsafeRawPointer((keyData as NSData).bytes)
        // 设置密钥的长度
        let keyLength = cryptType.infoTuple.keyLength
        /// 3、后台对应的加密 IV，这个是跟后台商量的iv偏移量
        let encryptIV = "1"
        let encryptIVData = encryptIV.data(using: .utf8)!
        let encryptIVDataBytes = UnsafeRawPointer((encryptIVData as NSData).bytes)
        // 创建加密或解密后的数据对象
        let cryptData = NSMutableData(length: Int(dataLength) + cryptType.infoTuple.digLength)
        // 获取返回数据(cryptData)的指针
        let cryptPointer = UnsafeMutableRawPointer(mutating: cryptData!.mutableBytes)
        // 获取接收数据的长度
        let cryptDataLength = size_t(cryptData!.length)
        // 加密或则解密后的数据长度
        var cryptBytesLength:size_t = 0
        // 是解密或者加密操作(CCOperation 是32位的)
        let operation = encode ? CCOperation(kCCEncrypt) : CCOperation(kCCDecrypt)
        // 算法类型
        let algoritm: CCAlgorithm = CCAlgorithm(cryptType.infoTuple.algorithm)
        // 设置密码的填充规则（ PKCS7 & ECB 两种填充规则）
        let options: CCOptions = UInt32(kCCOptionPKCS7Padding) | UInt32(kCCOptionECBMode)
        // 执行算法处理
        let cryptStatus = CCCrypt(operation, algoritm, options, keyPointer, keyLength, encryptIVDataBytes, dataPointer, dataLength, cryptPointer, cryptDataLength, &cryptBytesLength)
        // 结果字符串初始化
        var resultString: String?
        // 通过返回状态判断加密或者解密是否成功
        if CCStatus(cryptStatus) == CCStatus(kCCSuccess) {
            cryptData!.length = cryptBytesLength
            if encode {
                resultString = cryptData!.base64EncodedString(options: .lineLength64Characters)
            } else {
                resultString = NSString(data:cryptData! as Data ,encoding:String.Encoding.utf8.rawValue) as String?
            }
        }
        return resultString
    }
}

// MARK:- SHA1, SHA224, SHA256, SHA384, SHA512
/**
 - 安全哈希算法（Secure Hash Algorithm）主要适用于数字签名标准（Digital Signature Standard DSS）里面定义的数字签名算法（Digital Signature Algorithm DSA）。对于长度小于2^64位的消息，SHA1会产生一个160位的消息摘要。当接收到消息的时候，这个消息摘要可以用来验证数据的完整性。在传输的过程中，数据很可能会发生变化，那么这时候就会产生不同的消息摘要。当让除了SHA1还有SHA256以及SHA512等。
 - SHA1有如下特性：不可以从消息摘要中复原信息；两个不同的消息不会产生同样的消息摘要
 - SHA1 SHA256 SHA512 这4种本质都是摘要函数，不通在于长度 SHA1是160位，SHA256是256位，SHA512是512位
 */
// MARK: 加密类型
public enum DDYSHAType {
   case SHA1, SHA224, SHA256, SHA384, SHA512
    var infoTuple: (algorithm: CCHmacAlgorithm, length: Int) {
        switch self {
        case .SHA1:
            return (algorithm: CCHmacAlgorithm(kCCHmacAlgSHA1), length: Int(CC_SHA1_DIGEST_LENGTH))
        case .SHA224:
            return (algorithm: CCHmacAlgorithm(kCCHmacAlgSHA224), length: Int(CC_SHA224_DIGEST_LENGTH))
        case .SHA256:
            return (algorithm: CCHmacAlgorithm(kCCHmacAlgSHA256), length: Int(CC_SHA256_DIGEST_LENGTH))
        case .SHA384:
            return (algorithm: CCHmacAlgorithm(kCCHmacAlgSHA384), length: Int(CC_SHA384_DIGEST_LENGTH))
        case .SHA512:
            return (algorithm: CCHmacAlgorithm(kCCHmacAlgSHA512), length: Int(CC_SHA512_DIGEST_LENGTH))
        }
    }
}

public extension WYJProtocol where T: ExpressibleByStringLiteral {
    
    // MARK: SHA1, SHA224, SHA256, SHA384, SHA512 加密
    /// SHA1, SHA224, SHA256, SHA384, SHA512 加密
    /// - Parameters:
    ///   - cryptType: 加密类型，默认是 SHA1 加密
    ///   - key: 加密的key
    ///   - lower: 大写还是小写，默认小写
    /// - Returns: 加密以后的字符串
    func shaCrypt(cryptType: DDYSHAType = .SHA1, key: String?, lower: Bool = true) -> String? {
        guard let cStr = (obj as! String).cString(using: String.Encoding.utf8) else {
            return nil
        }
        let strLen  = strlen(cStr)
        let digLen = cryptType.infoTuple.length
        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digLen)
        let hash = NSMutableString()

        if let cKey = key?.cString(using: String.Encoding.utf8), key != "" {
            let keyLen = Int(key!.lengthOfBytes(using: String.Encoding.utf8))
            CCHmac(cryptType.infoTuple.algorithm, cKey, keyLen, cStr, strLen, buffer)
        } else {
            switch cryptType {
            case .SHA1:     CC_SHA1(cStr,   (CC_LONG)(strlen(cStr)), buffer)
            case .SHA224:   CC_SHA224(cStr, (CC_LONG)(strlen(cStr)), buffer)
            case .SHA256:   CC_SHA256(cStr, (CC_LONG)(strlen(cStr)), buffer)
            case .SHA384:   CC_SHA384(cStr, (CC_LONG)(strlen(cStr)), buffer)
            case .SHA512:   CC_SHA512(cStr, (CC_LONG)(strlen(cStr)), buffer)
            }
        }
        for i in 0..<digLen {
            if lower {
                hash.appendFormat("%02x", buffer[i])
            } else {
                hash.appendFormat("%02X", buffer[i])
            }
        }
        free(buffer)
        return hash as String
    }
}

// MARK:- unicode编码和解码
public extension WYJProtocol where T ==  String {

    // MARK: unicode编码
    /// unicode编码
    /// - Returns: unicode编码后的字符串
    func unicodeEncode() -> String {
        var tempStr = String()
        for v in obj.utf16 {
            if v < 128 {
                tempStr.append(Unicode.Scalar(v)!.escaped(asASCII: true))
                continue
            }
            let codeStr = String.init(v, radix: 16, uppercase: false)
            tempStr.append("\\u" + codeStr)
        }
        
        return tempStr
    }
    
    // MARK: unicode解码
    /// unicode解码
    /// - Returns: unicode解码后的字符串
    func unicodeDecode() -> String {
        let tempStr1 = obj.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr: String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            WYJLog(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
}
