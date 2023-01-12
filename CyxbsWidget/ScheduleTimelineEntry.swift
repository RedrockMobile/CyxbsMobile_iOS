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

struct ScheduleTimelineEntry: TimelineEntry {
    let date: Date
    let model: ScheduleWidgetModel
    let configuration: ScheduleWidgetConfiguration
    init(date: Date, show: Int = 0) {
        self.date = date
        let hour = Calendar.current.dateComponents(in: TimeZone(identifier: "Asia/Chongqing")!, from: date).hour!
        let range: Range<Int>!
        if hour < 10 {
            range = 1..<7
        } else if hour < 12 {
            range = 3..<9
        } else if hour < 16 {
            range = 5..<11
        } else {
            range = 7..<13
        }
        model = ScheduleWidgetModel(showSection: show, showRange: range)
        self.configuration = ScheduleWidgetConfiguration()
    }
}
