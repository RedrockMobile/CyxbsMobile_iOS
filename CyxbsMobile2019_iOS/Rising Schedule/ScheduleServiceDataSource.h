//
//  ScheduleServiceDataSource.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**ScheduleServiceDataSource数据源服务
 * 主要布局所有的视图与交互
 * 主业务线会掉用其他业务
 * 应将控制器controller赋值
 */

#import <UIKit/UIKit.h>

#import "ScheduleModel.h"

#import "ScheduleCollectionViewLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleServiceDataSource : NSObject <
    UICollectionViewDataSource,
    ScheduleCollectionViewLayoutDataSource
>

/// <#description#>
@property (nonatomic, readonly) ScheduleModel *model;

+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)dataSourceServiceWithModel:(ScheduleModel * _Nonnull)model;

- (void)setCollectionView:(UICollectionView *)view diff:(BOOL)diff;

@end

NS_ASSUME_NONNULL_END
