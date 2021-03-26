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
        hotReload()
        
        WYJKeyboard.open({_ in
            
        })
        window?.rootViewController = WYJBaseNavigationController.init(rootViewController: ViewController())
        return true
    }

}


