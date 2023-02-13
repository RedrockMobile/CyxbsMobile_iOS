//
//  ScheduleTimelineEntry.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2023/1/11.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import WidgetKit
import Intents

class ScheduleTimelineEntry: TimelineEntry {
    let date: Date // update time
    
    /* configuration
     * 如果以后采用动态的configuration时，请注意创建的方法
     */
    let configuration: ScheduleWidgetConfiguration
    
    /* combineItems
     * 与网络请求搭配，为timeline提供数据源信息
     */
    var combineItems = [ScheduleCombineItem]()
    
    /* mainKey
     * 提供mainKey用力绘制双人课表，nil则不绘制
     */
    var mainKey: ScheduleIdentifier?
    
    /* section
     * nil则表示跟随变化而变化，非nil则表示固定某个周
     * 注意在后期数据处理的时候，是否与configuration有重复定义
     */
    var section: Int?
    
    
    init(date: Date) {
        self.date = date
        self.configuration = ScheduleWidgetConfiguration()
    }
}

extension ScheduleTimelineEntry {
    class func getUpdates() -> [Date] {
        let today = Date()
        var updates = [Date]()
        let canlaner = Calendar(identifier: .republicOfChina)
        let nowHour = canlaner.component(.hour, from: today)
        
        updates.append(canlaner.date(bySettingHour: 6, minute: 00, second: 00, of: today)!)
        updates.append(canlaner.date(bySettingHour: 8, minute: 00, second: 00, of: today)!)
        updates.append(canlaner.date(bySettingHour: 12, minute: 00, second: 00, of: today)!)
        updates.append(canlaner.date(bySettingHour: 14, minute: 00, second: 00, of: today)!)
        updates.append(canlaner.date(bySettingHour: 16, minute: 00, second: 00, of: today)!)
        updates.append(canlaner.date(bySettingHour: 18, minute: 00, second: 00, of: today)!)
        updates.append(canlaner.date(bySettingHour: 20, minute: 00, second: 00, of: today)!)
        updates.append(canlaner.date(bySettingHour: 22, minute: 00, second: 00, of: today)!)
        
        var new = updates.filter { canlaner.component(.hour, from: $0) >= nowHour }
        new.insert(Date(), at: 0)
        
        return new
    }
    
    
}
