//
//  ScheduleInteractorDataSource.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**ScheduleInteractorMain主业务线
 * 主要布局所有的视图与交互
 * 主业务线会掉用其他业务
 * 应将控制器controller赋值
 */

#import <UIKit/UIKit.h>

#import "ScheduleModel.h"

#import "ScheduleCollectionViewLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleInteractorDataSource : NSObject <
    UICollectionViewDataSource,
    ScheduleCollectionViewLayoutDataSource
>

+ (instancetype)new NS_UNAVAILABLE;

/// <#description#>
@property (nonatomic, strong) ScheduleModel *model;

- (void)setCollectionView:(UICollectionView *)view diff:(BOOL)diff;

@end

NS_ASSUME_NONNULL_END
