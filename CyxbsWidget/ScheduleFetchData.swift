//
//  ScheduleFetchData.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2023/1/1.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

struct ScheduleFetchData {
    var data: [[ScheduleSimpleEntry]]
//    init() {
//        data = Array(repeating: Array(), count: 7)
//        let identifier = ScheduleIdentifier(sno: "2021215154", type: .student)
//        let item = ScheduleShareCache().awake(for: identifier)
//        let map = ScheduleMapModel()
//        map.combineItem(item!);
//        for i in 1...7 {
//            let idx = IndexPath.ReferenceType(forLocation: 0, inWeek: i, inSection: 1)
//            let pointAry = map.dayMap.object(forKey: idx)!
//
//            let before = pointAry.pointer(at: 1)?.load(as: ScheduleCollectionViewModel?.self)
//            for j in 2..<pointAry.count {
//                let after = pointAry.pointer(at: j)?.load(as: ScheduleCollectionViewModel?.self)
//
//            }
//        }
//    }

    
//    init() {
//        func vm(_ title: String, _ content: String, _ muti: Bool, len: Int, kind: ScheduleBelongKind = .fistCustom) -> ScheduleCollectionViewModel {
//            let vm = ScheduleCollectionViewModel()
//            vm.title = title
//            vm.content = content
//            vm.hadMuti = muti
//            vm.lenth = len
//            vm.kind = kind
//            return vm
//        }
//        func empty(len: Int) -> ScheduleCollectionViewModel {
//            let vm = ScheduleCollectionViewModel()
//            vm.kind = .widgetEmpty
//            return vm
//        }
//        self.data = [
//            [
//                empty(len: 2),
//                vm("羽毛球初级", "太极运动场04", false, len: 2),
//                empty(len: 4)
//            ],
//            [
//                vm("综合英语", "4210", false, len: 2),
//                vm("离散数学B", "3212", false, len: 2),
//                empty(len: 2),
//                vm("大学物理C（下）", "2117", false, len: 2)
//            ],
//            [ empty(len: 8) ],
//            [
//                empty(len: 2),
//                vm("大学物理C（下）", "2117", false, len: 2),
//                empty(len: 2),
//                vm("工程管理与经济决策", "2215", false, len: 2),
//            ],
//            [
//                vm("编程基础III", "计算机教室（七）（综合阿巴）", false, len: 2),
//                vm("工程伦理", "3201", false, len: 2),
//                empty(len: 2)
//            ],
//            [ empty(len: 8) ],
//            [ empty(len: 8) ]
//        ]
//    }
    
    init() {
        self.data = [
            [
                ScheduleSimpleEntry(lenth: 2),
                ScheduleSimpleEntry(title: "羽毛球初级", content: "太极运动场04", locate: 3, lenth: 2),
                ScheduleSimpleEntry(title: "数据结构", content: "3206", locate: 5, lenth: 2),
                ScheduleSimpleEntry(lenth: 2)
            ],
            [
                ScheduleSimpleEntry(title: "综合英语", content: "4210", locate: 1, lenth: 2),
                ScheduleSimpleEntry(title: "离散数学B", content: "3212", locate: 3, lenth: 2),
                ScheduleSimpleEntry(lenth: 2),
                ScheduleSimpleEntry(title: "大学物理C（下）", content: "2117", locate: 5, lenth: 2)
            ],
            [
                ScheduleSimpleEntry(lenth: 4),
                ScheduleSimpleEntry(title: "线性代数", content: "3104", locate: 5, lenth: 2),
                ScheduleSimpleEntry(lenth: 2),
            ],
            [
                ScheduleSimpleEntry(lenth: 2),
                ScheduleSimpleEntry(title: "大学物理C（下）", content: "2117", locate: 3, lenth: 2),
                ScheduleSimpleEntry(lenth: 2),
                ScheduleSimpleEntry(title: "工程管理与经济决策", content: "2215", locate: 5, lenth: 2),
            ],
            [
                ScheduleSimpleEntry(title: "编程基础III", content: "计算机教室（七）（阿巴）", locate: 1, lenth: 2),
                ScheduleSimpleEntry(title: "工程伦理", content: "3201", locate: 3, lenth: 2),
                ScheduleSimpleEntry(title: "线性代数", content: "3104", locate: 5, lenth: 2),
                ScheduleSimpleEntry(lenth: 2)
            ],
            [
                ScheduleSimpleEntry(lenth: 8)
            ],
            [
                ScheduleSimpleEntry(lenth: 8)
            ]
        ]
    }
}
