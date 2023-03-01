//
//  SchedulePresenter.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**SchedulePresenter驱动器
 * - 充当与路由的搭配业务，路由的类引入@"ScheduleRouterProtocol.h"
 * - 控制器驱动： controller
 * - 数据源驱动： dataSourceService
 * - 代理源驱动： delegateService
 */

#import <Foundation/Foundation.h>

#import "ScheduleCombineItemSupport.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - SchedulePresenter

@interface SchedulePresenter : NSObject

// *property useable

/// 控制器（不用赋值，会自动生成）
@property (nonatomic, weak) UIViewController *controller;

/// 绘制collecitonView
/// - Parameters:
///   - collectionView: 传一个local的collecitonView，调用结束后会生成一个collecitonView
///   - width: 准备工作所需要的宽度
- (void)setingCollectionView:(UICollectionView *__strong  _Nonnull *_Nonnull)collectionView withPrepareWidth:(CGFloat)width;

// *useable

@property (nonatomic, readonly) UICollectionView *collectionView;

- (void)requestAndReloadData;

@property (nonatomic) BOOL awakeable;

@end



/* 单/双人课表扩展
 * 使用下面的方法使主程序以及小组件进行改变
 */
@interface SchedulePresenter (ScheduleDouble)

- (void)setWithMainKey:(ScheduleIdentifier *)main;

- (void)setWithMainKey:(ScheduleIdentifier *)main otherKey:(ScheduleIdentifier *)other;

- (void)setWidgetSection:(NSInteger)section;

@end



/* 多人课表
 * 使用下面的方法使主程序改变
 */
@interface SchedulePresenter (ScheduleGroup)

- (void)setWithGroup:(ScheduleRequestDictionary *)group;

- (void)setWithGroupKeys:(NSArray<ScheduleIdentifier *> *)gKeys;

@end

NS_ASSUME_NONNULL_END




#if __has_include("ScheduleHeaderView.h")
#import "ScheduleHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SchedulePresenter (ScheduleHeaderView)

@property (nonatomic, readwrite) ScheduleHeaderView *headerView;

@end

NS_ASSUME_NONNULL_END

#endif


