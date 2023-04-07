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
    
    /* errorKeys
     * 与网络请求搭配，错误的请求信息将在这里添加
     */
    var errorMsg: String?
    
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
