//
//  CyxbsWidgetBundle.swift
//  CyxbsWidget
//
//  Created by SSR on 2022/12/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct CyxbsWidgetBundle: WidgetBundle {
    
    @WidgetBundleBuilder
    var body: some Widget {
        
        ScheduleWidget()
        
        if #available(iOS 16.1, *) {
            CyxbsWidgetLiveActivity()
        }
    }
}
