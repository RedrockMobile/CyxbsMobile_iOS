//
//  ScheduleWidgetEntryView.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2022/12/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

import SwiftUI
import WidgetKit

struct ScheduleWidgetEntryView: View {
    var entry: ScheduleProvider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            ScheduleSystemSmall()
        case .systemLarge:
            ScheduleSystemLarge(entry: entry, data: ScheduleFetchData())
        default:
            EmptyView()
        }
    }
}
