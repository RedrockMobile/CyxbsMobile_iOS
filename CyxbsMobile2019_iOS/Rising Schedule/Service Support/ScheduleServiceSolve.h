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

/// header view
@property (nonatomic, strong, null_resettable) ScheduleHeaderView *headerView;

/// view controller
@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, readonly) UICollectionView *collectionView;



/// request schedule
@property (nonatomic, strong, nonnull) NSArray <ScheduleIdentifier *> *requestKeys;
@property (nonatomic, strong, nullable) ScheduleIdentifier *firstKey;

@property (nonatomic) ScheduleModelShowType onShow;




/// XXHB, default is NO
@property (nonatomic) BOOL awakeable;



- (void)requestAndReloadData:(void (^ _Nullable)(void))complition;

- (void)scrollToSection:(NSInteger)page;
- (void)scrollToSectionNumber:(NSNumber *)page;

- (void)reloadHeaderView;

@end

NS_ASSUME_NONNULL_END
