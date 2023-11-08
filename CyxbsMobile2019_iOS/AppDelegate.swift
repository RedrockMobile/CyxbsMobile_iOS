//
//  AppDelegate.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/1.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupWindow()
        setupAlicloudSDK()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        setupEnd()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        setupEnd()
    }
}

// MARK: setup

extension AppDelegate {
    
    func setupWindow() {
        let rootVC = TabBarController()
        
        window = UIWindow()
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    func setupAlicloudSDK() {
        AliyunConfig.ip(byHost: APIConfig.current.environment.host)
    }
    
    func setupEnd() {
        UserDefaultsManager.shared.latestOpenApp = Date()
    }
}
