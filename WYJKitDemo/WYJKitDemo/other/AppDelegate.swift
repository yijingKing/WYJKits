//
//  AppDelegate.swift
//  YJSwiftKit
//
//  Created by Mac on 2020/6/19.
//  Copyright © 2020 祎. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        #if DEBUG
                // 把InjectionIII.app换成InjectionX.app
                Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
                #endif
        window?.rootViewController = WYJBaseNavigationController.init(rootViewController: ViewController())
        return true
    }

}

