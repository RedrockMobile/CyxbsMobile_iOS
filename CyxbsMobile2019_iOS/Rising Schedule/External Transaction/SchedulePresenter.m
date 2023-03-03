//
//  SchedulePresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SchedulePresenter.h"

#import "ScheduleController.h"

#import "ScheduleWidgetCache.h"

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

- (void)setNextRequestDic:(ScheduleRequestDictionary *)nextRequestDic {
    _service.parameterIfNeeded = nextRequestDic;
}

- (ScheduleRequestDictionary *)nextRequestDic {
    return _service.parameterIfNeeded;
}


- (void)requestAndReloadData {
    [self.service requestAndReloadData:^{
        [self.service scrollToSection:self.service.model.touchItem.nowWeek];
    }];
}



- (void)setAwakeable:(BOOL)awakeable {
    self.service.awakeable = awakeable;
    ScheduleShareCache.shareCache.awakeable = awakeable;
}

- (BOOL)awakeable {
    return self.service.awakeable;
}

@end


@implementation SchedulePresenter (ScheduleDouble)

- (void)setWithMainKey:(ScheduleIdentifier *)main {
    if (main == nil) {
        return;
    }
    
    [ScheduleWidgetCache.shareCache setKey:main withKeyName:ScheduleWidgetCacheKeyMain usingSupport:YES];
    ScheduleWidgetCache.shareCache.beDouble = NO;
    
    _service.model.sno = main.sno;
    _service.parameterIfNeeded = @{
        ScheduleModelRequestStudent : @[main.sno],
        ScheduleModelRequestCustom : @[main.sno]
    };
    _service.onShow = ScheduleModelShowSingle;
    
    [self _widgetReload];
}

- (void)setWithMainKey:(ScheduleIdentifier *)main otherKey:(ScheduleIdentifier *)other {
    if (main == nil) {
        return;
    } else {
        if (other == nil) {
            return;
        } else {
            [self setWithMainKey:main];
        }
    }
    
    [ScheduleWidgetCache.shareCache setKey:other withKeyName:ScheduleWidgetCacheKeyOther usingSupport:YES];
    ScheduleWidgetCache.shareCache.beDouble = YES;
    
    _service.parameterIfNeeded = @{
        ScheduleModelRequestStudent : @[main.sno, other.sno],
        ScheduleModelRequestCustom : @[main.sno]
    };
    _service.onShow = ScheduleModelShowDouble;
    
    [self _widgetReload];
}

- (void)setWidgetSection:(NSInteger)section {
    ScheduleWidgetCache.shareCache.widgetSection = section;
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
