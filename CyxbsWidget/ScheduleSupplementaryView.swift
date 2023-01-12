//
//  ScheduleSupplementaryView.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2022/12/31.
//  Copyright © 2022 Redrock. All rights reserved.
//

import SwiftUI
import WidgetKit

struct ScheduleSupplementaryView: View {
    var title: String // Text
    var content: String? // Text
    var target: Bool // on target

    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(color(.background))
            VStack {
                if let content = content {
                    TypeText(title)
                        .padding(.top, 8)
                    Spacer()
                    TypeText(content, place: .content)
                        .padding(.bottom, 8)
                } else {
                    TypeText(title)
                }
            }
        }
    }
}

extension ScheduleSupplementaryView {
    internal enum Place {
        case title
        case content
        case background
    }
    
    func TypeText(_ str: String, place: Place = .title) -> some View{
        Text(str)
            .font(.system(size: 10))
            .padding(.leading, 7)
            .padding(.trailing, 7)
            .lineLimit(3)
            .foregroundColor(color(place))
    }
    
    func color(_ place: Place) -> Color {
        switch place {
        case .title:
            switch scheme {
            case .light:
                if target {
                    // title light target
                    return Color(red: 1, green: 1, blue: 1, opacity: 1)
                } else {
                    // title light untarget
                    return Color(red: 0.082, green: 0.192, blue: 0.357, opacity: 1)
                }
            case .dark:
                // title dark
                return Color(red: 0.941, green: 0.941, blue: 0.949, opacity: 1)
            @unknown default:
                return .clear
            }
        case .content:
            switch scheme {
            case .light:
                if target {
                    // content light target
                    return Color(red: 1, green: 1, blue: 1, opacity: 0.39)
                } else {
                    // content light untarget
                    return Color(red: 0.376, green: 0.431, blue: 0.541, opacity: 0.39)
                }
            case .dark:
                // content dark
                return Color(red: 0.525, green: 0.525, blue: 0.525, opacity: 1)
            @unknown default:
                return .clear
            }
        case .background:
            if target {
                switch scheme {
                case .light:
                    // background target light
                    return Color(red: 0.165, green: 0.306, blue: 0.518, opacity: 1)
                case .dark:
                    // background target dark
                    return Color(red: 0.353, green: 0.353, blue: 0.353, opacity: 0.8)
                @unknown default:
                    return .clear
                }
            } else {
                // background untarget
                return .clear
            }
        }
    }
}




struct ScheduleSupplementaryView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                ScheduleSupplementaryView(title: "周一", content: "1日", target: false)
                    .frame(width: 46, height: 50)
                ScheduleSupplementaryView(title: "周二", content: "2日", target: true)
                    .frame(width: 46, height: 50)
            }
            HStack {
                ScheduleSupplementaryView(title: "周三", target: true)
                    .frame(width: 46, height: 50)
                ScheduleSupplementaryView(title: "周四", target: false)
                    .frame(width: 46, height: 50)
            }
        }
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
