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
                
                let mainKey = ScheduleShareCache.memoryKey(forKey: nil, forKeyName: .main)
                let customKey = ScheduleShareCache.memoryKey(forKey: nil, forKeyName: .custom)
                let otherKey = ScheduleShareCache.memoryKey(forKey: nil, forKeyName: .other)
                
                var mainItem: ScheduleCombineItem?
                var otherItem: ScheduleCombineItem?
                var customItem: ScheduleCombineItem?
                
                if let mainKey = mainKey {
                    if mainKey.useWidget {
                        mainItem = try await ScheduleWidgetRequest.shared.request(sno: mainKey.sno)
                    }
                    if let customKey = customKey, customKey.useWidget {
                        customItem = ScheduleWidgetRequest.shared.custom
                    }
                    if let otherKey = otherKey, otherKey.useWidget {
                        otherItem = try await ScheduleWidgetRequest.shared.request(sno: otherKey.sno)
                    }
                }
                
                let currentDate = Date()
                for hourOffset in 0 ..< 12 {
                    let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!

                    let entry = ScheduleTimelineEntry(date: entryDate)
                    if let main = mainItem {
                        entry.combineItems.append(main)
                        entry.mainKey = main.identifier
                    } else {
                        if let mainKey = mainKey {
                            entry.errorMsg = mainKey.description
                        }
                    }
                    
                    if let other = otherItem {
                        entry.combineItems.append(other)
                    } else {
                        if let otherKey = otherKey {
                            entry.errorMsg = entry.errorMsg ?? "" + otherKey.description
                        }
                    }
                    
                    if let customItem = customItem {
                        entry.combineItems.append(customItem)
                    }
                    
                    entries.append(entry)
                }
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }
}
