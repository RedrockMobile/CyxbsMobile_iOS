//
//  ScheduleWidgetEntryView.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/5.
//  Copyright © 2022 Redrock. All rights reserved.
//

import SwiftUI
import WidgetKit
import Intents

struct ScheduleWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            EmptyView()
        case .systemMedium:
            EmptyView()
        case .systemLarge:
            ScheduleWidgetLarge(entry: entry)
        case .systemExtraLarge:
            EmptyView()
        case .accessoryCorner:
            EmptyView()
        case .accessoryCircular:
            EmptyView()
        case .accessoryRectangular:
            EmptyView()
        case .accessoryInline:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
}

struct ScheduleWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleWidgetEntryView(entry: .init(date: Date()))
    }
}
