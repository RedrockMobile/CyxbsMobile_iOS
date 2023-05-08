//
//  ScheduleServiceSolve.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**ScheduleServiceDelegate代理类服务驱动
 */

#import "ScheduleServiceDataSource.h"

@class ScheduleHeaderView;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleServiceSolve
  
@interface ScheduleServiceSolve : ScheduleServiceDataSource

// PUBLIC USE

@property (nonatomic, strong, null_resettable) ScheduleHeaderView *headerView;

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, readonly) UICollectionView *collectionView;

// PRIVITE USE

/// 默认ScheduleModelShowGroup，对headerView图标的改变
/// 重写用来返回正确的状态
@property (nonatomic) ScheduleModelShowType showingType;

/// 单击空白地方时，是否弹起自定义事务
@property (nonatomic) BOOL presentCustomEditWhenTouchEmpty;

// OVERWRITE

/// 重写该方法用来返回下一次调用`requestAndReloadData:`
/// 返回nil或count为0则不会改变当前视图
@property (nonatomic, readonly, nullable) NSArray <ScheduleIdentifier *> *requestKeys;

// Method

/// 请求数据并刷新页面（同时会调用reloadHeaderView）
/// - Parameter complition: 刷新完成
- (void)requestAndReloadData:(void (^ _Nullable)(void))complition NS_REQUIRES_SUPER;
- (void)reloadHeaderView NS_REQUIRES_SUPER;
//- (BOOL)useMemBeforeRequestWithKey:(ScheduleIdentifier *)key; // defualt return YES, and do nothing.

- (void)scrollToSection:(NSInteger)page NS_REQUIRES_SUPER;
- (void)scrollToSectionNumber:(NSNumber *)page NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
