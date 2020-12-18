/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import Foundation

///APP 信息
open class WYJAppInfo: NSObject {
    //MARK: --- App 名称
    ///App 名称
    public static var displayName: String {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as! String
    }
    //MARK: --- Bundle Identifier
    ///Bundle Identifier
    public static var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    //MARK: --- App 版本号
    ///App version 版本号
    public static var version: String {
        return Bundle.main.infoDictionary? ["CFBundleShortVersionString"] as! String
    }
    //MARK: --- Bulid 版本号
    //Bulid 版本号
    public static var buildVersion: String {
        return Bundle.main.infoDictionary? ["CFBundleVersion"] as! String
    }
}
