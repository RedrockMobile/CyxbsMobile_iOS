//
//  SchedulePresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SchedulePresenter.h"

#pragma mark - SchedulePresenter

@implementation SchedulePresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        _delegateService = [[ScheduleServiceDelegate alloc] init];
        _dataSourceService = [[ScheduleServiceDataSource alloc] initWithModel:_delegateService.model];
    }
    return self;
}

- (void)setModel:(ScheduleModel *)model {
    _model = model;
    _delegateService.model = model;
    _dataSourceService = [[ScheduleServiceDataSource alloc] initWithModel:model];
}

- (void)setController:(ScheduleController *)controller {
    _controller = controller;
    _delegateService.viewController = controller;
}

- (void)setCollectionView:(UICollectionView *)collectionView {
    _collectionView = collectionView;
    [_dataSourceService setCollectionView:collectionView];
    _delegateService.collectionView = collectionView;
}

- (void)setNextRequestDic:(ScheduleRequestDictionary *)nextRequestDic {
    _delegateService.parameterIfNeeded = nextRequestDic;
}

- (void)setUseAwake:(BOOL)useAwake {
    _delegateService.canUseAwake = useAwake;
}

- (ScheduleRequestDictionary *)nextRequestDic {
    return _delegateService.parameterIfNeeded;
}

- (BOOL)useAwake {
    return _delegateService.canUseAwake;
}

@end
