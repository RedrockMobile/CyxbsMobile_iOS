//
//  ScheduleSectionModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/9.
//  Copyright © 2022 Redrock. All rights reserved.
//

import UIKit

class ScheduleSectionModel: ScheduleMapModel {

    var viewModels: Array <ScheduleDayModel>
    
    override init() {
        viewModels = Array(repeating: ScheduleDayModel(), count: 7)
        super.init()
    }
    
    func request( success: @escaping ()->Void) {
        ScheduleInteractorRequest.request([.student : ["2021215154"]]) { combine in
            self.combineModel(combine)
            
            var currentIdxs = Array<IndexPath>()
            for indexPath in self.mapTable.keyEnumerator().allObjects as! [IndexPath] {
                if (indexPath.section == combine.nowWeek) {
                    currentIdxs.append(indexPath)
                }
            }
            currentIdxs.sort { $0.compare($1) == .orderedAscending }
            
            for idx in currentIdxs {
                self.viewModels[idx.section].id = "\(idx)"
                self.viewModels[idx.section].viewModels.append(idx)
            }
            
            success()
        } failure: { _ in }
    }
    
    class ScheduleDayModel: Identifiable {
        var id: String = ""
        var date: Date?
        var viewModels: Array<IndexPath> = []
    }
}
