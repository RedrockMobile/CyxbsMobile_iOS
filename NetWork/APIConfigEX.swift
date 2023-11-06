//
//  APIConfigEX.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/10/7.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

extension APIConfig {
    
    func api(_ api: String) -> String {
        
        // IP 直连
        let host = environment.host
        if let ip = AliyunConfig.ip(byHost: host) {
            ipToHost[ip] = host
            return "https://" + ip + api
        }
        
        // 原URL请求
        let url = environment.url + api
        return url
    }
}
