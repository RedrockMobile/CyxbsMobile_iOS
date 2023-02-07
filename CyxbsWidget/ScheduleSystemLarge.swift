//
//  ScheduleSystemLarge.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2022/12/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

import SwiftUI
import WidgetKit

struct ScheduleSystemLarge: View {
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
        for entry in entry.model {
            data.combineItem(entry)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScheduleSectionTopView(title: title())
                .padding(.vertical, 5)
            Divider()
                .padding(.horizontal, 5)
            
            GeometryReader { allEntry in
                VStack(spacing: 2) {
                    ScheduleTopView(anyDate: data.start, width: 21)
                        .frame(height: allEntry.size.width / 7)
                    
                    HStack {
                        ScheduleLeadingView(range: data.range)
                            .padding(.leading, 5)
                            .frame(width: 21)
                        GeometryReader { entryB in
                            ForEach(data.data) { item in
                                ContentView(item: item, size: entryB.size)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension ScheduleSystemLarge {
    
    func ContentView(item: ScheduleFetchData.PartItem, size: CGSize) -> some View {
        let itemHeight = (size.height - 2.0 * 7) / CGFloat(data.range.count)
        let itemWidth = (size.width - 2.0 * 6) / 7
        
        let vm = item.viewModel
        let idx = item.indexPath as NSIndexPath
        
        return ScheduleContentView(title: vm.title,
                                   content: vm.content,
                                   draw: draw(vm.kind, locate: idx.location),
                                   muti: vm.hadMuti)
        .frame(width: itemWidth, height: itemHeight * CGFloat(vm.lenth) + 2.0 * CGFloat(vm.lenth - 1))
        .padding(.top, (itemHeight + 2) * CGFloat(idx.location - data.range.lowerBound))
        .padding(.leading, (itemWidth + 2.0) * CGFloat(idx.week - 1) - 2)
        
        func draw(_ kind: ScheduleBelongKind = .fistSystem, locate: Int) -> ScheduleContentView.DrawType {
            switch kind {
            case .fistSystem:
                if locate <= 4 {
                    return .morning
                } else if locate <= 8 {
                    return .afternoon
                } else {
                    return .night
                }
            case .fistCustom:
                return .custem
            case .secondSystem:
                return .other
            @unknown default:
               return .empty
            }
        }
    }
    
    func title() -> String {
        if data.section <= 0 {
            return "整学期"
        } else {
            return "第\(data.section)周"
        }
    }
    
    func month() -> String {
        if let start = data.start {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "Asia/Chongqing")!
            formatter.locale = Locale(identifier: "zh_CN")
            formatter.dateFormat = "M月"
            return formatter.string(from: start)
        } else {
            return "学期"
        }
    }
}




struct ScheduleSystemLarge_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleSystemLarge(entry: ScheduleTimelineEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
