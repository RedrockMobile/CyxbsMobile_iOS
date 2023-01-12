//
//  ScheduleCollectionViewModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/23.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**MARK: ScheduleCollectionViewModel
 * \c ViewModel 遵循了`NSCopying`协议
 * 保存每个视图的数据源信息
 */

typedef NS_ENUM(NSUInteger, ScheduleBelongKind) {
    ScheduleBelongFistSystem,
    ScheduleBelongFistCustom,
    ScheduleBelongSecondSystem,
    ScheduleBelongUnknow = ScheduleBelongFistSystem
};

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
