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

#import "掌上重邮-Swift.h"

#pragma mark - SchedulePresenter

@implementation SchedulePresenter 

- (instancetype)init {
    self = [super init];
    if (self) {
        _service = [[ScheduleServiceSolve alloc] initWithModel:[[ScheduleModel alloc] init]];
    }
    return self;
}

- (void)setModel:(ScheduleModel *)model {
    _service.model = model;
}

- (ScheduleModel *)model {
    return _service.model;
}


- (void)setController:(ScheduleController *)controller {
    _service.viewController = controller;
}

- (ScheduleController *)controller {
    return (ScheduleController *)_service.viewController;
}


- (void)setCollectionView:(UICollectionView *)collectionView {
    _service.collectionView = collectionView;
}

- (UICollectionView *)collectionView {
    return _service.collectionView;
}


- (void)setNextRequestDic:(ScheduleRequestDictionary *)nextRequestDic {
    _service.parameterIfNeeded = nextRequestDic;
}

- (ScheduleRequestDictionary *)nextRequestDic {
    return _service.parameterIfNeeded;
}


- (void)setUseAwake:(BOOL)useAwake {
    _service.canUseAwake = useAwake;
}

- (BOOL)useAwake {
    return _service.canUseAwake;
}


@end


@implementation SchedulePresenter (ScheduleDouble)

- (void)setWithMainKey:(ScheduleIdentifier *)main {
    if (main == nil) {
        return;
    }
    _service.model.sno = main.sno;
    [ScheduleWidgetCache.shareCache setKey:main withKeyName:ScheduleWidgetCacheKeyMain usingSupport:YES];
    _service.parameterIfNeeded = @{
        ScheduleModelRequestStudent : @[main.sno]
    };
}

- (void)setWithMainKey:(ScheduleIdentifier *)main otherKey:(ScheduleIdentifier *)other {
    [self setWithMainKey:main];
    if (other == nil) {
        return;
    }
    [ScheduleWidgetCache.shareCache setKey:other withKeyName:ScheduleWidgetCacheKeyOther usingSupport:YES];
    _service.parameterIfNeeded = @{
        ScheduleModelRequestStudent : @[main.sno, other.sno]
    };
}

- (void)setWidgetSection:(NSInteger)section {
    ScheduleWidgetCache.shareCache.widgetSection = section;
    if (@available(iOS 14.0, *)) {
        [WidgetKitHelper reloadAllTimelines];
    }
}

@end
