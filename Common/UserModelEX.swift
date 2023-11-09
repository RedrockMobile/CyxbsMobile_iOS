//
//  UserModelEX.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2023/11/9.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

extension UserModel {
    
    mutating func setingTokenToOC(token: TokenModel) {
        self.token = token
        
        let item = UserItemTool.defaultItem()
        item.stuNum = token.stuNum
        item.gender = token.gender
        item.redid = token.redid
        item.exp = "\(token.exp)"
        item.iat = "\(token.iat)"
        item.token = token.token
        item.refreshToken = token.refreshToken
    }
}
