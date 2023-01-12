//
//  ScheduleWidgetPriview.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2023/1/11.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

extension ScheduleCombineItem {
    
    static var priviewMainSno = "2021215154"
    
    static var priview2021215154: ScheduleCombineItem {
        priviewItem(sno: "2021215154", source: "Schedule.2021215154")
    }
    
    static var priview2022214857: ScheduleCombineItem {
        priviewItem(sno: "2022214857", source: "Schedule.2022214857")
    }
    
    private class func priviewItem(sno: String, source: String) -> ScheduleCombineItem {
        let id = ScheduleIdentifier(sno: sno, type: .student)
        id.exp = 1662369467
        let url = Bundle.main.url(forResource: source, withExtension: "plist")
        let ary = try! NSArray(contentsOf: url!, error: ()) as! [ScheduleCourse]?
        let item = ScheduleCombineItem(identifier: id, value: ary)
        return item
    }
}

extension ScheduleWidgetModel {
    
    static var priviewSection = 13
    
    static var priview: ScheduleWidgetModel {
        let model = ScheduleWidgetModel(showSection: priviewSection, showRange: 1..<7)
        model.sno = ScheduleCombineItem.priviewMainSno
        model.combineItem(.priview2021215154)
        model.combineItem(.priview2022214857)
        model.finishCombine()
        return model
    }
}
