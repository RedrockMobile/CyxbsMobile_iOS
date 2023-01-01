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
    var body: some View {
        HStack(spacing: 2) {
            ScheduleLeadingView(month: "1月", range: 1..<9, height: 46)
                .frame(width: 29)
            GeometryReader { entry in
                VStack(spacing: 2) {
                    ScheduleTopView()
                        .frame(height: 46)
                    HStack(spacing: 2) {
                        ForEach(0..<data.data.count, id: \.self) { idx in
                            let ary = data.data[idx]
                            VStack(spacing: 2) {
                                ForEach(ary) { context in
                                    ScheduleContentView(title: context.title, content: context.content, draw: draw(context), muti: context.muti)
                                        .frame(height: height(context, prepear: entry.size.height - 46))
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.all, 10)
    }
}

extension ScheduleSystemLarge {
    func draw(_ entry: ScheduleSimpleEntry) -> ScheduleContentView.DrawType {
        switch entry.belong {
        case .myself:
            if entry.locate <= 4 {
                return .morning
            } else if entry.locate <= 8 {
                return .afternoon
            } else {
                return .night
            }
        case .custom:
            return .custem
        case .others:
            return .other
        case .empty:
            return .empty
        }
    }
    func height(_ entry: ScheduleSimpleEntry, prepear: CGFloat) -> CGFloat {
        let side = (prepear - 2 * 7) / 8
        return CGFloat(entry.lenth) * side + CGFloat((entry.lenth - 1) * 2)
    }
}





struct ScheduleSystemLarge_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleSystemLarge(entry: .init(date: NSDate.now), data: ScheduleFetchData())
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
