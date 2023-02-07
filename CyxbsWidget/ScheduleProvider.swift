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
        var entry = ScheduleTimelineEntry(date: Date())
        return entry
    }
    
    func getSnapshot(for configuration: ScheduleWidgetConfiguration, in context: Context, completion: @escaping (ScheduleTimelineEntry) -> ())  {
        
        var entry = ScheduleTimelineEntry(date: Date())
        
        let item1 = ScheduleCombineItem.priview2021215154
        let item2 = ScheduleCombineItem.priview2022214857
        entry.model.append(item1)
        entry.model.append(item2)
        entry.mainKey = ScheduleCombineItem.priview2021215154.identifier
        
        if context.isPreview {
            
            entry.section = 0
            
        } else {
            
            entry.section = nil

        }
        
        completion(entry)
    }
    
    func getTimeline(for configuration: ScheduleWidgetConfiguration, in context: Context, completion: @escaping (Timeline<ScheduleTimelineEntry>) -> ()) {
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        var entries: [ScheduleTimelineEntry] = []
        
        let entry = ScheduleTimelineEntry(date: Date())
        Task {
            do {
                let item = try await ScheduleWidgetRequest.shared.request(sno: "2021215154")
                entry.model.append(item!)
            } catch {
                print("Request failed with error: \(error)")
            }
        }
        
        
        entries.append(entry)
        
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: Date())!
//            var entry = ScheduleTimelineEntry(date: entryDate)
//            let item1 = ScheduleCombineItem.priview2021215154
//            let item2 = ScheduleCombineItem.priview2022214857
//            entry.model.append(item1)
//            entry.model.append(item2)
//            entry.mainKey = ScheduleCombineItem.priview2021215154.identifier
//            entries.append(entry)
//        }
        
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
