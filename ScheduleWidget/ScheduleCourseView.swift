//
//  ScheduleCourseView.swift
//  ScheduleWidgetExtension
//
//  Created by SSR on 2022/11/5.
//  Copyright © 2022 Redrock. All rights reserved.
//

import SwiftUI

struct ScheduleCourseView: View {
    
    enum DrawType: Int {
        
        case morning
        case afternoon
        case night
        case others
        
        var backgroudColor: Color {
            switch self {
            case .morning:
                return Color(UIColor(hexString: "#F9E7D8")!)
            case .afternoon:
                return Color(UIColor(hexString: "#F9E3E4")!)
            case .night:
                return Color(UIColor(hexString: "#DDE3F8")!)
            case .others:
                return Color(UIColor(hexString: "#DFF3FC")!)
            }
        }
        
        var textColor: Color {
            switch self {
            case .morning:
                return Color(UIColor(hexString: "#FF8015")!)
            case .afternoon:
                return Color(UIColor(hexString: "#06A3FC")!)
            case .night:
                return Color(UIColor(hexString: "#4066EA")!)
            case .others:
                return Color(UIColor(hexString: "#06A3FC")!)
            }
        }
    }
    
    var inDraw: DrawType
    var title: String
    var content: String
    
    init(inDraw: DrawType, title: String, content: String) {
        self.inDraw = inDraw
        self.title = title
        self.content = content
    }
    
    var body: some View {
        ZStack {
            inDraw.backgroudColor
            VStack {
                Text(title)
                    .padding(.top, 8)
                Spacer()
                Text(content)
                    .padding(.bottom, 8)
            }
            .font(Font.custom(FontName.PingFangSC.Regular, size: 10))
            .foregroundColor(inDraw.textColor)
            .padding(.horizontal, 3)
            GeometryReader { entry in
                Spacer()
                inDraw.textColor
                    .frame(width: 8, height: 2)
                    .cornerRadius(1)
                Spacer(minLength: 5)
            }
        }
        .cornerRadius(10)
    }
}

struct ScheduleCourseView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VStack {
                ScheduleCourseView(inDraw: .morning, title: "上午的课", content: "2116")
                ScheduleCourseView(inDraw: .afternoon, title: "下午的课", content: "2116")
                ScheduleCourseView(inDraw: .night, title: "晚上的课", content: "2116")
            }
            VStack {
                ScheduleCourseView(inDraw: .others, title: "别人的课", content: "2116")
                ScheduleCourseView(inDraw: .morning, title: "有多节课", content: "2116")
            }
        }
    }
}
