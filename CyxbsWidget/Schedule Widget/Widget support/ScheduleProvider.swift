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
        let entry = ScheduleTimelineEntry(date: Date())
        return entry
    }
    
    func getSnapshot(for configuration: ScheduleWidgetConfiguration, in context: Context, completion: @escaping (ScheduleTimelineEntry) -> ())  {
        
        let entry = ScheduleTimelineEntry(date: Date())
        
        let item1 = ScheduleCombineItem.priview2021215154
        let item2 = ScheduleCombineItem.priview2022214857
        entry.combineItems.append(item1)
        entry.combineItems.append(item2)
        entry.mainKey = ScheduleCombineItem.priview2021215154.identifier
        
        if context.isPreview {
            entry.section = 0
        } else {
            entry.section = nil
        }
        
        completion(entry)
    }
    
    func getTimeline(for configuration: ScheduleWidgetConfiguration, in context: Context, completion: @escaping (Timeline<ScheduleTimelineEntry>) -> ()) {
        Task {
            do {
                var entries: [ScheduleTimelineEntry] = []
                for hourOffset in 0 ..< 7 {
                    let currentDate = Date()
                    let entryDate = Calendar.current.date(byAdding: .day, value: hourOffset, to: currentDate)!
                    let entry = ScheduleTimelineEntry(date: entryDate)
                    entries.append(entry)

                    if let item = try await ScheduleWidgetRequest.shared.request(sno: "2021215154") {
                        entry.combineItems.append(item)
                        entry.mainKey = item.identifier
                    }
                }
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }
}
