//
//  ScheduleFetchData.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2023/1/1.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

class ScheduleFetchData: ScheduleMapModel {
    struct PartItem: Identifiable {
        var indexPath: NSIndexPath
        var viewModel: ScheduleCollectionViewModel
        var id: IndexPath { indexPath as IndexPath }
    }
    
    var data = [PartItem]() // 最终显示的模型
    var range: Range<Int> // From Timeline Entry
    var beginTime: TimeInterval? // 从ScheduleCombineItem中取
    var section: Int
    
    var start: Date? {
        if let begin = beginTime {
            return Date(timeIntervalSince1970: begin)
        } else {
            return nil
        }
    }
    
    init(range: Range<Int>, section: Int?) {
        self.range = range
        if let section = section {
            self.section = section
        } else {
            if let begin = beginTime {
                self.section = Int((Date().timeIntervalSince1970 - begin) / (7.0 * 60 * 60 * 60))
            } else {
                self.section = 0
            }
        }
    }
    
    // MARK: Method
    
    override func combineItem(_ model: ScheduleCombineItem) {
        super.combineItem(model)
        if model.identifier.exp >= 1 {
            beginTime = model.identifier.exp
        } else {
            beginTime = nil
        }
        
        for key in self.mapTable.keyEnumerator().allObjects as! [NSIndexPath] {
            if (key.section == section && range.contains(key.location)) {
                let part = PartItem(indexPath: key, viewModel: self.mapTable.object(forKey: key)!)
                data.append(part)
            }
        }
    }
    
    override func clear() {
        super.clear()
        data = [PartItem]()
    }
}
