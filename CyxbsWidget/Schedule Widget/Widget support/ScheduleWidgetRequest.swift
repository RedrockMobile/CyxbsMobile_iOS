//
//  ScheduleWidgetRequest.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2023/2/7.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

final class ScheduleWidgetRequest {
    
    static let shared = ScheduleWidgetRequest()
    
    private init() {
    }
    
    func request(sno: String) async throws -> ScheduleCombineItem? {
        let request = NSMutableURLRequest(url: URL(string: "https://be-prod.redrock.cqupt.edu.cn/magipoke-jwzx/kebiao?stu_num=\(sno)")!)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let response = try await URLSession.shared.data(for: request as URLRequest)
        print("Requet success with response: \(response)")
        if let dic = JSON(response.0).dictionary {
            let sno = dic["stuNum"]?.string!
            let nowWeek = dic["nowWeek"]?.int!
            
            let key = ScheduleIdentifier(sno: sno!, type: .student)!
            key.setExpWithNowWeek(nowWeek!)
            
            let ary = dic["data"]?.arrayObject!
            var finalAry = [ScheduleCourse]()
            for dic in ary! {
                let course = ScheduleCourse(dictionary: dic as! Dictionary<AnyHashable, Any>)
                finalAry.append(course)
            }
            let item = ScheduleCombineItem(identifier: key, value: finalAry)
            return item
        } else {
            if let key = ScheduleIdentifier(sno: sno, type: .student), key.useWebView {
                return ScheduleShareCache.memoryItem(forKey: key, forKeyName: nil)
            }
            return nil
        }
    }
    
    var custom: ScheduleCombineItem? {
        ScheduleShareCache.memoryItem(forKey: nil, forKeyName: .custom)
    }
}
