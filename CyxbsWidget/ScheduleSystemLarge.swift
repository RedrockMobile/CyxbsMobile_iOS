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
    var body: some View {
        HStack(spacing: 2) {
            ScheduleLeadingView(month: "1月", range: 1..<9)
                .frame(width: 29)
                .padding(.top, 17)
            VStack {
                GeometryReader { entry in
                    ScheduleTopView()
                        .frame(height: 46)
                    
                }
            }
        }
        .padding(.all, 5)
    }
}





struct ScheduleSystemLarge_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleSystemLarge(entry: .init(date: NSDate.now))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
