//
//  UserModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/10/7.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    
    static var `defualt` = UserModel()
    
    private init() { }
    
    
    // token
    lazy var token: TokenModel? = {
        CacheManager.shared.getCodable(TokenModel.self, in: .token)
    }() {
        didSet {
            if let token {
                CacheManager.shared.cache(codable: token, in: .token)
                SessionManager.shared.token = token.token
                
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
    }
    
    // person
    lazy var person: PersonModel? = {
        CacheManager.shared.getCodable(PersonModel.self, in: .currentPerson)
    }() {
        didSet {
            if let person {
                CacheManager.shared.cache(codable: person, in: .currentPerson)
            }
        }
    }
    
    // custom
    lazy var customSchedule: ScheduleModel = {
        CacheManager.shared.getCodable(ScheduleModel.self, in: .customSchedule)
        ?? .init(sno: token?.stuNum ?? "临时学生", customType: .custom)
    }() {
        didSet {
            CacheManager.shared.cache(codable: customSchedule, in: .customSchedule)
        }
    }
     
    
    lazy var start: Date? = {
        UserDefaultsManager.widget.dateForSemester
    }() {
        didSet {
            if let start {
                UserDefaultsManager.widget.dateForSemester = start
            }
        }
    }
    
    mutating func nowWeek() -> Int? {
        
        guard let start else { return nil }
        
        let calendar = Calendar(identifier: .gregorian)
        
        let days = calendar.dateComponents([.day], from: start, to: Date()).day ?? 0
        
        return days / 7 + 1
    }
}
