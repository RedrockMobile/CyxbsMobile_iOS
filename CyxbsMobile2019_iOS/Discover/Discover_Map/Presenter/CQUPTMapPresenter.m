//
//  CQUPTMapPresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapPresenter.h"
#import "CQUPTMapModel.h"

@implementation CQUPTMapPresenter

- (void)attachView:(UIViewController<CQUPTMapViewProtocol> *)view {
    _view = view;
}

- (void)detachView {
    _view = nil;
}

- (void)requestMapData {
    [CQUPTMapModel requestMapDataSuccess:^(CQUPTMapDataItem * _Nonnull mapDataItem, CQUPTMapHotPlaceItem * _Nonnull hotPlaceItem) {
        [self.view mapDataRequestSuccessWithMapData:mapDataItem hotPlace:hotPlaceItem];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

@end
