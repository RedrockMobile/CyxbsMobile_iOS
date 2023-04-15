//
//  ScheduleLeadingView.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2022/12/31.
//  Copyright © 2022 Redrock. All rights reserved.
//

import SwiftUI
import WidgetKit

struct ScheduleLeadingView: View {
    var range: Range<Int>
    var persent: CGFloat?
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        ZStack {
            GeometryReader { entry in
                VStack(spacing: 0) {
                    ForEach(range, id:\.self) { index in
                        TypeText("\(index)")
                            .frame(height: (entry.size.height) / CGFloat(range.upperBound - range.lowerBound))
                    }
                }.padding(.leading, entry.size.width * 0.35)
                
            }
            GeometryReader { entry in
                Image("schedule.zhizhen")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, top(for: entry.size.height))
            }
        }
    }
}

extension ScheduleLeadingView {
    func TypeText(_ str: String) -> some View{
        var color: Color {
            switch scheme {
            case .light:
                return Color(red: 0.082, green: 0.192, blue: 0.357, opacity: 1)
            case .dark:
                return Color(red: 0.941, green: 0.941, blue: 0.949, opacity: 1)
            @unknown default:
                return .clear
            }
        }
        
        return Text(str)
            .font(.system(size: 12))
            .foregroundColor(color)
    }
    
    func top(for height: CGFloat) -> CGFloat {
        guard let persent = persent, persent >= CGFloat(range.lowerBound) else { return 0 }
        return (persent - CGFloat(range.lowerBound)) * (height / CGFloat(range.upperBound - range.lowerBound))
    }
}



struct ScheduleLeadingView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleLeadingView(range: 1..<9)
            .frame(width: 29)
            .padding()
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
