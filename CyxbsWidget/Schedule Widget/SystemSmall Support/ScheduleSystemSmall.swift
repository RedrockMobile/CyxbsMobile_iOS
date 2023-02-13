//
//  ScheduleSystemSmall.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2022/12/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

import SwiftUI
import WidgetKit

struct ScheduleSystemSmall: View {
    var entry: ScheduleProvider.Entry
    var data: ScheduleFetchData
    
    init(entry: ScheduleProvider.Entry) {
        self.entry = entry
        let hour = Calendar(identifier: .republicOfChina).dateComponents(in: TimeZone(identifier: "Asia/Chongqing")!, from: entry.date).hour!
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
        data = ScheduleFetchData(range: range, section: entry.section)
        data.sno = entry.mainKey?.sno
        for item in entry.combineItems {
            data.combineItem(item)
        }
    }
    
    var body: some View {
        HStack {
            Text("")
        }
    }
}

struct ScheduleSystemSmall_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleSystemSmall(entry: ScheduleTimelineEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
