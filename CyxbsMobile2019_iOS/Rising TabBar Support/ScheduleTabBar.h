//
//  ScheduleTabBar.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/4/23.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ScheduleBottomBar;

@interface ScheduleTabBar : UITabBar

@property (nonatomic) CGFloat heightForScheduleBar;

@property (nonatomic, getter=isScheduleBarHidden) BOOL scheduleBarHidden;

@property (nonatomic, readonly) ScheduleBottomBar *bottomBar;

/// use mainKey with [ScheduleShareCache memoryKeyForKey:nil forKeyName:ScheduleWidgetCacheKeyMain];
- (void)reload;

@end

NS_ASSUME_NONNULL_END
