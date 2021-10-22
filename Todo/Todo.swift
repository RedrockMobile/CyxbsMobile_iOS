//
//  Todo.swift
//  Todo
//
//  Created by 杨远舟 on 2021/10/21.
//  Copyright © 2021 Redrock. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}


struct TodoEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack{
            VStack{
                Spacer()
                HStack{
                    Button(action: {
                    print("点击了列表按钮")
                    }) {
                    Image("weight_list")
                            .resizable()
                            .frame(width: 16, height: 13.8)
                    }
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    Spacer()
                    Button(action: {
                    print("点击了列表按钮")
                    }) {
                    Image("weight_add")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                }
            }.frame(width: 155, height: 30)
                .fixedSize(horizontal: true, vertical: false)
                //.border(Color.green)
            Divider().border(.green)
            Spacer()
            Text("百事可乐~")
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}

@main
struct Todo: Widget {
    let kind: String = "Todo"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodoEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Todo_Previews: PreviewProvider {
    static var previews: some View {
        TodoEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
