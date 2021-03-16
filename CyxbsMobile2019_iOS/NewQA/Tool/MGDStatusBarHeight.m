//
//  MGDStatusBarHeight.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/3/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MGDStatusBarHeight.h"

@implementation MGDStatusBarHeight

+ (CGFloat)getStatusBarHight {
   float statusBarHeight = 0;
   if (@available(iOS 13.0, *)) {
       UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
       statusBarHeight = statusBarManager.statusBarFrame.size.height;
   }else {
       statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
   }
   return statusBarHeight;
}

@end
