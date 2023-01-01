//
//  ScheduleTopView.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2023/1/1.
//  Copyright © 2023 Redrock. All rights reserved.
//

import SwiftUI
import WidgetKit

struct ScheduleTopView: View {
    var anyDate: Date?
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(data(), id: \.self) { entry in
                ScheduleSupplementaryView(title: title(entry), content: content(entry), target: target(entry))
            }
        }
    }
}

extension ScheduleTopView {
    func data() -> Array<Date> {
        var components = Calendar.current.dateComponents(in: TimeZone(identifier: "Asia/Chongqing")!, from: anyDate ?? Date())
        let weekday = (components.weekday! + 6) % 8 + (components.weekday! + 6) / 8;
        components.day! -= weekday - 1
        
        var ary = [Date]()
        for _ in 0..<7 {
            ary.append(components.date!)
            components.day! += 1
        }
        return ary
    }
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Chongqing")!
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }
    
    func title(_ date: Date) -> String {
        let formatter = formatter
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    func content(_ date: Date) -> String? {
        if anyDate != nil {
            let formatter = formatter
            formatter.dateFormat = "d日"
            return formatter.string(from: date)
        } else {
            return nil
        }
    }
    
    func target(_ date: Date) -> Bool { Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedSame
    }
}

struct ScheduleTopView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ScheduleTopView(anyDate: Date())
                .frame(width: 312, height: 46)
            ScheduleTopView()
                .frame(width: 312, height: 46)
        }
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
