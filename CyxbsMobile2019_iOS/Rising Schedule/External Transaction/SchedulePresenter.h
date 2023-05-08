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

@class ScheduleHeaderView;

#pragma mark - SchedulePresenter

@interface SchedulePresenter : NSObject

// PUBLIC USE

@property (nonatomic, readonly) UICollectionView *collectionView;

// PRIVITE USE

@property (nonatomic, readwrite) ScheduleHeaderView *headerView;

@property (nonatomic, weak) UIViewController *controller;

- (void)setingCollectionView:(UICollectionView *__strong  _Nonnull *_Nonnull)collectionView withPrepareWidth:(CGFloat)width;

// Method

- (void)requestAndReloadDataWithRollback:(BOOL)rollBack;

- (instancetype)initWithDouble NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithGroup NS_DESIGNATED_INITIALIZER;

@end



/* 单/双人课表扩展
 * 使用下面的方法使主程序以及小组件进行改变
 */
@interface SchedulePresenter (ScheduleDouble)

- (void)setAtFirstUseMem:(BOOL)mem beDouble:(BOOL)beD supportEditCustom:(BOOL)editC;
// @{ @"useMem" : @(YES), @"beDouble" : @(YES), @"editCustom" : @(YES) }
- (void)setAtFirst:(NSDictionary *)dic;

- (void)setWithMainKey:(ScheduleIdentifier *)main;
- (void)setWithMainKey:(ScheduleIdentifier *)main otherKey:(ScheduleIdentifier *)other;

@end



/* 多人课表
 * 使用下面的方法使主程序改变
 */
@interface SchedulePresenter (ScheduleGroup)

- (void)setWithGroup:(ScheduleRequestDictionary *)group;

- (void)setWithGroupKeys:(NSArray<ScheduleIdentifier *> *)gKeys;

@end

NS_ASSUME_NONNULL_END
