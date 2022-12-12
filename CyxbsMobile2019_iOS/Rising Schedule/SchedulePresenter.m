//
//  SchedulePresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SchedulePresenter.h"

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
