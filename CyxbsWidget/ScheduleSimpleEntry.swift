//
//  ScheduleSimpleEntry.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2023/1/1.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

struct ScheduleSimpleEntry: Identifiable {
    enum Belong {
    case myself
    case custom
    case others
    case empty
    }
    
    var title: String
    var content: String
    var locate: Int
    var lenth: Int
    var muti: Bool = false
    var belong: Belong
    var id: Int {
        locate << 4 + lenth
    }
    
    init(title: String, content: String, locate: Int, lenth: Int, muti: Bool = false, belong: Belong = .myself) {
        self.title = title
        self.content = content
        self.locate = locate
        self.lenth = lenth
        self.muti = muti
        self.belong = belong
    }
    
    init(_ empty: Belong = .empty, lenth: Int) {
        title = ""
        content = ""
        locate = 0
        self.lenth = lenth
        belong = .empty
    }
}
