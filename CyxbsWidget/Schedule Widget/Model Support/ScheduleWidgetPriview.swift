//
//  ScheduleWidgetPriview.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2023/1/11.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

extension ScheduleCombineItem {
    
    static var priviewMainSno = "2021215154"
    
    static var priview2021215154: ScheduleCombineItem {
        priviewItem(source: "student2021215154")
    }
    
    static var priview2022214857: ScheduleCombineItem {
        priviewItem(source: "student2022214857")
    }
    
    private class func priviewItem(source: String) -> ScheduleCombineItem {
        
        //        [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:ScheduleCombineItem.class, ScheduleIdentifier.class, ScheduleCourse.class, NSArray.class, NSString.class, nil] fromData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"/Users/ssr/Downloads/%@.plist", identifier.key]] error:nil];
        
        let item = try! NSKeyedUnarchiver.unarchivedObject(ofClasses: [ScheduleCombineItem.self, ScheduleIdentifier.self, ScheduleCourse.self, NSString.self, NSArray.self], from: try! Data(contentsOf: Bundle.main.url(forResource: source, withExtension: "plist")!))
        return item as! ScheduleCombineItem
    }
}
