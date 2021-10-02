//
//  LoginModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/10/5.
//  Copyright © 2020 Redrock. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginModel: NSObject {
    
    class func loginWith(stuNum: String,
                         idNum: String,
                         success: @escaping () -> Void,
                         failed: @escaping () -> Void) {
        let params = [
            "stuNum": stuNum,
            "idNum": idNum
        ]

        let LoginURL = BaseURL() as String + "magipoke/token"
        guard let url = URL(string:LoginURL) else { return }
        
        SwiftyClient.shared.request(url, method: .post, headers: nil, parameters: params) { (response) in
            
            guard let response = response else {
                failed()
                return
            }
            
            let json = JSON(response)
            
            if let token = json["data"]["token"].string,
               let refreshToken = json["data"]["refreshToken"].string {
                let item = UserItemTool.defaultItem();
                // 保存token、refreshToke、账号、密码
                item.token = token
                item.refreshToken = refreshToken
                item.firstLogin = true
                UserDefaultTool.saveStuNum(stuNum)
                UserDefaultTool.saveIdNum(idNum)
                
                // 解码用户信息并保存
                let userInfo_Base64 = token.split(separator: ".")[0]
                if let data = Data(base64Encoded: String(userInfo_Base64)) {
                    do {
                        let userInfo = try JSON(data: data)
                        UserItem.mj_object(withKeyValues: userInfo.dictionaryObject ?? nil)
                        
                        success()
                        //
                        UserDefaults.standard.setValue(getLastLogInTime(), forKey: LastLogInTimeKey_double)
                        NotificationCenter.default.postNotificationOnMainThread(withName: "Login_LoginSuceeded", object: nil, userInfo: ["userItem": item])
                        
                        
                        
                    } catch {
                        // 解码失败调用failed
                        failed()
                    }
                }
                
            } else {
                failed()
            }
            
            
        }
        
    }
    class func getLastLogInTime() -> TimeInterval {
        return Date.timeIntervalSinceReferenceDate + Date.timeIntervalBetween1970AndReferenceDate
    }
    
    class func BaseURL() -> NSString {
        let baseURL = UserDefaults.standard.string(forKey: "baseURL")
        return baseURL! as NSString
    }

}
