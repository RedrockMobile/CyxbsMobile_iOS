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

#import "ScheduleHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleServiceSolve
  
@interface ScheduleServiceSolve : ScheduleServiceDataSource

/// request schedule
@property (nonatomic, strong) ScheduleRequestDictionary *parameterIfNeeded;

/// header view
@property (nonatomic, strong, null_resettable) ScheduleHeaderView *headerView;

/// view controller
@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, readonly) UICollectionView *collectionView;

/// XXHB, default is NO
@property (nonatomic) BOOL canUseAwake __deprecated_msg("⚠️XXHB");

- (void)requestAndReloadData;

- (void)scrollToSection:(NSUInteger)page;

- (void)reloadHeaderView;

@end

NS_ASSUME_NONNULL_END
