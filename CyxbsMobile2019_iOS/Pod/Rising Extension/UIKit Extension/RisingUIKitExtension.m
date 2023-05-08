//
//  RisingUIKitExtension.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/20.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

CGFloat StatusBarHeight(void) {
    CGFloat statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        statusBarHeight =
        UIApplication.sharedApplication
            .windows.firstObject
            .windowScene.statusBarManager
            .statusBarFrame.size.height;
    } else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return statusBarHeight;
}
