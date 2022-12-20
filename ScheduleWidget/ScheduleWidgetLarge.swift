//
//  ScheduleWidgetLarge.swift
//  ScheduleWidgetExtension
//
//  Created by SSR on 2022/11/5.
//  Copyright © 2022 Redrock. All rights reserved.
//

import SwiftUI

struct WeekTitleView: View {
    
    var title: String
    var content: String
    var isTarget: Bool
    
    var body: some View {
        ZStack {
            Place.background(isTarget).color
            VStack {
                Text(title)
                    .font(.custom(FontName.PingFangSC.Regular, size: 12))
                    .padding(.top, 6)
                    .foregroundColor(Place.title(isTarget).color)
                Spacer()
                Text(content)
                    .font(.custom(FontName.PingFangSC.Regular, size: 11))
                    .padding(.bottom, 3)
                    .foregroundColor(Place.content.color)
            }
        }
        .cornerRadius(8)
    }
    
    enum Place {
        case background(Bool)
        case title(Bool)
        case content
        
        var color: Color {
            switch self {
            case let .background(isTarget):
                if isTarget {
                    return Color(light: UIColor(hexString: "#2A4E84")!,
                                 dark: UIColor(hexString: "#5A5A5ACC")!)
                } else {
                    return .clear
                }
                
            case let .title(isTarget):
                if isTarget {
                    return Color(light: UIColor(hexString: "#FFFFFF")!,
                                 dark: UIColor(hexString: "#F0F0F2")!)
                } else {
                    return Color(light: UIColor(hexString: "#15315B")!,
                                 dark: UIColor(hexString: "#F0F0F2")!)
                }
            case .content:
                return Color(light: UIColor(hexString: "#606E8A")!,
                             dark: UIColor(hexString: "#868686")!)
            }
        }
    }
}

struct ScheduleWidgetLarge: View {
    var entry: Provider.Entry
//    var model = ScheduleSectionModel()
    
    var body: some View {
        Spacer()
    }
}
