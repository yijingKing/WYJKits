/*******************************************************************************
Copyright (K), 2019 - ~, ╰莪呮想好好宠Nǐつ

Author:        ╰莪呮想好好宠Nǐつ 
E-mail:        1091676312@qq.com
GitHub:        https://github.com/MemoryKing
********************************************************************************/

import UIKit
import LocalAuthentication

///指纹
open class QYTouchIDManager: NSObject {
    public static let share = QYTouchIDManager()
    //MARK: --- 开启
    ///开启
    public func yi_touchID (reply: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // 开始进入识别状态，以闭包形式返回结果。闭包的 success 是布尔值，代表识别成功与否。error 为错误信息。
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "请用指纹解锁", reply: reply)
        } else {
            reply(false,nil)
        }
    }
    
    public func errorMessageForLAErrorCode(errorCode: Int) -> String {
        var message = ""
        
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "身份验证被应用程序取消"
            
        case LAError.authenticationFailed.rawValue:
            message = "用户未能提供有效的凭据"
            
        case LAError.invalidContext.rawValue:
            message = "上下文无效"
            
        case LAError.passcodeNotSet.rawValue:
            message = "设备上没有设置密码"
            
        case LAError.systemCancel.rawValue:
            message = "系统取消了认证"
        case kLAErrorBiometryLockout.hashValue:
            message = "失败的尝试太多了。"
        case kLAErrorBiometryNotAvailable.hashValue:
            message = "TouchID在设备上不可用"
            
        case LAError.userCancel.rawValue:
            message = "用户取消了"
            
        case LAError.userFallback.rawValue:
            message = "用户选择使用回退"
            
        default:
            message = "在LAError对象上没有找到错误代码"
        }
        return message
    }
}
