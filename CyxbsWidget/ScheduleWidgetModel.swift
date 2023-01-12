//
//  ScheduleWidgetModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/7.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class ScheduleWidgetModel: ScheduleMapModel {
    var showSection: Int {
        set { section = (newValue < 0 ? 0 : newValue) }
        get { section }
    }
    private var section: Int
    
    var showRange: Range<Int> {
        set { range = (newValue.contains(0) ? 1..<7 : newValue) }
        get { range }
    }
    private var range: Range<Int>
    
    var sectionStartDate: Date? {
        if let ear = earStart {
            return section <= 0 ? nil : ear.addingTimeInterval(TimeInterval(section * 24 * 7 * 7 * 60))
        } else { return nil }
    }
    private var earStart: Date?
    
    init(showSection: Int, showRange: Range<Int>) {
        section = (showSection < 0 ? 0 : showSection)
        range = (showRange.contains(0) ? 1..<7 : showRange)
        super.init()
    }
    
    override func combineItem(_ model: ScheduleCombineItem) {
        super.combineItem(model)
        
    }
}
