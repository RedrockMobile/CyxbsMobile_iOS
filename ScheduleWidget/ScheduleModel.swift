//
//  ScheduleModel.swift
//  ScheduleWidgetExtension
//
//  Created by SSR on 2022/11/6.
//  Copyright © 2022 Redrock. All rights reserved.
//

import Foundation

struct ScheduleWidgetModel {
    struct WeekModel: Identifiable {
        var id: Date
        var items = [ScheduleCourse]()
    }
    var weeks = [WeekModel]()
    
    func awake(section: Int) {
        if let dic = (UserDefaults.widget?.dictionary(forKey: "schedule.request.dic")) {
            for entry in dic {
                if let ary: Array<String> = (entry.value as? Array<String>) {
                    for sno in ary {
                        let combine = ScheduleCombineModel(sno: sno, type: ScheduleModelRequestType(rawValue: entry.key))
                        combine.awake()
                        
                    }
                }
            }
        }
    }
}
