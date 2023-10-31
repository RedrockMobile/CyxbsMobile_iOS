//
//  AdminModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/21.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

struct AdminResponseData: Codable {
    let data: AdminDataItem
    let info: String
    let status: Int
}

struct AdminDataItem: Codable {
    let admin: Bool
}

