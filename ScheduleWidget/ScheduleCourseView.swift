//
//  ScheduleCourseView.swift
//  ScheduleWidgetExtension
//
//  Created by SSR on 2022/11/5.
//  Copyright © 2022 Redrock. All rights reserved.
//

import SwiftUI

struct ScheduleCourseView: View {
    
    enum DrawType {
        case morning
        case afternoon
        case night
        case others
    }
    var inDraw: DrawType
    var title: String
    var content: String
    
    var body: some View {
        ZStack {
            DrawPlace.background(inDraw).color
            VStack {
                Text(title)
                    .padding(.top, 8)
                Spacer()
                Text(content)
                    .padding(.bottom, 8)
            }
            .font(Font.custom(FontName.PingFangSC.Regular, size: 10))
            .foregroundColor(DrawPlace.text(inDraw).color)
            .padding(.horizontal, 3)
            GeometryReader { entry in
                Spacer()
                DrawPlace.text(inDraw).color
                    .frame(width: 8, height: 2)
                    .cornerRadius(1)
                    .padding(.trailing, 5)
            }
        }
        .cornerRadius(10)
    }
    
    enum DrawPlace {
        case text(DrawType)
        case background(DrawType)
        
        var color: Color {
            switch self {
            case let .text(type):
                switch type {
                    case .morning:
                        return Color(light: UIColor(hexString: "#FF8015")!,
                                     dark: UIColor(hexString: "#F0F0F2CC")!)
                    case .afternoon:
                        return Color(light: UIColor(hexString: "#FF6262")!,
                                     dark: UIColor(hexString: "#F0F0F2CC")!)
                    case .night:
                        return Color(light: UIColor(hexString: "#4066EA")!,
                                     dark: UIColor(hexString: "#F0F0F2CC")!)
                    case .others:
                        return Color(light: UIColor(hexString: "#06A3FC")!,
                                     dark: UIColor(hexString: "#F0F0F2CC")!)
                }
            case let .background(type):
                switch type {
                case .morning:
                    return Color(light: UIColor(hexString: "#F9E7D8")!,
                                 dark: UIColor(hexString: "#FFCCA126")!)
                case .afternoon:
                    return Color(light: UIColor(hexString: "#F9E3E4")!,
                                 dark: UIColor(hexString: "#FF979B26")!)
                case .night:
                    return Color(light: UIColor(hexString: "#DDE3F8")!,
                                 dark: UIColor(hexString: "#9BB2FB26")!)
                case .others:
                    return Color(light: UIColor(hexString: "#DFF3FC")!,
                                 dark: UIColor(hexString: "#90DBFB26")!)
                }
            }
        }
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
