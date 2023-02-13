//
//  ScheduleContentView.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2022/12/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

import SwiftUI
import WidgetKit

struct ScheduleContentView: View {
    var title: String // Text
    var content: String // Text
    var draw: DrawType // in Draw
    var muti: Bool // Capsule
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .foregroundColor(draw.color(.background, scheme))
            VStack {
                TypeText(title)
                    .padding(.top, 8)
                Spacer()
                TypeText(content)
                    .padding(.bottom, 8)
            }
            if muti {
                GeometryReader { entry in
                    HStack {
                        Spacer()
                        Capsule(style: .continuous)
                            .foregroundColor(draw.color(.text, scheme))
                            .frame(width: 8, height: 2)
                            .padding(.top, 4)
                            .padding(.trailing, 5)
                    }
                }
            }
        }
    }
    
    enum DrawType {
    case morning
    case afternoon
    case night
    case other
    case custem
    case empty
    }
}

extension ScheduleContentView {
    func TypeText(_ str: String) -> some View {
        Text(str)
            .font(.system(size: 10))
            .padding(.horizontal, 7)
            .lineLimit(3)
            .foregroundColor(draw.color(.text, scheme))
    }
}


extension ScheduleContentView.DrawType {
    internal enum Place {
        case text
        case background
    }
    func color(_ place: Place, _ scheme: ColorScheme) -> Color {
        switch self {
        case .morning:
            switch place {
            case .text:
                switch scheme {
                case .light:
                    // morning text light
                    return Color(red: 1, green: 0.502, blue: 0.082, opacity: 1)
                case .dark:
                    // morning text dark
                    return Color(red: 0.941, green: 0.941, blue: 0.949, opacity: 0.8)
                @unknown default:
                    return .clear
                }
            case .background:
                switch scheme {
                case .light:
                    // morning background light
                    return Color(red: 0.976, green: 0.906, blue: 0.847, opacity: 1)
                case .dark:
                    // morning background dark
                    return Color(red: 1, green: 0.8, blue: 0.631, opacity: 0.15)
                @unknown default:
                    return .clear
                }
            }
        case .afternoon:
            switch place {
            case .text:
                switch scheme {
                case .light:
                    // afternoon text light
                    return Color(red: 1, green: 0.384, blue: 0.384, opacity: 1)
                case .dark:
                    // afternoon text dark
                    return Color(red: 0.941, green: 0.941, blue: 0.949, opacity: 0.8)
                @unknown default:
                    return .clear
                }
            case .background:
                switch scheme {
                case .light:
                    // afternoon background light
                    return Color(red: 0.976, green: 0.89, blue: 0.894, opacity: 1)
                case .dark:
                    // afternoon background dark
                    return Color(red: 1, green: 0.592, blue: 0.608, opacity: 0.15)
                @unknown default:
                    return .clear
                }
            }
        case .night:
            switch place {
            case .text:
                switch scheme {
                case .light:
                    // night text light
                    return Color(red: 0.251, green: 0.4, blue: 0.918, opacity: 1)
                case .dark:
                    // night text dark
                    return Color(red: 0.941, green: 0.941, blue: 0.949, opacity: 0.8)
                @unknown default:
                    return .clear
                }
            case .background:
                switch scheme {
                case .light:
                    // night background light
                    return Color(red: 0.867, green: 0.89, blue: 0.973, opacity: 1)
                case .dark:
                    // night background dark
                    return Color(red: 0.608, green: 0.698, blue: 0.984, opacity: 0.15)
                @unknown default:
                    return .clear
                }
            }
        case .other:
            switch place {
            case .text:
                switch scheme {
                case .light:
                    // other text light
                    return Color(red: 0.024, green: 0.639, blue: 0.988, opacity: 1)
                case .dark:
                    // other text dark
                    return Color(red: 0.941, green: 0.941, blue: 0.949, opacity: 0.8)
                @unknown default:
                    return .clear
                }
            case .background:
                switch scheme {
                case .light:
                    // other background light
                    return Color(red: 0.876, green: 0.954, blue: 0.988, opacity: 1)
                case .dark:
                    // other background dark
                    return Color(red: 0.563, green: 0.857, blue: 0.983, opacity: 0.15)
                @unknown default:
                    return .clear
                }
            }
        case .custem:
            switch place {
            case .text:
                return .black
            case .background:
                return .gray
            }
        case .empty:
            return .clear
        }
    }
}





struct ScheduleContentView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ScheduleContentView(title: "高等数学", content: "2301", draw: .morning, muti: true)
                .frame(width: 46, height: 100)
            ScheduleContentView(title: "体育俱乐部俱乐部俱乐部", content: "灯光篮球场3号羽毛球场", draw: .afternoon, muti: false)
                .frame(width: 46, height: 100)
            ScheduleContentView(title: "空格", content: "空格", draw: .empty, muti: true)
                .frame(width: 46, height: 100)
            ScheduleContentView(title: "晚上了", content: "2107", draw: .night, muti: true)
                .frame(width: 46, height: 100)
            ScheduleContentView(title: "嘿呀", content: "2107", draw: .other, muti: false)
                .frame(width: 46, height: 100)
        }
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
