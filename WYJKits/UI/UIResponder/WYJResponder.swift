//
//  File.swift
//  WYJKitDemo
//
//  Created by 祎 on 2021/2/20.
//  Copyright © 2021 祎. All rights reserved.
//

import Foundation
import UIKit

public extension UIResponder {
    func hotReload(_ appName: String = "InjectionIII") {
        #if DEBUG
        // 把InjectionIII.app换成InjectionX.app
        Bundle(path: "/Applications/\(appName).app/Contents/Resources/iOSInjection.bundle")?.load()
        #endif
    }
}
