//
//  NSDate+schoolDate.h
//  MoblieCQUPT_iOS
//
//  Created by xiaogou134 on 2017/12/8.
//  Copyright © 2017年 Orange-W. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
    一个NSDate的分类
    给一个周数和周几
    可以返回一个NSDate（MM-dd-EEEE）
    用于算考试的日期
 */
@interface NSDate(schoolDate)
- (NSDate *)getShoolData:(NSString *)week andWeekday:(NSString *)weekday;
@end
