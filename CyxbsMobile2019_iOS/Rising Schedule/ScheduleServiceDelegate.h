//
//  ScheduleServiceDelegate.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**ScheduleServiceDelegate代理类服务驱动
 * 对请求，缓存，更改数据源与相关once view操作
 * 创建时不用传递任何东西，model会自动创建一个（里面的东西会是空的）
 * - 对数据源请求请配置parameterIfNeeded，然后调用requestAndReloadData就可以了
 * - 设置collectionView，不会主动改变视图，但会在特定时候使用一些值
 * - 设置headerView，headerView的布局应在controller或其他地方进行布局，这里只做对其值的改变
 * - 设置viewController，在需要present的时候，我们会使用到
 */

#import <Foundation/Foundation.h>

#import "ScheduleRequestType.h"

#import "ScheduleModel.h"

#import "ScheduleHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleServiceDelegate
  
@interface ScheduleServiceDelegate : NSObject

/// setting datasourse
@property (nonatomic, strong, nonnull) ScheduleModel *model;

/// request schedule
@property (nonatomic, strong) ScheduleRequestDictionary *parameterIfNeeded;

/// comflict collectionView
@property (nonatomic, strong, null_resettable) UICollectionView *collectionView;

/// header view
@property (nonatomic, strong, null_resettable) ScheduleHeaderView *headerView;

/// view controller
@property (nonatomic, weak) UIViewController *viewController;

/// XXHB, default is NO
@property (nonatomic) BOOL canUseAwake __deprecated_msg("⚠️XXHB");

+ (instancetype)new NS_UNAVAILABLE;

- (void)requestAndReloadData;

- (void)scrollToSection:(NSUInteger)page;

- (void)reloadHeaderView;

@end

NS_ASSUME_NONNULL_END
