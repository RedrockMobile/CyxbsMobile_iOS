//
//  ScheduleServiceDataSource.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**ScheduleServiceDataSource数据源服务驱动
 * 主要布局所有的与collecionView相关的视图
 * 这里只做DataSource相关业务
 * - 创建的时候必须传入ScheduleModel，并不能为空（地址传递）
 * - 不用担心视图会在此类里面被主动刷新
 */

#import <UIKit/UIKit.h>

#import "ScheduleModel.h"
#import "ScheduleCollectionViewLayout.h"
#import "ScheduleCollectionViewDataSource.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleServiceDataSource

@interface ScheduleServiceDataSource : NSObject <
    ScheduleCollectionViewDataSource,
    ScheduleCollectionViewLayoutDataSource,
    UIScrollViewDelegate
>

/// 模型
@property (nonatomic, strong) ScheduleModel *model;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/// 创建数据服务
/// @param model 数据
- (instancetype)initWithModel:(ScheduleModel * _Nonnull)model;

/// 设置collectionView
/// @param collectionView datasource本质代理
- (void)setingCollectionView:(UICollectionView *__strong  _Nonnull *_Nonnull)collectionView withPrepareWidth:(CGFloat)width NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
