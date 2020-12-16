/*******************************************************************************
Copyright (K), 2020 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/


import UIKit

///设备
public extension UIDevice {
    //MARK: --- 系统名
    ///系统名
    static var yi_system_name: String {
        return UIDevice.current.systemName
    }
    //MARK: --- 系统版本
    ///系统版本
    static var yi_system_version: String {
        return UIDevice.current.systemVersion
    }
    //MARK: --- uuid
    ///uuid
    static var yi_idForVendor: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    //MARK: --- 设备名
    //设备名
    static var yi_deviceName: String {
        return UIDevice.current.name
    }
    //MARK: --- 设备语言
    ///设备语言
    static var yi_deviceLanguage: String {
        return Bundle.main.preferredLocalizations[0]
    }
    //MARK: --- 是否是手机
    ///是否是手机
    static var yi_isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    //MARK: --- 是否是iPad
    ///是否是iPad
    static var yi_isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    //MARK: --- ///设备型号
    ///设备型号
    static var yi_model = UIDevice.current.model
    //MARK: --- ///设备区域化型号
    ///设备区域化型号
    static var yi_localizedModel = UIDevice.current.localizedModel
}
