//
//  ScheduleFetchData.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2023/1/1.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

struct ScheduleFetchData {
    struct PartItem: Identifiable {
        var indexPath: NSIndexPath
        var viewModel: ScheduleCollectionViewModel
        var id: IndexPath { indexPath as IndexPath }
    }
    var data: [PartItem]
    var beginTime: TimeInterval
    var section: Int // start + $section = date!.show
    var range: Range<Int> // Timeline Entry
    var start: Date? { // get only
        if section <= 0 {
            return Date(timeIntervalSince1970: beginTime + Double(section - 1) * 7.0 * 24 * 60 * 60)
        }
        return Date(timeIntervalSince1970: beginTime + Double(section - 1) * 7.0 * 24 * 60 * 60)
    }
    
    init(range: Range<Int>) {
        self.range = range
        
        data = Array()
        section = ScheduleWidgetCache().widgetSection
        let mainID = ScheduleWidgetCache().getKeyWithKeyName(ScheduleWidgetCacheKeyMain, usingSupport: true)
        let mainItem = ScheduleShareCache().awake(for: mainID)
        beginTime = (mainItem?.identifier.exp)!
        
        let map = ScheduleMapModel()
        map.combineItem(mainItem!)
        
        if ScheduleWidgetCache().beDouble {
            map.sno = mainID.sno
            let otherID = ScheduleWidgetCache().getKeyWithKeyName(ScheduleWidgetCacheKeyOther, usingSupport: true)
            let otherItem = ScheduleShareCache().awake(for: otherID)
            map.combineItem(otherItem!)
        }
        map.finishCombine()
        
        for key in map.mapTable.keyEnumerator().allObjects as! [NSIndexPath] {
            if key.section == section && range.contains(key.location) {
                data.append(PartItem(indexPath: key, viewModel: map.mapTable.object(forKey: key)!))
            }
        }
    }
}
