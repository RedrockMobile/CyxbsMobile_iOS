//
//  CyxbsWidgetKind.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/3.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
@objc enum WidgetKind: Int {
    case schedule
    var rawValue: String {
        switch self {
        case .schedule:
            return "ScheduleWidget"
        }
    }
}
