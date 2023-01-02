//
//  SchedulePresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SchedulePresenter.h"

#import "ScheduleWidgetCache.h"

#import "掌上重邮-Swift.h"

#pragma mark - SchedulePresenter

@implementation SchedulePresenter {
    
}

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

- (void)setWithMainIdentifier:(ScheduleIdentifier *)main otherIdentifier:(ScheduleIdentifier *)other {
    _service.model.sno = main.sno;
    ScheduleWidgetCache.shareCache.nonatomicMainID = main;
    ScheduleWidgetCache.shareCache.nonatomicOtherID = other;
    ScheduleWidgetCache.shareCache.beDouble = YES;
    _service.parameterIfNeeded = @{
        ScheduleModelRequestStudent : @[main.sno, other.sno]
    };
}

- (void)setWithOnlyMainIdentifier:(ScheduleIdentifier *)main {
    _service.model.sno = nil;
    ScheduleWidgetCache.shareCache.nonatomicMainID = main;
    ScheduleWidgetCache.shareCache.beDouble = NO;
    _service.parameterIfNeeded = @{
        ScheduleModelRequestStudent : @[main.sno]
    };
}

- (void)setWidgetSection:(NSInteger)section {
    ScheduleWidgetCache.shareCache.widgetSection = section;
}

@end
