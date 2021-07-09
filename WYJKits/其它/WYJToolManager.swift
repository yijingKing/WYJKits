/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit

//MARK: --- 设置别名
///设置别名
public typealias Byte  = Int8
public typealias Short = Int16
public typealias Long  = Int64

class WYJToolManager {
    static func compareVersion(v1:String,v2:String) -> Int {
        let arr1 = v1.components(separatedBy:".")
        let arr2 = v2.components(separatedBy:".")
        if arr1.count != 3 { return 2 }
        if arr2.count != 3 { return 1 }
        if (arr1[0] as NSString).integerValue > (arr2[0] as NSString).integerValue {
            return 1
        }else if (arr1[0] as NSString).integerValue < (arr2[0] as NSString).integerValue {
            return 2
        }else{
            if (arr1[1] as NSString).integerValue > (arr2[1] as NSString).integerValue {
                return 1
            }else if (arr1[1] as NSString).integerValue < (arr2[1] as NSString).integerValue {
                return 2
            }else{
                if (arr1[2] as NSString).integerValue > (arr2[2] as NSString).integerValue {
                    return 1
                }else if (arr1[2] as NSString).integerValue < (arr2[2] as NSString).integerValue {
                    return 2
                }else{
                    return 3
                }
            }
        }
    }
}


//MARK: --- 打印
///打印
public func WYJLog<T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line){
    
    #if DEBUG
    //获取当前时间
    let now = Date()
    //创建一个日期格式器
    let dformatter = DateFormatter()
    dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    //要把路径最后的字符串截取出来
    let lastName = ((fileName as NSString).pathComponents.last) ?? ""
    print("\(dformatter.string(from: now)) [\(lastName)][第\(lineNumber)行][函数名:\(methodName)] --->\n🤔🤔🤔\(message)🤔🤔🤔\n")
    
    #endif
}


