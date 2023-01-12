//
//  Provider.swift
//  CyxbsWidget
//
//  Created by SSR on 2022/12/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

typealias ScheduleWidgetConfiguration = ConfigurationIntent

struct ScheduleProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> ScheduleTimelineEntry {
        ScheduleTimelineEntry(date: Date(), show: ScheduleWidgetModel.priviewSection)
    }
    
    func getSnapshot(for configuration: ScheduleWidgetConfiguration, in context: Context, completion: @escaping (ScheduleTimelineEntry) -> ())  {
        let date = Date()
        let entry: ScheduleTimelineEntry!
        
        if context.isPreview {
            entry = .init(date: Date())
        } else {
            let model = ScheduleWidgetModel(showSection: 0, showRange: 1..<7)
            
            entry = ScheduleTimelineEntry(date: Date(), show: 13)
        }
        
        completion(entry)
    }
    
    func getTimeline(for configuration: ScheduleWidgetConfiguration, in context: Context, completion: @escaping (Timeline<ScheduleTimelineEntry>) -> ()) {
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        var entries: [ScheduleTimelineEntry] = []
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = ScheduleTimelineEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
