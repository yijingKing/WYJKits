/*******************************************************************************
 Copyright (K), 2019 - ~, ╰莪呮想好好宠Nǐつ
 
 Author:        ╰莪呮想好好宠Nǐつ
 E-mail:        1091676312@qq.com
 GitHub:        https://github.com/MemoryKing
 *******************************************************************************/


import Foundation
import IQKeyboardManagerSwift


public class WYJKeyboard {
    
    public static func open(_ block: ((IQKeyboardManager)->())? = nil) {
        let manager = IQKeyboardManager.shared
        manager.enable = true
        //控制点击背景是否收起键盘
        manager.shouldResignOnTouchOutside = true
        //将右边Done改成完成
        manager.toolbarDoneBarButtonItemText = "OK"
        //最新版的设置键盘的returnKey的关键字 ,可以点击键盘上的next键，自动跳转到下一个输入框，最后一个输入框点击完成，自动收起键盘
        manager.toolbarManageBehaviour = .byPosition
        block?(manager)
        
    }
}


