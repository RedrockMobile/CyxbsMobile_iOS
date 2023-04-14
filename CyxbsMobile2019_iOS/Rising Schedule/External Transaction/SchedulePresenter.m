//
//  SchedulePresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SchedulePresenter.h"
#import "ScheduleController.h"

#import "ScheduleShareCache.h"
#import "ScheduleServiceSolve.h"
#import "掌上重邮-Swift.h"

#pragma mark - SchedulePresenter ()

@interface SchedulePresenter ()

@property (nonatomic, strong) ScheduleServiceSolve *service;

@end

#pragma mark - SchedulePresenter

@implementation SchedulePresenter 

- (instancetype)init {
    self = [super init];
    if (self) {
        _service = [[ScheduleServiceSolve alloc] initWithModel:[[ScheduleModel alloc] init]];
    }
    return self;
}



/* CollectionView */

- (void)setingCollectionView:(UICollectionView *__strong  _Nonnull *)collectionView withPrepareWidth:(CGFloat)width {
    [self.service setingCollectionView:collectionView withPrepareWidth:width];
}

- (UICollectionView *)collectionView {
    return self.service.collectionView;
}



/* Controller */

- (void)setController:(UIViewController *)controller {
    _service.viewController = controller;
}

- (ScheduleController *)controller {
    return (ScheduleController *)_service.viewController;
}



/* Next Request */

- (void)requestAndReloadDataWithRollback:(BOOL)rollBack {
    [self.service requestAndReloadData:^{
        if (rollBack) {
            [self.service scrollToSection:self.service.model.touchItem.nowWeek];
        }
    }];
}

@end


@implementation SchedulePresenter (ScheduleDouble)

- (void)setWithMainKey:(ScheduleIdentifier *)main {
    // main check
    if (main == nil) { return; }
    [ScheduleShareCache.shareCache diskCacheKey:main forKeyName:ScheduleWidgetCacheKeyMain];
    [ScheduleShareCache memoryCacheKey:main forKeyName:ScheduleWidgetCacheKeyMain];
    // custom check
    ScheduleIdentifier *custom = [ScheduleIdentifier identifierWithSno:main.sno type:ScheduleModelRequestCustom];
    [ScheduleShareCache.shareCache diskCacheKey:custom forKeyName:ScheduleWidgetCacheKeyCustom];
    [ScheduleShareCache memoryCacheKey:custom forKeyName:ScheduleWidgetCacheKeyCustom];
    // service check
    _service.model.sno = main.sno;
    _service.requestKeys = @[main, custom].mutableCopy;
    _service.firstKey = main;
    _service.onShow = ScheduleModelShowSingle;
    [self _widgetReload];
}

- (void)setWithMainKey:(ScheduleIdentifier *)main otherKey:(ScheduleIdentifier *)other {
    // check main & other
    if (main == nil) { return; } else {
        if (other == nil) { return; } else {
            [self setWithMainKey:main];
        }
    }
    [ScheduleShareCache.shareCache diskCacheKey:other forKeyName:ScheduleWidgetCacheKeyOther];
    [ScheduleShareCache memoryCacheKey:other forKeyName:ScheduleWidgetCacheKeyOther];
    // service check
    NSMutableArray *ary = (NSMutableArray *)_service.requestKeys;
    [ary addObject:other];
    _service.onShow = ScheduleModelShowDouble;
    [self _widgetReload];
}

- (void)_widgetReload {
    if (@available(iOS 14.0, *)) {
        [WidgetKitHelper reloadAllTimelines];
    }
}

@end

@implementation SchedulePresenter (ScheduleHeaderView)

- (void)setHeaderView:(ScheduleHeaderView *)headerView {
    self.service.headerView = headerView;
}

- (ScheduleHeaderView *)headerView {
    return self.service.headerView;
}

@end
