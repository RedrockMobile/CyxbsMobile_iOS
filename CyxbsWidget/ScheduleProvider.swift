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
        ScheduleTimelineEntry(date: Date())
    }
    
    func getSnapshot(for configuration: ScheduleWidgetConfiguration, in context: Context, completion: @escaping (ScheduleTimelineEntry) -> ())  {
        let date = Date()
        let entry = ScheduleTimelineEntry(date: Date())
        
        let id1 = ScheduleWidgetCache().getKeyWithKeyName(ScheduleWidgetCacheKeyMain, usingSupport: true)
        let id2 = ScheduleWidgetCache().getKeyWithKeyName(ScheduleWidgetCacheKeyOther, usingSupport: true)
        
        if context.isPreview {
            
            let item1 = ScheduleCombineItem.priview2021215154
            let item2 = ScheduleCombineItem.priview2022214857
            
            entry.model.sno = "2021215154"
            entry.model.combineItem(item1)
            entry.model.combineItem(item2)
            entry.model.finishCombine()
            
            completion(entry)
            
        } else {
            
            ScheduleNETRequest.request([
                .student : [id1.sno, id2.sno]
            ]) { item in
                entry.model.combineItem(item)
                completion(entry)
            } failure: { error, id in
                if ScheduleWidgetCache().allowedLocalCache {
                    let errorItem = ScheduleShareCache().awake(for: id)
                    
                }
            }

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
