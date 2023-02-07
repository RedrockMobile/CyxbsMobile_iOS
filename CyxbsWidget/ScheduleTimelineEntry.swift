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
    var date: Date // update time
    var mainKey: ScheduleIdentifier?
    var model: [ScheduleCombineItem]
    var section: Int?
    let configuration: ScheduleWidgetConfiguration
    
    init(date: Date, model: [ScheduleCombineItem] = []) {
        self.date = date
        self.configuration = ScheduleWidgetConfiguration()
        self.model = model
    }
}
