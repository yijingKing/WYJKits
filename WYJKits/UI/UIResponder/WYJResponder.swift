/*******************************************************************************
 Copyright (K), 2019 - ~, ╰莪呮想好好宠Nǐつ
 
 Author:        ╰莪呮想好好宠Nǐつ
 E-mail:        1091676312@qq.com
 GitHub:        https://github.com/MemoryKing
 *******************************************************************************/


import Foundation
import UIKit

public extension UIResponder {
    ///InjectionIII
    func hotReload(_ appName: String = "InjectionIII") {
        #if DEBUG
        // 把InjectionIII.app换成InjectionX.app
        Bundle(path: "/Applications/\(appName).app/Contents/Resources/iOSInjection.bundle")?.load()
        #endif
    }
}
