/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit
import Foundation

/*
G:      公元时代，例如AD公元
yy:     年的后2位
yyyy:   完整年
MM:     月，显示为1-12,带前置0
MMM:    月，显示为英文月份简写,如 Jan
MMMM:   月，显示为英文月份全称，如 Janualy
dd:     日，2位数表示，如02
d:      日，1-2位显示，如2，无前置0
EEE:    简写星期几，如Sun
EEEE:   全写星期几，如Sunday
aa:     上下午，AM/PM
H:      时，24小时制，0-23
HH:     时，24小时制，带前置0
h:      时，12小时制，无前置0
hh:     时，12小时制，带前置0
m:      分，1-2位
mm:     分，2位，带前置0
s:      秒，1-2位
ss:     秒，2位，带前置0
S:      毫秒
Z:      GMT（时区）
*/
/// 60s
public let WYJDate_minute    = 60
/// 3600s
public let WYJDate_hour      = 60 * 60
/// 86400
public let WYJDate_day       = 60 * 60 * 24
/// 604800
public let WYJDate_week      = 60 * 60 * 24 * 7
/// 31556926
public let WYJDate_year      = 60 * 60 * 24 * 365

public enum WYJDateFormatter: String {
    ///月
    case dateModeM          = "MMMM"
    ///星期
    case dateModeE          = "EEEE"
    ///年
    case dateModeY          = "yyyy"
    ///年月
    case dateModeYM         = "yyyy-MM"
    ///年月日
    case dateModeYMD        = "yyyy-MM-dd"
    ///年月日时
    case dateModeYMDH       = "yyyy-MM-dd HH"
    ///年月日时分
    case dateModeYMDHM      = "yyyy-MM-dd HH:mm"
    ///年月日时分秒
    case dateModeYMDHMS     = "yyyy-MM-dd HH:mm:ss"
    ///年月日时分秒毫秒
    case dateModeYMDHMSSS   = "yyyy-MM-dd HH:mm:ss SSS"
}
// MARK: 时间条的显示格式
public enum WYJTimeBarType {
    // 默认格式，如 9秒：09，66秒：01：06，
    case normal
    case second
    case minute
    case hour
}
/// 时间戳的类型
public enum WYJTimestampType: Int {
    /// 秒
    case second
    /// 毫秒
    case millisecond
}


public class DateFormattersManager {
    public static var dateFormatters: SynchronizedDictionary = SynchronizedDictionary<String, DateFormatter>()
}

public extension WYJProtocol where T == Date {
    /// 获取当前的时间 Date
    static var currentDate : Date {
        return T()
    }
    /// 获取当前 秒级 时间戳 - 10 位
    static var secondStamp : String {
        let timeInterval: TimeInterval = T().timeIntervalSince1970
        return "\(Int(timeInterval))"
    }
    
    /// 获取当前 毫秒级 时间戳 - 13 位
    static var milliStamp : String {
        let timeInterval: TimeInterval = T().timeIntervalSince1970
        let millisecond = CLongLong(Darwin.round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    /// 时间戳(支持 10 位 和 13 位) 转 Date
    /// - Parameter timestamp: 时间戳
    /// - Returns: 返回 Date
    static func timestampToFormatterDate(timestamp: String) -> Date {
        guard timestamp.count == 10 ||  timestamp.count == 13 else {
            #if DEBUG
            fatalError("时间戳位数不是 10 也不是 13")
            #else
            return Date()
            #endif
        }
        guard let timestampInt = timestamp.yi.toInt() else {
            #if DEBUG
            fatalError("时间戳位有问题")
            #else
            return Date()
            #endif
        }
        let timestampValue = timestamp.count == 10 ? timestampInt : timestampInt / 1000
        // 时间戳转为Date
        let date = Date(timeIntervalSince1970: TimeInterval(timestampValue))
        return date
    }
    
    /// 带格式的时间转 时间戳，支持返回 13位 和 10位的时间戳，时间字符串和时间格式必须保持一致
    /// - Parameters:
    ///   - timeString: 时间字符串，如：2020-10-26 16:52:41
    ///   - formatter: 时间格式，如：yyyy-MM-dd HH:mm:ss
    ///   - timestampType: 返回的时间戳类型，默认是秒 10 为的时间戳字符串
    /// - Returns: 返回转化后的时间戳
    static func formatterTimeStringToTimestamp(timesString: String, formatter: String, timestampType: WYJTimestampType = .second) -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = formatter
        guard let date = dateFormatter.date(from: timesString) else {
            #if DEBUG
            fatalError("时间有问题")
            #else
            return ""
            #endif
        }
        if timestampType == .second {
            return "\(Int(date.timeIntervalSince1970))"
        }
        return "\(Int((date.timeIntervalSince1970) * 1000))"
    }
    
    /// 秒转换成播放时间条的格式
    /// - Parameters:
    ///   - secounds: 秒数
    ///   - type: 格式类型
    /// - Returns: 返回时间条
    static func getFormatPlayTime(seconds: Int, type: WYJTimeBarType = .normal) -> String {
        if seconds <= 0{
            return "00:00"
        }
        // 秒
        let second = seconds % 60
        if type == .second {
            return String(format: "%02d", seconds)
        }
        // 分钟
        var minute = Int(seconds / 60)
        if type == .minute {
            return String(format: "%02d:%02d", minute, second)
        }
        // 小时
        var hour = 0
        if minute >= 60 {
            hour = Int(minute / 60)
            minute = minute - hour * 60
        }
        if type == .hour {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }
        // normal 类型
        if hour > 0 {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }
        if minute > 0 {
            return String(format: "%02d:%02d", minute, second)
        }
        return String(format: "%02d", second)
    }
    
    /// 取得与当前时间的间隔差
    /// - Returns: 时间差
    func callTimeAfterNow() -> String {
        let timeInterval = Date().timeIntervalSince(obj)
        if timeInterval < 0 {
            return "刚刚"
        }
        let interval = fabs(timeInterval)
        let i60 = interval / 60
        let i3600 = interval / 3600
        let i86400 = interval / 86400
        let i2592000 = interval / 2592000
        let i31104000 = interval / 31104000
        
        var time:String!
        if i3600 < 1 {
            let s = NSNumber(value: i60 as Double).intValue
            if s == 0 {
                time = "刚刚"
            } else {
                time = "\(s)分钟前"
            }
        } else if i86400 < 1 {
            let s = NSNumber(value: i3600 as Double).intValue
            time = "\(s)小时前"
        } else if i2592000 < 1 {
            let s = NSNumber(value: i86400 as Double).intValue
            time = "\(s)天前"
        } else if i31104000 < 1 {
            let s = NSNumber(value: i2592000 as Double).intValue
            time = "\(s)个月前"
        } else {
            let s = NSNumber(value: i31104000 as Double).intValue
            time = "\(s)年前"
        }
        return time
    }
    
    /// 获取某一年某一月的天数
    /// - Parameters:
    ///   - year: 年份
    ///   - month: 月份
    /// - Returns: 返回天数
    static func daysCount(year: Int, month: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 4, 6, 9, 11:
            return 30
        case 2:
            let isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
            return isLeapYear ? 29 : 28
        default:
            fatalError("非法的月份:\(month)")
        }
    }
    
    /// 获取当前月的天数
    /// - Returns: 返回天数
    static func currentMonthDays() -> Int {
        return daysCount(year: Date.yi.currentDate.yi.year(), month: Date.yi.currentDate.yi.month())
    }
}

//MARK: --- 转换
public extension WYJProtocol where T ==  Date {
    //MARK: --- 将日期转换为字符串
    ///将日期转换为字符串
    func toString(format dateFormat: WYJDateFormatter = .dateModeYMDHMS,_ timeZone: TimeZone = NSTimeZone.system) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat.rawValue
        formatter.timeZone = timeZone
        let date = formatter.string(from: obj)
        return date
    }
    //MARK: --- 将日期转换为字符串
    ///将日期转换为字符串
    func toString(format formatstr: String,_ timeZone: TimeZone = NSTimeZone.system) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = formatstr
        formatter.timeZone = timeZone
        let date = formatter.string(from: obj)
        return date
    }
}

public extension WYJProtocol where T == Date {
    //MARK: --- 计算
    ///计算两时间差
    func calculate(_ formatter: String, startTime: String, endTime: String, timeZone: TimeZone? = nil) -> DateComponents? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = timeZone ?? TimeZone.init(secondsFromGMT: 8)
        dateFormatter.dateFormat = formatter
        if let date1 = dateFormatter.date(from: startTime),let date2 = dateFormatter.date(from: endTime) {
            let components = NSCalendar.current.dateComponents([.year,.month,.day], from: date1, to: date2)
            return components
        } else {
            return nil
        }
    }
    
    ///计算两时间差多少年
    func calculateYear(_ formatter: String, startTime: String, endTime: String, timeZone: TimeZone? = nil) -> Int? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = timeZone ?? TimeZone.init(secondsFromGMT: 8)
        dateFormatter.dateFormat = formatter

        if let date1 = dateFormatter.date(from: startTime),let date2 = dateFormatter.date(from: endTime) {
            let components = NSCalendar.current.dateComponents([.year], from: date1, to: date2)
            return components.year
        }
        return nil
    }
    
    ///计算两时间差多少月
    func calculateMonth(_ formatter: String, startTime: String, endTime: String, timeZone: TimeZone? = nil) -> Int? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = timeZone ?? TimeZone.init(secondsFromGMT: 8)
        dateFormatter.dateFormat = formatter

        if let date1 = dateFormatter.date(from: startTime),let date2 = dateFormatter.date(from: endTime) {
            let components = NSCalendar.current.dateComponents([.month], from: date1, to: date2)
            return components.month
        }
        return nil
    }
    
    ///计算两时间差多少天
    func calculateDay(_ formatter: String, startTime: String, endTime: String, timeZone: TimeZone? = nil) -> Int? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = timeZone ?? TimeZone.init(secondsFromGMT: 8)
        dateFormatter.dateFormat = formatter

        if let date1 = dateFormatter.date(from: startTime),let date2 = dateFormatter.date(from: endTime) {
            let components = NSCalendar.current.dateComponents([.day], from: date1, to: date2)
            return components.day
        }
        return nil
    }
    
    ///  当前到date经过了多少天
    func daysInBetweenDate(_ date: Date) -> Double {
        var diff = obj.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff / Double(WYJDate_day))
        return diff
    }

    ///  当前到date经过了多少小时
    func hoursInBetweenDate(_ date: Date) -> Double {
        var diff = obj.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff / Double(WYJDate_hour))
        return diff
    }

    ///  当前到date经过了多少分钟
    func minutesInBetweenDate(_ date: Date) -> Double {
        var diff = obj.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff / Double(WYJDate_minute))
        return diff
    }
    
    ///  当前到date经过了多少秒
    func secondsInBetweenDate(_ date: Date) -> Double {
        var diff = obj.timeIntervalSince1970 - date.timeIntervalSince1970
        diff = fabs(diff)
        return diff
    }
    
    ///  Easy creation of time passed String. Can be Years, Months, days, hours, minutes or seconds
    func timePassed() -> String {
        let date = Date()
        let calendar = Calendar.autoupdatingCurrent
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: obj, to: date, options: [])
        var str: String
        
        if components.year! >= 1 {
            components.year == 1 ? (str = "year"): (str = "years")
            return "\(components.year!) \(str) ago"
        } else if components.month! >= 1 {
            components.month == 1 ? (str = "month"): (str = "months")
            return "\(components.month!) \(str) ago"
        } else if components.day! >= 1 {
            components.day == 1 ? (str = "day"): (str = "days")
            return "\(components.day!) \(str) ago"
        } else if components.hour! >= 1 {
            components.hour == 1 ? (str = "hour"): (str = "hours")
            return "\(components.hour!) \(str) ago"
        } else if components.minute! >= 1 {
            components.minute == 1 ? (str = "minute"): (str = "minutes")
            return "\(components.minute!) \(str) ago"
        } else if components.second! >= 1 {
            components.second == 1 ? (str = "second"): (str = "seconds")
            return "\(components.second!) \(str) ago"
        } else {
            return "Just now"
        }
    }
    
    ///  Easy creation of time passed String. Can be Years, Months, days, hours, minutes or seconds. Useful for localization
    func timePassed() -> TimePassed {
        
        let date = Date()
        let calendar = Calendar.autoupdatingCurrent
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: obj, to: date, options: [])
        
        if components.year! >= 1 {
            return TimePassed.year(components.year!)
        } else if components.month! >= 1 {
            return TimePassed.month(components.month!)
        } else if components.day! >= 1 {
            return TimePassed.day(components.day!)
        } else if components.hour! >= 1 {
            return TimePassed.hour(components.hour!)
        } else if components.minute! >= 1 {
            return TimePassed.minute(components.minute!)
        } else if components.second! >= 1 {
            return TimePassed.second(components.second!)
        } else {
            return TimePassed.now
        }
    }
    
    //MARK: --- 检测
    //MARK: --- 是否未来
    ///  是否未来
    func future() -> Bool {
        return obj > Date()
    }
    //MARK: --- 是否过去
    ///  是否过去
    func isPast() -> Bool {
        return obj < Date()
    }
    //MARK: --- 今天
    //  今天
    func isToday() -> Bool {
        let dateFormatter = obj.getDateFormatter(for: .dateModeYMD)
        return dateFormatter.string(from: obj) == dateFormatter.string(from: Date())
    }
    //MARK: --- 昨天
    ///  昨天
    func isYesterday() -> Bool {
        let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let dateFormatter = obj.getDateFormatter(for: .dateModeYMD)
        return dateFormatter.string(from: obj) == dateFormatter.string(from: yesterDay!)
    }
    //MARK: --- 明天
    ///  明天
    func isTomorrow() -> Bool {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let dateFormatter = obj.getDateFormatter(for: .dateModeYMD)
        
        return dateFormatter.string(from: obj) == dateFormatter.string(from: tomorrow!)
    }
    //MARK: --- 在本月内
    ///  在本月内
    func isThisMonth() -> Bool {
        let today = Date()
        return month() == today.yi.month() && year() == today.yi.year()
    }
    //MARK: --- 在本周内
    ///  在本周内
    func isThisWeek() -> Bool {
        return minutesInBetweenDate(Date()) <= Double(Date.minutesInAWeek)
    }
    //MARK: --- era
    ///  era
    func era() -> Int {
        return Calendar.current.component(.era, from: obj)
    }
    //MARK: --- 年
    ///  年
    func year() -> Int {
        return Calendar.current.component(.year, from: obj)
    }
    //MARK: --- 月
    ///  月
    func month() -> Int {
        return Calendar.current.component(.month, from: obj)
    }
    //MARK: --- 工作日
    ///  工作日
    func weekdayString() -> String {
        let dateFormatter = obj.getDateFormatter(for: .dateModeE)
        return dateFormatter.string(from: obj)
    }
    //MARK: --- 月
    ///  月
    var monthString:  String {
        let dateFormatter = obj.getDateFormatter(for: .dateModeM)
        return dateFormatter.string(from: obj)
    }
    //MARK: --- 天
    ///  天
    var day: Int {
        return Calendar.current.component(.day, from: obj)
    }
    //MARK: --- 时
    ///  时
    var hour: Int {
        return Calendar.current.component(.hour, from: obj)
    }
    //MARK: --- 分钟
    ///  分钟
    var minute: Int {
        return Calendar.current.component(.minute, from: obj)
    }
    //MARK: --- 秒
    ///  秒
    var second: Int {
        return Calendar.current.component(.second, from: obj)
    }
    //MARK: --- 纳秒
    ///  纳秒
    var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: obj)
    }
}

public extension Date {
    static let minutesInAWeek = WYJDate_week
    //MARK: --- 初始化
    ///  初始化
    init?(fromString string: String,
                 format: String,
                 timezone: TimeZone = TimeZone.autoupdatingCurrent,
                 locale: Locale = Locale.current) {
        if let dateFormatter = DateFormattersManager.dateFormatters.getValue(for: format) {
            if let date = dateFormatter.date(from: string) {
                self = date
            } else {
                return nil
            }
        } else {
            let formatter = DateFormatter()
            formatter.timeZone = timezone
            formatter.locale = locale
            formatter.dateFormat = format
            DateFormattersManager.dateFormatters.setValue(for: format, value: formatter)
            if let date = formatter.date(from: string) {
                self = date
            } else {
                return nil
            }
        }
    }
    
    ///  Initializes Date from string returned from an http response, according to several RFCs / ISO
    init?(httpDateString: String) {
        if let rfc1123 = Date(fromString: httpDateString, format: "EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss zzz") {
            self = rfc1123
            return
        }
        if let rfc850 = Date(fromString: httpDateString, format: "EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z") {
            self = rfc850
            return
        }
        if let asctime = Date(fromString: httpDateString, format: "EEE MMM d HH':'mm':'ss yyyy") {
            self = asctime
            return
        }
        if let iso8601DateOnly = Date(fromString: httpDateString, format: "yyyy-MM-dd") {
            self = iso8601DateOnly
            return
        }
        if let iso8601DateHrMinOnly = Date(fromString: httpDateString, format: "yyyy-MM-dd'T'HH:mmxxxxx") {
            self = iso8601DateHrMinOnly
            return
        }
        if let iso8601DateHrMinSecOnly = Date(fromString: httpDateString, format: "yyyy-MM-dd'T'HH:mm:ssxxxxx") {
            self = iso8601DateHrMinSecOnly
            return
        }
        if let iso8601DateHrMinSecMs = Date(fromString: httpDateString, format: "yyyy-MM-dd'T'HH:mm:ss.SSSxxxxx") {
            self = iso8601DateHrMinSecMs
            return
        }
        return nil
    }
    
    ///时间戳初始化m 
    init?(_ timeInterval: Double) {
        self = Date.init(timeIntervalSince1970: timeInterval)
    }
    
    //MARK: --- 格式化
    ///  格式化
    fileprivate func getDateFormatter(for format: WYJDateFormatter) -> DateFormatter {
        
        var dateFormatter: DateFormatter?
        if let _dateFormatter = DateFormattersManager.dateFormatters.getValue(for: format.rawValue) {
             dateFormatter = _dateFormatter
        } else {
            dateFormatter = createDateFormatter(for: format.rawValue)
        }
        
        return dateFormatter!
    }

    //MARK: --- 格式化
    /// 格式化
    fileprivate func createDateFormatter(for format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        DateFormattersManager.dateFormatters.setValue(for: format, value: formatter)
        return formatter
    }
}

public enum TimePassed {
    case year(Int)
    case month(Int)
    case day(Int)
    case hour(Int)
    case minute(Int)
    case second(Int)
    case now
}

extension TimePassed: Equatable {
    
    public static func == (lhs: TimePassed, rhs: TimePassed) -> Bool {
        
        switch(lhs, rhs) {
            
        case (.year(let a), .year(let b)):
            return a == b
            
        case (.month(let a), .month(let b)):
            return a == b
            
        case (.day(let a), .day(let b)):
            return a == b
            
        case (.hour(let a), .hour(let b)):
            return a == b
            
        case (.minute(let a), .minute(let b)):
            return a == b
            
        case (.second(let a), .second(let b)):
            return a == b
            
        case (.now, .now):
            return true
            
        default:
            return false
        }
    }
}

public class SynchronizedDictionary <Key: Hashable, Value> {
    
    fileprivate let queue = DispatchQueue(label: "SynchronizedDictionary", attributes: .concurrent)
    fileprivate var dict = [Key: Value]()
    
    public func getValue(for key: Key) -> Value? {
        var value: Value?
        queue.sync {
            value = dict[key]
        }
        return value
    }
    
    public func setValue(for key: Key, value: Value) {
        queue.sync {
            dict[key] = value
        }
    }
    public func getSize() -> Int {
        return dict.count
    }
    
    public func containValue(for key: Key) -> Bool {
        guard let _ = dict.index(forKey: key) else {
            return false
        }
        return true
    }
}

//MARK: --- 前后时间
public extension WYJProtocol where T == Date {
    //MARK: --- 加几天
    ///加几天
    func addingDay(_ days: Int) -> Date? {
        var c = DateComponents()
        c.day = days
        let calender = Calendar(identifier: .chinese)
        
        return calender.date(byAdding: c, to: obj)
    }
    //MARK: --- 减几天
    ///减几天
    func subtractingDay(_ days: Int) -> Date? {
        var c = DateComponents()
        c.day = days * -1
        let calender = Calendar(identifier: .chinese)
        
        return calender.date(byAdding: c, to: obj)
    }
    //MARK: --- 增加几小时
    ///增加几小时
    func addingHours(_ dHours: Int) -> Date? {
        let aTimeInterval = TimeInterval(obj.timeIntervalSinceReferenceDate + Double(WYJDate_hour * dHours))
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    //MARK: --- 减少几小时
    ///减少几小时
    func subtractingHours(_ dHours: Int) -> Date {
        let aTimeInterval = TimeInterval(obj.timeIntervalSinceReferenceDate - Double(WYJDate_hour * dHours))
        let newDate = Date(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    ///转时间戳
    func toCurrentTimeStamp(_ isMS:Bool = true) ->Int? {
        let dateFormatter = DateFormatter()
        var format = "yyyy-MM-dd HH:mm:ss.SSS"
        if isMS == false {
            format = "yyy-MM-dd HH:mm:ss"
        }
        dateFormatter.dateFormat = format
        let dataString = dateFormatter.string(from: obj)
        
        if let date = dateFormatter.date(from: dataString) {
            let stamp = date.timeIntervalSince1970
            return isMS ? Int(stamp * 1000) : Int(stamp)
        }
        return nil
    }
}
