//
//  ScheduleServiceDouble.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/4/28.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleServiceSolve.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleServiceDouble : ScheduleServiceSolve

@property (nonatomic) BOOL useMemCheck;
@property (nonatomic) BOOL beDouble;

/// 这三个方法都将只做一个操作：将iden纳入到keyToIden字典
/// 不对其他私有属性进行改变，并且后两者将返回是否成功纳入到keyToIden字典
- (void)setIdentifier:(ScheduleIdentifier *)identifier withWidgetKeyName:(ScheduleWidgetCacheKeyName)key;
- (BOOL)setMainAndCustom:(ScheduleIdentifier *)main;
- (BOOL)setMainAndCustom:(ScheduleIdentifier *)main andOther:(ScheduleIdentifier *)other;

@end

NS_ASSUME_NONNULL_END
