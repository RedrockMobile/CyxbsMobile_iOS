//
//  UIScrollView+CanScroll.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/9.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/****进入置顶通知****/
#define kHomeGoTopNotification               @"Home_Go_Top"
/****离开置顶通知****/
#define kHomeLeaveTopNotification            @"Home_Leave_Top"

@interface UIViewController ()

- (void)addNotification;
- (void)acceptMsg:(NSNotification *)notification;

@end

NS_ASSUME_NONNULL_END
