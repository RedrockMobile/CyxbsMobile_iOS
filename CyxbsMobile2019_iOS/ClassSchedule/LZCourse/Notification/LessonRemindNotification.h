//
//  LessonRemindNotification.h
//  MoblieCQUPT_iOS
//
//  Created by hzl on 2016/11/30.
//  Copyright © 2016年 Orange-W. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonRemindNotification : NSObject

- (void)addTomorrowNotificationWithMinute:(NSString *)minute AndHour:(NSString *)hour;

- (void)deleteNotification;

@end

