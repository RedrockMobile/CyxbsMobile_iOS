//
//  ScheduleFetchData.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2023/1/1.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

class ScheduleFetchData: ScheduleMapModel {
    
    /* PartItem
     * 为了支持ForEach语法，以及MVVM架构
     * 提供 `点` 与 `模型` 共同在一起
     */
    struct PartItem: Identifiable {
        var indexPath: NSIndexPath
        var viewModel: ScheduleCollectionViewModel
        var id: IndexPath { indexPath as IndexPath }
    }
    
    /* data
     * ForEach该data，得到需要展示的所有模型
     */
    var data = [PartItem]()
    
    /* range
     * 得到需要展示的range范围，[1,12]之间
     */
    var range: Range<Int>
    
    /* section
     * 得到需要展示的周数，这里必须填写
     */
    var section: Int
    
    /* beginTime
     * 为了计算具体日期而使用，与start配对使用
     */
    private var beginTime: TimeInterval?
    
    /* start
     * 计算属性，根据beginTime而计算出真正的开始时间
     * nil则为不存在开始时间
     */
    var start: Date? {
        if let begin = beginTime {
            return Date(timeIntervalSince1970: begin)
        } else {
            return nil
        }
    }
    
    /* MARK: Init
     * 创建的时候，如果有section，则section为固定的值
     * 如果为nil，则跟随。会根据beginTime进行调整
     */
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
    
    // MARK: override
    
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
