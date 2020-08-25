//
//  WeekAndDay.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/8/23.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeekAndDay : NSObject
@property (nonatomic,copy) NSString *weekNumber;
@property(nonatomic,copy)NSString *weekday;

+(instancetype) defaultWeekDay;
@end

NS_ASSUME_NONNULL_END
