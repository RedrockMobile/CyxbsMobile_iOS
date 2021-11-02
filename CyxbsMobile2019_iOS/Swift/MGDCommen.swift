//
//  MGDCommen.swift
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

import Foundation

func BaseURL() -> NSString {
    let baseURL = UserDefaults.standard.string(forKey: "baseURL")
    return baseURL! as NSString
}
