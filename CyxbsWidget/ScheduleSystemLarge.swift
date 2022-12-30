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
    var entry: Provider.Entry
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ScheduleSystemLarge_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleSystemLarge(entry: .init(date: NSDate.now))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
