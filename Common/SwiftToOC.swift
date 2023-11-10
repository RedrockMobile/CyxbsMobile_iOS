//
//  LoginOut.swift
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2023/11/10.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class SwiftToOC: NSObject {

    @objc
    class func loginOut() {
        UserModel.defualt.logout()
        
        let loginVC = RYLoginViewController()
        loginVC.modalPresentationStyle = .fullScreen

        guard let tabBarVC = UIApplication.shared.delegate?.window??.rootViewController as? UITabBarController else {
            return
        }
        
        if tabBarVC.presentedViewController != nil {
            tabBarVC.dismiss(animated: true) {
                tabBarVC.present(loginVC, animated: true, completion: nil)
            }
        } else {
            tabBarVC.present(loginVC, animated: true, completion: nil)
        }
        
        // 假销毁单例
        UserItem.default().attemptDealloc()
        
        let filePath = "\(NSTemporaryDirectory())" + "UserItem.data"
        
        // 删除偏好设置，删除时保留baseURL的偏好信息
        let dic = UserDefaults.standard.dictionaryRepresentation()
        for (key, _) in dic {
            if key != "baseURL" {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        
        // 删除归档
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            do {
                try fileManager.removeItem(atPath: filePath)
            } catch {
                print("Error removing file: \(error)")
            }
        }
        
        print(NSHomeDirectory())
        
        let remAndLesDataDirectoryPath = (NSHomeDirectory() as NSString).appendingPathComponent("Documents/rem&les")
        
        // 清除课表数据和备忘数据
        try? FileManager.default.removeItem(atPath: remAndLesDataDirectoryPath)
    
    }
    
}
