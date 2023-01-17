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
    init(date: Date) {
        self.date = date
        model = ScheduleWidgetModel()
        self.configuration = ScheduleWidgetConfiguration()
    }
}
