//
//  WidgetKitHelper.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/1.
//  Copyright © 2023 Redrock. All rights reserved.
//

import WidgetKit

@available(iOS 14.0, *)
@objcMembers final class WidgetKitHelper: NSObject {
    class func reloadAllTimelines() {
        #if arch(arm64) || arch(i386) || arch(x86_64)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }
    
    class func reloadTimelines(ofKind kind: CysbxsWidgetKind) {
        #if arch(arm64) || arch(i386) || arch(x86_64)
        WidgetCenter.shared.reloadTimelines(ofKind: kind as String)
        #endif
    }
}


