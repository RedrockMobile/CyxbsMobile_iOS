//
//  FontName.swift
//  ScheduleWidgetExtension
//
//  Created by SSR on 2022/11/5.
//  Copyright © 2022 Redrock. All rights reserved.
//

import Foundation

typealias FontName = String

extension FontName {
    struct PingFangSC {
        static let Regular = "PingFangHK-Regular"
        static let Ultralight = "PingFangSC-Ultralight"
        static let Thin = "PingFangSC-Thin"
        static let Light = "PingFangSC-Light"
        static let Medium = "PingFangSC-Medium"
        static let Semibold = "PingFangSC-Semibold"
    }
}

extension UserDefaults {
    static var widget : UserDefaults? {
        UserDefaults(suiteName: "group.com.mredrock.cyxbs.widget")
    }
}

extension Locale {
    static var CN: Locale {
        Locale(identifier: "zh_CN")
    }
}

import SwiftUI

extension Color {
    init(light: UIColor, dark: UIColor) {
        @Environment(\.colorScheme) var currentMode
        self.init(currentMode == .dark ? dark : light)
    }
}
