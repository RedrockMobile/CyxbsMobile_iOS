//
//  ScheduleCollectionViewModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/23.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**
 *
 * 外部的indexPath确定 *周* 和 *所在点*
 * timeline确定 *星期* 和 *长度*
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ScheduleBelongKind) {
    ScheduleBelongFistSystem,
    ScheduleBelongFistCustom,
    ScheduleBelongSecondSystem,
    ScheduleBelongUnknow = ScheduleBelongFistSystem
};

#pragma mark - ScheduleCollectionViewModel

@interface ScheduleCollectionViewModel : NSObject <NSCopying>

/// 标题
@property (nonatomic, copy) NSString *title;

/// 描述
@property (nonatomic, copy) NSString *content;

/// 是否有多个重复视图
@property (nonatomic) BOOL hadMuti;

/// 长度
@property (nonatomic) NSInteger lenth;

/// 类型
@property (nonatomic) ScheduleBelongKind kind;

@end

NS_ASSUME_NONNULL_END





#if __has_include("ScheduleCourse.h")
#import "ScheduleCourse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleCollectionViewModel (ScheduleCourse)

- (instancetype)initWithScheduleCourse:(ScheduleCourse *)course;

@end

NS_ASSUME_NONNULL_END

#endif
